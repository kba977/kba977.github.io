# kba977の空想庭院

个人博客源码，基于 [Hexo](https://hexo.io/) 8 + [NexT](https://theme-next.js.org/) 主题，线上地址：<https://kba977.github.io/>

## 分支

- `hexo`：源码（默认分支），在这里写文章
- `master`：生成的静态页面，由 GitHub Pages 托管，不要手动修改

## 本地开发

```bash
npm ci
npx hexo new "文章标题"   # 新建文章，生成在 source/_posts/
npx hexo server           # 本地预览 http://localhost:4000
```

## 发布

推送到 `hexo` 分支后，GitHub Actions（`.github/workflows/deploy.yml`）会自动构建并发布到 `master`。

也可以在本地手动发布：`npx hexo clean && npx hexo deploy`
