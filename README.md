# rebrain-k8s-networking
Stuff for webinar @ rebrain

Playlist: [https://youtube.com/playlist?list=PLVsDW8WKTo5FnrmnBBojRd6Pbkc-DuRmr](https://youtube.com/playlist?list=PLVsDW8WKTo5FnrmnBBojRd6Pbkc-DuRmr)

Rebrain: [https://rebrainme.com/](https://rebrainme.com/)

Presentation: [Slides](https://docs.google.com/presentation/d/1X8h9w1hdbe70zHCGW6BZlyqyTGMunaUoiMV96ko_y8s/edit?usp=sharing)
Webinar: TBD

Codez:

- [https://github.com/ciscodevnet/netdevops-live-0213/](https://github.com/ciscodevnet/netdevops-live-0213/)
- [https://github.com/eranyanay/cni-from-scratch](https://github.com/eranyanay/cni-from-scratch)
- [https://github.com/kristenjacobs/container-networking/](https://github.com/kristenjacobs/container-networking/)

## Multiarch build on linux

```
docker run --privileged --rm docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
docker buildx create --use
docker buildx build --push --tag lllamnyp/rebrain-utils:latest --platform linux/amd64,linux/arm64 .
```
