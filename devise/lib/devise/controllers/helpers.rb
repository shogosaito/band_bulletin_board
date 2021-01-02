def signed_in_root_path(resource_or_scope)
  # モデルオブジェクトが渡されると、deviseでマッピングされたスコープ(usersとか)を返す。
  # もしdeviseでマッピングしているモデルがadminという名前空間に属している場合、:admin_usersになる。
  scope = Devise::Mapping.find_scope!(resource_or_scope)

  # deviseを使うモデルが複数ある場合、mappings(ハッシュ)のうち[scope]を取得し、そのrouter_nameを代入する。
  # router_nameは、Devise::Mappingに対してoptionが渡されないとnilになるから基本nilっぽい。
  router_name = Devise.mappings[scope].router_name
  home_path = "#{scope}_root_path"

  # router_nameは基本nilっぽいので、実行されない。selfはobjectクラスのmain。
  context = router_name ? send(router_name) : self

  # contextに対してhome_pathを呼べるなら実行。trueはhome_pathがプライベートメソッドでも呼ぶよの意味。
  if context.respond_to?(home_path, true)
    context.send(home_path)
  # contextに対して、root_pathを呼べるなら実行。
  elsif context.respond_to?(:root_path)
    context.root_path
  # ただのroot_pathが呼べるなら実行。
  elsif respond_to?(:root_path)
    root_path
  # トップページにリダイレクト
  else
    "/"
  end
end
