Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3083B3B27CA;
	Thu, 30 Apr 2026 21:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777583921; cv=none; b=qtcjmmTi2usCJCt5+qukCriiBx32Eeyn5eQP5MZBbytD5dFRoqt16QoWubyGptR4attJHVvCAa5R4c0hspNNH3zPhGoKCLEdLqgo2LwbOM21YUBDb9YTPBB2pDXRb0D/qW2x61zinmjo5JRTP2UKAIuftlx1zQIgKGnMLYkRjhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777583921; c=relaxed/simple;
	bh=9x0PmfHpM25qfPfBWDhcq29v0C9cAAtaU+0HmpSl7Mo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=irJOlBDJMDi6B4zxXE2cYnFAdhznArzDZ0E8Tdlf8AlyFkXWLyegYtGtcDwXtqiqdt7IrJIYYYftH5JQxfTn6KKziev0qRP2G2Z/psKwm9GwojaTjvLYUAnWsOMCLyA86TVQGQf0CsUaLo4x+HmaheMXhdxz6kQty1K7eHiDAew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMpZl3ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMpZl3ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086EEC2BCB3;
	Thu, 30 Apr 2026 21:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777583921;
	bh=9x0PmfHpM25qfPfBWDhcq29v0C9cAAtaU+0HmpSl7Mo=;
	h=Date:Subject:From:To:Cc:From;
	b=TMpZl3ueJ7F2+/cw5dKEKeCVEeqMUOuWcs68zcS8OKMAkkT/eNmdFDklr6bLX8beO
	 Fu6UTBSrFEMWTBmmr8HyuVJfr9zMQoyjVqPfXd8XiviHIa8IMLJnUDKf4hkA12RScH
	 QaJ9hGKi/s0b3l35njAo7b1AWcyQH7nkiY90vd+gR6KCtjIDsjEbNExCSxGK3mlyD8
	 3CpnkNplQac6aBl7sXf4ZKZtFXVBo19k7Nnprf5fQh8KVpWzcf2boxIQZ8Uuo+QSNX
	 rEbxNRVaBX1bk+zaiPsFPkBvptaa3O8TJvERO9hCD8HpUKglFZK3R/Mf+i7meKFWXb
	 19roo8FwsM4YA==
Date: Thu, 30 Apr 2026 14:18:40 -0700
Subject: [GIT PULL v5.1] libfuse: run fuse servers as a contained service
From: "Darrick J. Wong" <djwong@kernel.org>
To: bernd@bsbernd.com, djwong@kernel.org
Cc: fuse-devel@lists.linux.dev, joannelkoong@gmail.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, neal@gompa.dev
Message-ID: <177758364789.1315233.15610945404741826500.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Bernd,

Please pull this branch with changes for libfuse.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit f8abf5d1baa9fb689255f7091937081025749158:

Fix a sign bug in prepare_fuse_fd() (2026-04-29 17:50:45 +0200)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/libfuse.git tags/fuse-service-container_2026-04-30

for you to fetch changes up to 055d94404c8aedf3cb434503f4efa7686c35545b:

nullfs: support fuse systemd service mode (2026-04-30 14:13:32 -0700)

----------------------------------------------------------------
libfuse: run fuse servers as a contained service [v5.1 1/9]

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

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Bernd Schubert (1):
Refactor mount code / move common functions to mount_util.c

Darrick J. Wong (12):
mount_service: add systemd socket service mounting helper
mount_service: create high level fuse helpers
mount_service: use the new mount api for the mount service
mount_service: update mtab after a successful mount
util: hoist the fuse.conf parsing and setuid mode enforcement code
util: fix checkpatch complaints in fuser_conf.[ch]
mount_service: enable unprivileged users in a similar manner as fusermount
mount.fuse3: integrate systemd service startup
mount_service: allow installation as a setuid program
example/service_ll: create a sample systemd service fuse server
example/service: create a sample systemd service for a high-level fuse server
nullfs: support fuse systemd service mode

example/single_file.h                            |  195 ++
include/fuse.h                                   |   34 +
include/fuse_service.h                           |  243 +++
include/fuse_service_priv.h                      |  161 ++
lib/fuse_i.h                                     |    3 +
lib/mount_common_i.h                             |   22 +
lib/mount_util.h                                 |    8 +
lib/util.h                                       |   35 +
util/fuser_conf.h                                |   62 +
util/mount_service.h                             |   49 +
.github/workflows/install-ubuntu-dependencies.sh |    4 +
README.md                                        |    3 +
doc/fuservicemount3.8                            |   32 +
doc/meson.build                                  |    3 +
example/meson.build                              |   26 +
example/null.c                                   |   51 +-
example/null.socket.in                           |   15 +
example/null@.service                            |  102 ++
example/service_hl.c                             |  240 +++
example/service_hl.socket.in                     |   15 +
example/service_hl@.service                      |  102 ++
example/service_ll.c                             |  329 ++++
example/service_ll.socket.in                     |   15 +
example/service_ll@.service                      |  102 ++
example/single_file.c                            |  992 ++++++++++
include/meson.build                              |    4 +
lib/fuse_service.c                               | 1248 +++++++++++++
lib/fuse_service_stub.c                          |  106 ++
lib/fuse_versionscript                           |   18 +
lib/helper.c                                     |  160 +-
lib/meson.build                                  |   17 +-
lib/mount.c                                      |   72 +-
lib/mount_util.c                                 |    9 +
meson.build                                      |   53 +-
meson_options.txt                                |    9 +
test/ci-build.sh                                 |   14 +
util/fuser_conf.c                                |  398 ++++
util/fusermount.c                                |  363 +---
util/fuservicemount.c                            |   65 +
util/install_helper.sh                           |    6 +
util/meson.build                                 |   24 +-
util/mount.fuse.c                                |  171 +-
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

Here's the range diff from v5 to v5.1.

 1:  5a6a95b117389d !  1:  af50a468568e3d fs: turn on more warnings for the filesystem code we modify most
    @@ meson.build: base_version = version_parts[0]
     +# W=e
     +if host_machine.cpu_family() == 'x86_64'
     +  WARNINGS += [ '-Werror' ]
     +endif
     +
     +# W=1
    -+WARNINGS += [ '-Wextra', '-Wunused', '-Wno-unused-parameter' ]
    ++WARNINGS += [ '-Wextra', '-Wunused', '-Wunused-parameter' ]
     +WARNINGS += [ '-Wmissing-declarations' ]
     +WARNINGS += [ '-Wrestrict' ]
     +WARNINGS += [ '-Wmissing-format-attribute' ]
     +WARNINGS += [ '-Wmissing-prototypes' ]
     +WARNINGS += [ '-Wold-style-definition' ]
     +WARNINGS += [ '-Wmissing-include-dirs' ]
    @@ meson.build: base_version = version_parts[0]
     +#WARNINGS += [ '-Wsign-compare' ]	# percpu
     +#WARNINGS += [ '-Wswitch-default' ]	# everywhere
     +#WARNINGS += $(call cc-option, -Wpacked-bitfield-compat) # not a gcc thing
     +
     +# Stuff we need to fix in xfsprogs
     +WARNINGS += [ '-Wno-suggest-attribute=format' ]	# dont care about printf crap
    -+WARNINGS += [ '-Wno-shadow' ]	# many programs have global variables
    -+WARNINGS += [ '-Wno-missing-field-initializers' ]	# why is this even a problem?
    ++WARNINGS += [ '-Wshadow' ]	# many programs have global variables
    ++WARNINGS += [ '-Wmissing-field-initializers' ]	# why is this even a problem?
     +WARNINGS += [ '-Wno-sign-compare' ]	# zomg so much macro
    -+WARNINGS += [ '-Wno-dangling-pointer' ]	# gcc 12.2 bug
    ++WARNINGS += [ '-Wdangling-pointer' ]	# gcc 12.2 bug
     +
     +WARNINGS += [ '-Wno-error=type-limits' ]	# rtgroups patchset
     +WARNINGS += [ '-Wno-error=array-bounds' ]	# rtgroups patchset
     +
     +# OpenSSF recommendations March 2025
     +# https://best.openssf.org/Compiler-Hardening-Guides/Compiler-Options-Hardening-Guide-for-C-and-C++.html
     +#WARNINGS += [ '-O2' ]	# already set elsewhere
     +#WARNINGS += [ '-Wall' ]
     +WARNINGS += [ '-Wformat' ]
     +WARNINGS += [ '-Wformat=2' ]
    -+WARNINGS += [ '-Wno-format-nonliteral' ]	# xfs_db and friends fail this everywhere
    ++WARNINGS += [ '-Wno-error=format-nonliteral' ]	# xfs_db and friends fail this everywhere
     +#WARNINGS += [ '-Wconversion' ]
     +WARNINGS += [ '-Wimplicit-fallthrough' ]
     +WARNINGS += [ '-Werror=format-security' ]
     +WARNINGS += [ '-U_FORTIFY_SOURCE' ]
     +WARNINGS += [ '-D_FORTIFY_SOURCE=2' ]	# debian defaults to 2
     +WARNINGS += [ '-D_GLIBCXX_ASSERTIONS' ]
 2:  eda4cf0a9c9400 =  2:  4871909466456d Refactor mount code / move common functions to mount_util.c
 3:  6f098240905230 !  3:  ff81706aa6d6fd mount_service: add systemd socket service mounting helper
    @@ lib/fuse_service.c (new)
     +		.iov_base = buf,
     +		.iov_len = bufsize,
     +	};
     +	union {
     +		struct cmsghdr cmsghdr;
     +		char control[CMSG_SPACE(sizeof(int))];
    -+	} cmsgu;
    ++	} cmsgu = { };
     +	struct msghdr msg = {
     +		.msg_iov = &iov,
     +		.msg_iovlen = 1,
     +		.msg_control = cmsgu.control,
    -+		.msg_controllen = sizeof(cmsgu.control),
    ++
    ++		/*
    ++		 * Do not include padding at the end of the control buffer,
    ++		 * because we don't want to receive fds that we weren't
    ++		 * expecting.
    ++		 */
    ++		.msg_controllen = CMSG_LEN(sizeof(int)),
     +	};
     +	struct cmsghdr *cmsg;
     +	ssize_t size;
     +
    -+	memset(&cmsgu, 0, sizeof(cmsgu));
    ++	/*
    ++	 * A kernel LSM could decide to deny the fd transfer by writing a
    ++	 * negative number (== invalid fd) into the cmsg buffer instead of
    ++	 * installing the fd.  Set the initial fd value to -1 to signal an
    ++	 * invalid fd in case the kernel doesn't even set the cmsg buffer.
    ++	 * It shouldn't do that, but we absolutely don't want a zero here.
    ++	 */
    ++	memset(cmsgu.control, -1, sizeof(cmsgu.control));
     +
     +	size = recvmsg(sf->sockfd, &msg, MSG_TRUNC | MSG_CMSG_CLOEXEC);
     +	if (size < 0) {
     +		int error = errno;
     +
     +		fuse_log(FUSE_LOG_ERR, "fuse: service file reply: %s\n",
    @@ lib/fuse_service.c (new)
     +	    size < offsetof(struct fuse_service_requested_file, path)) {
     +		fuse_log(FUSE_LOG_ERR, "fuse: wrong service file reply size %zd, expected %zd\n",
     +			 size, bufsize);
     +		return -EBADMSG;
     +	}
     +
    ++	if (msg.msg_flags & MSG_CTRUNC) {
    ++		/* SMACK does this */
    ++		fuse_log(FUSE_LOG_ERR,
    ++"fuse: service file reply control data truncated; did an LSM deny SCM_RIGHTS?\n");
    ++		return -EBADMSG;
    ++	}
    ++
     +	cmsg = CMSG_FIRSTHDR(&msg);
     +	if (!cmsg) {
     +		/* no control message means mount.service sent us an error */
     +		return 0;
     +	}
     +	if (cmsg->cmsg_len != CMSG_LEN(sizeof(int))) {
    @@ lib/fuse_service.c (new)
     +	}
     +
     +	ret = __recv_fd(sf, req, req_sz, &fd);
     +	if (ret)
     +		goto out_req;
     +
    ++	if (fd < 0) {
    ++		/* The kernel might have given us an errno instead of an fd */
    ++		fuse_log(FUSE_LOG_ERR, "fuse: service fd transfer failed: %s\n",
    ++			 strerror(-fd));
    ++		ret = fd;
    ++		goto out_req;
    ++	}
    ++
     +	if (ntohl(req->p.magic) != FUSE_SERVICE_OPEN_REPLY) {
     +		fuse_log(FUSE_LOG_ERR, "fuse: service file reply contains wrong magic!\n");
     +		ret = -EBADMSG;
     +		goto out_close;
     +	}
     +	if (strcmp(req->path, path)) {
 4:  82f5466695848e =  4:  2c4995923f9ae2 mount_service: create high level fuse helpers
 5:  e684fb005a841e =  5:  e53ee192306670 mount_service: use the new mount api for the mount service
 6:  13152dd09d7bb0 =  6:  3c58b3ca279cb6 mount_service: update mtab after a successful mount
 7:  ed78d2368a3c15 !  7:  4fa9d76f54011e util: hoist the fuse.conf parsing and setuid mode enforcement code
    @@ util/fuser_conf.c (new)
     +#include <stdlib.h>
     +#include <errno.h>
     +#include <mntent.h>
     +#include <unistd.h>
     +#include <sys/fsuid.h>
     +
    ++#include "fuse_mount_compat.h"
    ++
     +#if defined HAVE_LISTMOUNT
     +#include <linux/mount.h>
     +#include <syscall.h>
     +#include <stdint.h>
     +#endif
     +
 8:  e2f84fca73efb3 =  8:  75ea3fbf340c75 util: fix checkpatch complaints in fuser_conf.[ch]
 9:  ee31248f7b7e31 =  9:  068b0b4b775fc6 mount_service: enable unprivileged users in a similar manner as fusermount
10:  125e8990ce56db ! 10:  4b455b65ca7756 mount.fuse3: integrate systemd service startup
    @@ util/mount.fuse.c: static void drop_and_lock_capabilities(void)
     +	if (ret) {
     +		fprintf(stderr, "%s: could not start %s helper: %s\n",
     +			argv[0], FUSERVICEMOUNT_PROG, strerror(ret));
     +		return MOUNT_SERVICE_FALLBACK_NEEDED;
     +	}
     +
    -+	ret = waitpid(child_pid, &child_status, 0);
    ++	do {
    ++		ret = waitpid(child_pid, &child_status, 0);
    ++	} while (ret < 0 && errno == EINTR);
     +	if (ret < 0) {
     +		fprintf(stderr, "%s: could not wait for %s helper: %s\n",
     +			argv[0], FUSERVICEMOUNT_PROG, strerror(errno));
     +		return MOUNT_SERVICE_FALLBACK_NEEDED;
     +	}
     +
11:  bbc7cbd7a3d185 = 11:  5b8ce2254d15e1 mount_service: allow installation as a setuid program
12:  85aac9e1d35d23 ! 12:  d095eda280909d example/service_ll: create a sample systemd service fuse server
    @@ example/single_file.h (new)
     +/*
     + * FUSE: Filesystem in Userspace
     + * Copyright (C) 2026 Oracle.
     + *
     + * This program can be distributed under the terms of the GNU GPLv2.
     + * See the file GPL2.txt.
    ++ *
    ++ * This file is shared library code for example fuse servers that want to
    ++ * expose a single regular file that wraps another file in a manner that goes
    ++ * beyond simple passthrough.  It is not itself a fuse server.
     + */
     +#ifndef FUSE_SINGLE_FILE_H_
     +#define FUSE_SINGLE_FILE_H_
     +
     +static inline uint64_t round_up(uint64_t b, unsigned int align)
     +{
    @@ example/service_ll.c (new)
     + * This program can be distributed under the terms of the GNU GPLv2.
     + * See the file GPL2.txt.
     + */
     +
     +/** @file
     + *
    -+ * minimal example filesystem using low-level API and systemd service api
    ++ * Minimal example filesystem using low-level API and systemd service API.
    ++ *
    ++ * - Shows how to build a low level FUSE filesystem server that can be managed
    ++ *   by systemd
    ++ * - Enables on-demand filesystem mounting via socket activation
    ++ * - Demonstrates requesting resources from the mount-caller's environment
    ++ * - Allows running FUSE servers with minimal privileges; isolated mount,
    ++ *   network, and pid namespaces; and a separate uid/gid (unlike traditional
    ++ *   FUSE which needs mount permissions and runs in the caller's environment)
     + *
     + * Compile with:
     + *
     + *     gcc -Wall single_file.c service_ll.c `pkg-config fuse3 --cflags --libs` -o service_ll
     + *
     + * Note: If the pkg-config command fails due to the absence of the fuse3.pc
    @@ example/service_ll.c (new)
     + *
     + *     ExecStart=/path/to/service_ll
     + *
     + * to point to the actual path of the service_ll binary.
     + *
     + * Finally, install the service_ll@.service and service_ll.socket files to the
    -+ * systemd service directory, usually /run/systemd/system.
    ++ * systemd service directory, usually /run/systemd/system.  Run these commands
    ++ * to activate:
    ++ *
    ++ *     systemctl daemon-reload
    ++ *     systemctl start service_ll.socket
    ++ *
    ++ * Then mount with:
    ++ *
    ++ *     mount -t fuse.service_ll /dev/sda /mnt
     + *
     + * ## Source code ##
     + * \include service_ll.c
     + * \include service_ll.socket
     + * \include service_ll@.service
     + * \include single_file.c
    @@ example/single_file.c (new)
     +/*
     + * FUSE: Filesystem in Userspace
     + * Copyright (C) 2026 Oracle.
     + *
     + * This program can be distributed under the terms of the GNU GPLv2.
     + * See the file GPL2.txt.
    ++ *
    ++ * This file is shared library code for example fuse servers that want to
    ++ * expose a single regular file that wraps another file in a manner that goes
    ++ * beyond simple passthrough.  It is not itself a fuse server.
     + */
     +#define _GNU_SOURCE
     +#include <pthread.h>
     +#include <errno.h>
     +#include <stdlib.h>
     +#include <errno.h>
    @@ example/single_file.c (new)
     +void single_file_ll_statx(fuse_req_t req, fuse_ino_t ino, int flags, int mask,
     +			  struct fuse_file_info *fi)
     +{
     +	struct statx stx = { };
     +	bool filled;
     +
    -+	(void)flags;
     +	(void)fi;
     +
    ++	if ((flags & AT_STATX_FORCE_SYNC) && is_single_file_ino(ino) &&
    ++	    single_file.backing_fd >= 0) {
    ++		int ret = fsync(single_file.backing_fd);
    ++
    ++		if (ret) {
    ++			fuse_reply_err(req, errno);
    ++			return;
    ++		}
    ++	}
    ++
     +	pthread_mutex_lock(&single_file.lock);
     +	filled = sf_statx(ino, mask, &stx);
     +	pthread_mutex_unlock(&single_file.lock);
     +	if (!filled)
     +		fuse_reply_err(req, ENOENT);
     +	else
    @@ example/single_file.c (new)
     +		if (to_set & FUSE_SET_ATTR_MTIME_NOW)
     +			single_file.mtime = now;
     +		else
     +			single_file.mtime = attr->st_mtim;
     +	}
     +	if (to_set & FUSE_SET_ATTR_CTIME)
    -+		single_file.ctime = attr->st_mtim;
    -+	else
     +		single_file.ctime = now;
     +	pthread_mutex_unlock(&single_file.lock);
     +
     +	single_file_ll_getattr(req, ino, fi);
     +	return;
     +deny:
    @@ example/single_file.c (new)
     +				return -errno;
     +		}
     +
     +		get_now(&now);
     +
     +		pthread_mutex_lock(&single_file.lock);
    ++		single_file.mtime = now;
     +		single_file.ctime = now;
     +		pthread_mutex_unlock(&single_file.lock);
     +
     +		return processed;
     +	}
     +
    @@ example/single_file.c (new)
     +		single_file_name_set = true;
     +	}
     +
     +	get_now(&startup_time);
     +	single_file.atime = startup_time;
     +	single_file.mtime = startup_time;
    ++	single_file.ctime = startup_time;
     +
     +	if (!single_file.ro)
     +		single_file.mode |= 0220;
     +
     +	return 0;
     +}
13:  9702e37fa0895f ! 13:  48f04af4d1cc37 example/service: create a sample systemd service for a high-level fuse server
    @@ example/service_hl.c (new)
     + * This program can be distributed under the terms of the GNU GPLv2.
     + * See the file GPL2.txt.
     + */
     +
     +/** @file
     + *
    -+ * minimal example filesystem using high-level API and systemd service api
    ++ * Minimal example filesystem using high-level API and systemd service API.
    ++ *
    ++ * - Shows how to build a high level FUSE filesystem server that can be managed
    ++ *   by systemd
    ++ * - Enables on-demand filesystem mounting via socket activation
    ++ * - Demonstrates requesting resources from the mount-caller's environment
    ++ * - Allows running FUSE servers with minimal privileges; isolated mount,
    ++ *   network, and pid namespaces; and a separate uid/gid (unlike traditional
    ++ *   FUSE which needs mount permissions and runs in the caller's environment)
     + *
     + * Compile with:
     + *
     + *     gcc -Wall single_file.c service_hl.c `pkg-config fuse3 --cflags --libs` -o service_hl
     + *
     + * Note: If the pkg-config command fails due to the absence of the fuse3.pc
    @@ example/service_hl.c (new)
     + *
     + *     ExecStart=/path/to/service_hl
     + *
     + * to point to the actual path of the service_hl binary.
     + *
     + * Finally, install the service_hl@.service and service_hl.socket files to the
    -+ * systemd service directory, usually /run/systemd/system.
    ++ * systemd service directory, usually /run/systemd/system.  Run these commands
    ++ * to activate:
    ++ *
    ++ *     systemctl daemon-reload
    ++ *     systemctl start service_hl.socket
    ++ *
    ++ * Then mount with:
    ++ *
    ++ *     mount -t fuse.service_hl /dev/sda /mnt
     + *
     + * ## Source code ##
     + * \include service_hl.c
     + * \include service_hl.socket
     + * \include service_hl@.service
     + * \include single_file.c
    @@ example/single_file.c: void single_file_ll_statx(fuse_req_t req, fuse_ino_t ino,
     +	fuse_ino_t ino = single_open_file_path_to_ino(fi, path);
     +	bool filled;
     +
     +	if (!ino)
     +		return -ENOENT;
     +
    ++	if ((statx_flags & AT_STATX_FORCE_SYNC) && is_single_file_ino(ino) &&
    ++	    single_file.backing_fd >= 0) {
    ++		int ret = fsync(single_file.backing_fd);
    ++
    ++		if (ret)
    ++			return -errno;
    ++	}
    ++
     +	pthread_mutex_lock(&single_file.lock);
     +	filled = sf_statx(ino, statx_mask, stx);
     +	pthread_mutex_unlock(&single_file.lock);
     +
     +	return filled ? 0 : -ENOENT;
     +}
    @@ example/single_file.c: void single_file_ll_setattr(fuse_req_t req, fuse_ino_t in
     +		return -EPERM;
     +	if (single_file.ro)
     +		return -EPERM;
     +
     +	pthread_mutex_lock(&single_file.lock);
     +	single_file.mode = (single_file.mode & S_IFMT) | (mode & ~S_IFMT);
    ++	get_now(&single_file.ctime);
     +	pthread_mutex_unlock(&single_file.lock);
     +
     +	return 0;
     +}
     +
     +static void set_time(const struct timespec *ctv, struct timespec *tv)
14:  cd1acb1dc7d492 = 14:  f5597fbd63f7a6 nullfs: support fuse systemd service mode
