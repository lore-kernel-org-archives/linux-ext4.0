Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D8D2F7EF5
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 19:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782415984; cv=none; b=ZUxNRd7V8xTRB4a2EsRJa/pEIolyk5xZQznnJ7ZV3OgVWtJbtqX3FoEL4iuoAhjT7clRW81qYyeOo7al6dQfcp5/LHurSnkrodTxi5EaYu9u5GmyBiktIxAkEgQ5SDMysddt/P68VRsCjv4Azz02YXhjVN9Jxa7e59keGAs/ie4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782415984; c=relaxed/simple;
	bh=6uijaaaALue/h6vErvNK6z8yMCOz8K9Ug3cIbHLlcNo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TLQRUwzuuAUUuqOGQfz/KghHwaCrG+dl4UF2mgQ1y1IkAv8/+fUw4VTsHdKVPx4Ij6cEt4BJtroZh5xYiEspA1MlC+Z12Lj0IdHq91+FjJh2jaT6VbnaP7YiPrxjb5NaZDgFmm2Zz3ccg9FzOUWkDEJHE480lA/5FlKsSqixjgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GqRdSa2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GqRdSa2/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BBACE1F00A3A;
	Thu, 25 Jun 2026 19:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782415982;
	bh=A5c5c2TLfZXDP2cBdgCaWWe0V/c6PAhDLPSDpHlwjdU=;
	h=Date:From:To:Cc:Subject;
	b=GqRdSa2//jcS0sbkY5M/jK+ubLjmhGRHMKKeTORGDg7kK2J8D1Ln84Z4gX6VJ0ykq
	 7ujCntsu4mXUadb0NP1tt9dGlFFY3Jrqx/Zdq8KuulZ7ZuvD4mkrB0XuC6DPyTEqHI
	 w3sMgn91FyM3Vbj45HKshL9su2RUXGZtVjCDaK9E32nlIzg5B5Z8Ho+lB39xZobPQX
	 sx0pu2S5UOAtR/+c3oFsugWUGbtcEbNMPa4wNI2eNK7dorRYoRXC/gSQT2yGJW8WIL
	 +efJogJ4mnxe1NUgjxLYeMYRRXKSoejN7tVQnEISQOL+HfMVhsF7rk6lFttaOfie/O
	 Kjd3FG1SN3LOg==
Date: Thu, 25 Jun 2026 12:33:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>
Subject: [PATCHBOMB v6] e2fsprogs: containerize ext4 for safer operation
Message-ID: <20260625193302.GC6054@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This is the sole remaining part of the gigantic patchset to enable
mounting ext4 filesystems as a systemd-contained fuse server instead of
in the kernel.  The libfuse parts have now been merged upstream, which
means that fuse4fs can now run as a non-root user, with no privilege,
and no access to the network or hardware, etc.  The only connection to
the outside is an ephemeral AF_UNIX socket.  The mount helper program
the other end is a helper program that acquires resources and calls
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
fuse.  The containerization code only requires changes to libfuse and is
ready to go today.

e2fsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse4fs-service-container_2026-06-25

Note that I threw in a couple more patchsets to improve the caching
behavior of libext2fs for better performance; and the ability to watch
for memory pressure complaints from the kernel so that we can drop our
own cache in response to memory pressure.

e2fsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse4fs-memory-reclaim_2026-06-25

--Darrick

Unreviewed patches in this patchbomb:

[PATCHSET 1/4] libext2fs: fix some missed fsync calls
  [PATCH 1/3] libext2fs: always fsync the device when flushing the
  [PATCH 2/3] libext2fs: always fsync the device when closing the unix
  [PATCH 3/3] libext2fs: only fsync the unix fd if we wrote to the
[PATCHSET v6 2/4] fuse4fs: run servers as a contained service
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
[PATCHSET v6 3/4] fuse2fs: improve block and inode caching
  [PATCH 1/6] libsupport: add caching IO manager
  [PATCH 2/6] iocache: add the actual buffer cache
  [PATCH 3/6] iocache: bump buffer mru priority every 50 accesses
  [PATCH 4/6] fuse2fs: enable caching IO manager
  [PATCH 5/6] fuse2fs: increase inode cache size
  [PATCH 6/6] libext2fs: improve caching for inodes
[PATCHSET v6 4/4] fuse4fs: reclaim buffer cache under memory pressure
  [PATCH 1/4] libsupport: add pressure stall monitor
  [PATCH 2/4] fuse2fs: only reclaim buffer cache when there is memory
  [PATCH 3/4] fuse4fs: enable memory pressure monitoring with service
  [PATCH 4/4] fuse2fs: flush dirty metadata periodically
