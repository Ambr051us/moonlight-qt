# Rolling intra-refresh congestion experiment

This branch changes packet-loss recovery only when reference frame invalidation
(RFI) is negotiated. It is intended to be paired with a Sunshine encoder that
runs continuous rolling intra refresh.

After startup, an unrecoverable network loss now:

- sends RFI feedback to the host without escalating queue pressure to an IDR;
- submits the next complete frame to the decoder instead of disabling
  presentation while waiting for a specially marked recovery frame; and
- leaves explicit decoder refresh, renderer reset, and initial stream startup
  on the normal IDR path.

The change lives in `patches/0001-rfi-congestion-recovery.patch` because
`moonlight-common-c` is an upstream submodule. Windows release builds apply it
automatically through `scripts/build-arch.bat`. For a local Unix build, run:

```sh
scripts/apply-common-patches.sh
qmake6 moonlight-qt.pro
make release
```

The apply helpers are idempotent and fail if the pinned submodule has drifted.
