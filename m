Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388653603EC;
	Wed, 22 Apr 2026 23:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776899719; cv=none; b=HzXOdh8GAcrwXWbr8KOTUQB4F2KLNR91pg+4xS+UBwsWFckStfBlyl9vj9LmQ0/OGuPBCN2QfFkblXQZTqfpYpDiaeA//AtjfhFBh0aJHramv+rs+HrrI/CGYCUCGgkYLR26TX2GJG/IKwWucixnrwfeqg87ACrfL8qnOzR1cH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776899719; c=relaxed/simple;
	bh=khYMFcwcpQQ/rAm3j6XnjmxIzjUCcVQaE7L0BC41Yzs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GbG1Etcr50WcxtYaxIa/+KVZXlORTsRGcB1DCoYhcVu7hZFDA70+L60USRkN1ePiZOpftcRoM4fd088tkybYj3RJo4ULQecBbkKDrpov37VesgBxPisHIhHgAepBqoahN8ooUqfPsd4hEZlNzEujD38dNtA4SMJ1nqOXpwn+WAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqxl8GLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqxl8GLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AE6C19425;
	Wed, 22 Apr 2026 23:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776899718;
	bh=khYMFcwcpQQ/rAm3j6XnjmxIzjUCcVQaE7L0BC41Yzs=;
	h=Date:From:To:Cc:Subject:From;
	b=bqxl8GLkiZJOU4z7SAH3Tht5mL6cWpV+Aye1zuXu5lruG23RCL2tmUZrceCSpRP8D
	 I+S4ebpubRkWtso2eGQvpc4RUAdxcijar7kOQWY/ER2tu4UcS44dPybxbzn36raVgS
	 ZwiYZZrylov/MrDLUTefNEYEh5HvpcJhYu3YOEPHJ1XozQ+7PYtOfUtIND9HEWOoJR
	 Zy4CGQ8dEkDSRrSFLyxznjdxfh6owxQPDfhfzdJ3TpgqoPi7UwIoTBL1xgoptgx80c
	 0ZhHhXIxd37UwhPmBMpFQPjypnoQvNfZRSDgsjPHq8wz3WWaNHJSyywxPj4aLGhNGQ
	 Lhu1rNrE5o/xQ==
Date: Wed, 22 Apr 2026 16:15:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, demiobenour@gmail.com
Subject: [PATCHBOMB v5] fuse/libfuse/e2fsprogs/etc: containerize ext4 for
 safer operation
Message-ID: <20260422231518.GA7717@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This *would have been* the eight public draft of the gigantic patchset
to connect the Linux fuse driver to fs-iomap for regular file IO
operations to and from files whose contents persist to locally attached
storage devices.

However, the previous submission was too large, and I didn't even send
half the patches!  I have therefore split the work into two sections.
This first section covers setting up fuse servers to run as contained
systemd services; I previously sent only the libfuse changes, without
any of the surrounding pieces.  Now I'm ready to send them all.

To summarize this patchbomb: fuse servers can now run as non-root users,
with no privilege, no access to the network or hardware, etc.  The only
connection to the outside is an ephemeral AF_UNIX socket.  The process
on the other end is a helper program that acquires resources and calls
fsmount().

Why would you want to do that?  Most filesystem drivers are seriously
vulnerable to metadata parsing attacks, as syzbot has shown repeatedly
over almost a decade of its existence.  Faulty code can lead to total
kernel compromise, and I think there's a very strong incentive to move
all that parsing out to userspace where we can containerize the fuse
server process.  Runtime filesystem metadata parsing is no longer a
privileged (== risky) operation.

The consequences of a crashed driver is a dead mount, instead of a
crashed or corrupt OS kernel.

Note that contained fuse filesystem servers are no faster than regular
fuse.  The redesign of the fuse IO path via iomap will be the subject of
the second patchbomb.  The containerization code only requires changes
to libfuse and is ready to go today.

Since the seventh submission, I have made the following changes:

1) Added a couple of simple fuse service drivers to the example code

2) Adapted fuservicemount to be runnable as a setuid program so that
unprivileged users can start up a containerized filesystem driver

3) Fixed some endianness handling errors in the socket protocol between
the new mount helper and the fuse server

4) Added a high level fuse_main function so that fuse servers that use
the high level api can containerize without a total rewrite

5) Adapted mount.fuse to call the new mount helper code so that mount -t
fuse.XXX can try to start up a contained server

6) Cleaned up a lot of cppcheck complaints and refactored a bunch of
repetitious code

7) Started using codex to try to find bugs and security problems with
the new mount helper

There are a few unanswered questions:

a. How to integrate with the SYNC_INIT patches that Bernd is working on
merging into libfuse

b. If /any/ of the new fsopen/fsconfig/fsmount/move_mount calls fail,
do we fall back to the old mount syscall?  Even after printing errors?

c. Are there any Linux systems where some inetd implementation can
actually handle AF_UNIX sockets?  Does it make sense to try to do the
service isolation without the convenience of systemd directives?

d. meson/autoconf/cmake are a pain to deal with, hopefully the changes I
made are correct

I have also converted a handful more fuse servers (fat, exfat, iso,
http) to the new service architecture so that I can run a (virtual)
Debian system with EFI completely off of containerized fuse servers.
These will be sent at the end.

libfuse:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/libfuse.git/log/?h=fuse-service-container_2026-04-22

e2fsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse4fs-service-container_2026-04-22

fstests:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuse2fs_2026-04-22

--Darrick

Unreviewed patches in this patchbomb:

[PATCHSET v5] libfuse: run fuse servers as a contained service
  [PATCH 02/13] mount_service: add systemd socket service mounting
  [PATCH 03/13] mount_service: create high level fuse helpers
  [PATCH 04/13] mount_service: use the new mount api for the mount
  [PATCH 05/13] mount_service: update mtab after a successful mount
  [PATCH 06/13] util: hoist the fuse.conf parsing and setuid mode
  [PATCH 07/13] util: fix checkpatch complaints in fuser_conf.[ch]
  [PATCH 08/13] mount_service: enable unprivileged users in a similar
  [PATCH 09/13] mount.fuse3: integrate systemd service startup
  [PATCH 10/13] mount_service: allow installation as a setuid program
  [PATCH 11/13] example/service_ll: create a sample systemd service
  [PATCH 12/13] example/service: create a sample systemd service for a
  [PATCH 13/13] nullfs: support fuse systemd service mode
[PATCHSET 1/2] libext2fs: fix some missed fsync calls
  [PATCH 1/3] libext2fs: always fsync the device when flushing the
  [PATCH 2/3] libext2fs: always fsync the device when closing the unix
  [PATCH 3/3] libext2fs: only fsync the unix fd if we wrote to the
[PATCHSET v5 2/2] fuse4fs: run servers as a contained service
  [PATCH 01/10] libext2fs: make it possible to extract the fd from an
  [PATCH 02/10] libext2fs: fix checking for valid fds in mmp.c
  [PATCH 03/10] unix_io: allow passing /dev/fd/XXX paths to the unixfd
  [PATCH 04/10] libext2fs: fix MMP code to work with unixfd IO manager
  [PATCH 05/10] libext2fs: bump libfuse API version to 3.19
  [PATCH 06/10] fuse4fs: hoist some code out of fuse4fs_main
  [PATCH 07/10] fuse4fs: enable safe service mode
  [PATCH 08/10] fuse4fs: set proc title when in fuse service mode
  [PATCH 09/10] fuse4fs: make MMP work correctly in safe service mode
  [PATCH 10/10] debian: update packaging for fuse4fs service
