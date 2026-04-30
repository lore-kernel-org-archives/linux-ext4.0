Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4647F2EF653;
	Thu, 30 Apr 2026 21:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583712; cv=none; b=e6KI+xhutArLETpOOTrPBmdifew3y8M4hP11Ydypp5/85uT+d6AJvsZ6dMY0dareYdf0IfMfbD69egGnvz5zx9zOqaV7Yyct62AszJ1WRldfqJDSmGhkc9rVzeQkWHaPcvbbKpLd+jyUlYybLeSKSYh26zgl1et4gWDZYQ6JQcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583712; c=relaxed/simple;
	bh=aoOFAQdEHetNra8ZBV5i3tjYRbiE0hW41hJs/mFbCeo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=o7fm9U10d5rwSaBNUpZ6fDkeX1Vq3ywAlXFC8qCjwEZn7PM9hkOaq4RiTXWAXgm4ps7Q9UZJWDazVMMjdFCljd62D7VDax3navR3wgh2KufgBVuH/cBotEI3tBHoQH4FEplWuo7HM3RBGvqWPP3icyP157xp64V3BwiQU1mSah0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1Op7dnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1Op7dnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1578CC2BCB3;
	Thu, 30 Apr 2026 21:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583712;
	bh=aoOFAQdEHetNra8ZBV5i3tjYRbiE0hW41hJs/mFbCeo=;
	h=Date:Subject:From:To:Cc:From;
	b=H1Op7dnJRBP6WjqbnkILMNm5yRNHG+2/A7CubKDwnPtg734r8AIe9aaiqzo8Im9Xt
	 lfeXQcljhdgaY0ZKDdTkqcQrba3Z9mQ6rbQSGnF4X6ZYuMarphkdbkBDbBd93bl+Qm
	 ePeu7g94bxUCOkfQq+8MsSDDRPIFv7NNDXO9SS6TcE9ZvdqG7w/9JP8gJ+JMlOG65h
	 FxFuSBcaIeAH7ySADcCt2jzl9oOKe5MsqG/UxWKqmK2sAx9UDAXLz/Ivgmx052vUpy
	 hSOTOT9hc3WIEW99v7ilIhve57H0s8Yb08z3SaY+qijUsW/N5hlJl/65J2bkgHVCdN
	 gqw4Z6DLWmwPQ==
Date: Thu, 30 Apr 2026 14:15:11 -0700
Subject: [PATCHSET v5.1] libfuse: run fuse servers as a contained service
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-ext4@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev,
 joannelkoong@gmail.com
Message-ID: <177758363484.1314717.11777978893472254088.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patchset defines the necessary communication protocols and library
code so that users can mount fuse servers that run in unprivileged
systemd service containers.  That in turn allows unprivileged untrusted
mounts, because the worst that can happen is that a malicious image
crashes the fuse server and the mount dies, instead of corrupting the
kernel's memory.

v5.1: fix some of the SCM_RIGHTS handling code, fix header inclusion
      errors, improve documentation of example code, improve statx
      flags handling, improve phony timestamp handling
v5: Refactor socket IO into helpers, tighten the security checks in
    mount_service.c, always set nosuid/nodev for unprivileged mounts,
    use posix_spawnp in mount.fuse, restructure sample programs and hl
    library code to avoid the need for unmounting during startup
v4.1: fix various cppcheck/codecheck complaints
v4: fix a large number of security problems that only matter when the
    mount helper is being run as a setuid program; fix protocol
    byteswapping problems; add CLOEXEC to all files being traded
    back and forth; add an umount command; and strengthen mount socket
    protocol checks.
v3: refactor the sample code to reduce duplication; fix all the
    checkpatch complaints; examples actually build standalone;
    fuservicemount handles utab now; cleaned up meson feature detection;
    handle MS_ flags that don't translate to MOUNT_ATTR_*
v2: cleaned up error code handling and logging; add some example fuse
    service; fuservicemount3 can now be a setuid program to allow
    unprivileged userspace to fire up a contained filesystem driver.
    This could be opening Pandora's box...
v1: detach from fuse-iomap series

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fuse-service-container
---
Commits in this patchset:
 * Refactor mount code / move common functions to mount_util.c
 * mount_service: add systemd socket service mounting helper
 * mount_service: create high level fuse helpers
 * mount_service: use the new mount api for the mount service
 * mount_service: update mtab after a successful mount
 * util: hoist the fuse.conf parsing and setuid mode enforcement code
 * util: fix checkpatch complaints in fuser_conf.[ch]
 * mount_service: enable unprivileged users in a similar manner as fusermount
 * mount.fuse3: integrate systemd service startup
 * mount_service: allow installation as a setuid program
 * example/service_ll: create a sample systemd service fuse server
 * example/service: create a sample systemd service for a high-level fuse server
 * nullfs: support fuse systemd service mode
---
 example/single_file.h                            |  195 ++
 include/fuse.h                                   |   34 
 include/fuse_service.h                           |  243 +++
 include/fuse_service_priv.h                      |  161 ++
 lib/fuse_i.h                                     |    3 
 lib/mount_common_i.h                             |   22 
 lib/mount_util.h                                 |    8 
 lib/util.h                                       |   35 
 util/fuser_conf.h                                |   62 +
 util/mount_service.h                             |   49 +
 .github/workflows/install-ubuntu-dependencies.sh |    4 
 README.md                                        |    3 
 doc/fuservicemount3.8                            |   32 
 doc/meson.build                                  |    3 
 example/meson.build                              |   26 
 example/null.c                                   |   51 +
 example/null.socket.in                           |   15 
 example/null@.service                            |  102 +
 example/service_hl.c                             |  240 +++
 example/service_hl.socket.in                     |   15 
 example/service_hl@.service                      |  102 +
 example/service_ll.c                             |  329 +++
 example/service_ll.socket.in                     |   15 
 example/service_ll@.service                      |  102 +
 example/single_file.c                            |  992 ++++++++++
 include/meson.build                              |    4 
 lib/fuse_service.c                               | 1248 +++++++++++++
 lib/fuse_service_stub.c                          |  106 +
 lib/fuse_versionscript                           |   18 
 lib/helper.c                                     |  160 ++
 lib/meson.build                                  |   17 
 lib/mount.c                                      |   72 +
 lib/mount_util.c                                 |    9 
 meson.build                                      |   53 +
 meson_options.txt                                |    9 
 test/ci-build.sh                                 |   14 
 util/fuser_conf.c                                |  398 ++++
 util/fusermount.c                                |  363 ----
 util/fuservicemount.c                            |   65 +
 util/install_helper.sh                           |    6 
 util/meson.build                                 |   24 
 util/mount.fuse.c                                |  171 ++
 util/mount_service.c                             | 2111 ++++++++++++++++++++++
 43 files changed, 7287 insertions(+), 404 deletions(-)
 create mode 100644 example/single_file.h
 create mode 100644 include/fuse_service.h
 create mode 100644 include/fuse_service_priv.h
 create mode 100644 lib/mount_common_i.h
 create mode 100644 util/fuser_conf.h
 create mode 100644 util/mount_service.h
 create mode 100644 doc/fuservicemount3.8
 create mode 100644 example/null.socket.in
 create mode 100644 example/null@.service
 create mode 100644 example/service_hl.c
 create mode 100644 example/service_hl.socket.in
 create mode 100644 example/service_hl@.service
 create mode 100644 example/service_ll.c
 create mode 100644 example/service_ll.socket.in
 create mode 100644 example/service_ll@.service
 create mode 100644 example/single_file.c
 create mode 100644 lib/fuse_service.c
 create mode 100644 lib/fuse_service_stub.c
 create mode 100644 util/fuser_conf.c
 create mode 100644 util/fuservicemount.c
 create mode 100644 util/mount_service.c

