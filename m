Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794283015;
	b=m+PQ/eQnePtKSGB6dbcUwI8OIodYIA8AZL8b+pSi28i4eZxadkClBUHSq0c4W3AZ2MgV
	 pbgWQDv6mDN81gfd5lWviKM+OPge6iGHsxpW7bzsAQ+8eOMWfj30nsZ8j/gY5YWp7yd4z
	 QCsslvnKSpR3A0VCz5u3qtUHbLO1+GZyMVNHLe3DdXYvKX2X/lSXZNHrCq62phrvzcVsI
	 w45VqzoAboT9WYfbNobRdFT28tf0lPMcnRjK6XUcaI+bIgj1FIy9Eez6QQHCsMIxcOLTY
	 mKbxJemkReL9hl8+6uR1/8eQZt6CjeuTkANEfjhkwwgB2fZVnVV7Kzz8bG/fw9hdJ9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283015;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:To;
	bh=VF9xPD1UxGGIGUVTfJN9R1dvCFJeVt/4y/3Tmnizjmc=;
	b=YZdaSDJFhUG+/4oUcwoXXFWfHDJgTSXwT7l0owK9R3urdS1WC0a0Br7mBcrTaFnsdsRV
	 81AuR9Ex8gm0Z+wiKn/j7nqvB/Prn98OTmYcKqNq9Rjq3V6THE6FoFvTE+5FssN678WG6
	 bXvk2ttmUu5THBxslhGu7ycj2GVlfmap+3kaBjS9MtxlWTSYE8DfHGqgh3YMOfX8REOOj
	 Hk5X8DGHqLcJcS2vUwCV/UZHSM2aAXFmFjEqhHFuOfRcR/n9BnOs9gZVjoohQ/MSs13t8
	 pHp12UktWd7aDe9jcSU7dy9e8yQIHcrg54NcaqltOjBcIzCYdp3rqxOwHBaD+lavI4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RtwbOI4h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F2A60A2627
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 03:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RtwbOI4h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7841F0089F
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 03:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283014;
	bh=VF9xPD1UxGGIGUVTfJN9R1dvCFJeVt/4y/3Tmnizjmc=;
	h=Subject:From:Date:To;
	b=RtwbOI4hwK7vyjRK/QNrzDNLi+sTxxDlcak/oizVkXmAKDroLu99KekuumTD8peoY
	 5ddd7iSc83DHNqVzCEf61ApmZcvrpjlp2Xb4ftky1Z8Up34LfZmLAZxwYYfEaYBO7s
	 7wf4iwaX1v1v2FaZ7BLJ2iVYqwO52UE+19qhmsjlTPdLfV3667o95W12qtjppffW4x
	 bo6Tpk/MF6K2N6XfM2+VO4r5oWKNNBsnhFZfIMgDC491Hl/NrpcYV3Zvw2g2dUAQQl
	 HhxdE2IRMA6EyqJXFNlUfUsL2P8iIky5ZzFdwPFSFi7zz2ioFBxm7aL+9ijLd0y6I5
	 VcQIItrBuqk9w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5E583391AFE9
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 03:56:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Patchwork housekeeping for: ext4
From: patchwork-bot+linux-ext4@kernel.org
Message-Id: 
 <179428301296.3652848.3574434233767654159.git-patchwork-housekeeping@kernel.org>
Date: Tue, 10 Nov 2026 03:56:52 +0000
To: linux-ext4@vger.kernel.org

Latest series: [v3] ext4: fix soft lockup while shrinking the extent status cache (2026-11-09T03:13:56)
  Superseding: [v2] ext4: fix soft lockup while shrinking the extent status cache (2026-11-04T03:35:39):
    [v2] ext4: fix soft lockup while shrinking the extent status cache
  Superseding: [v2] ext4: fix soft lockup while shrinking the extent status cache (2026-11-06T03:31:41):
    [v2] ext4: fix soft lockup while shrinking the extent status cache

Latest series: [v8] ext4: fix slab-use-after-free in do_split() (2026-11-05T02:11:46)
  Superseding: [v1] ext4: fix slab-use-after-free in do_split() (2026-11-04T08:12:37):
    ext4: fix slab-use-after-free in do_split()
  Superseding: [v2] ext4: fix slab-use-after-free in do_split() (2026-11-04T08:47:19):
    [v2] ext4: fix slab-use-after-free in do_split()
  Superseding: [v3] ext4: fix slab-use-after-free in do_split() (2026-11-04T09:21:41):
    [v3] ext4: fix slab-use-after-free in do_split()
  Superseding: [v4] ext4: fix slab-use-after-free in do_split() (2026-11-04T09:51:55):
    [v4] ext4: fix slab-use-after-free in do_split()
  Superseding: [v5] ext4: fix slab-use-after-free in do_split() (2026-11-04T10:10:38):
    [v5] ext4: fix slab-use-after-free in do_split()
  Superseding: [v6] ext4: fix slab-use-after-free in do_split() (2026-11-05T00:38:17):
    [v6] ext4: fix slab-use-after-free in do_split()
  Superseding: [v7] ext4: fix slab-use-after-free in do_split() (2026-11-05T01:01:52):
    [v7] ext4: fix slab-use-after-free in do_split()

Latest series: [v2] alloc_tag: don't remove /proc/allocinfo under the codetag module lock (2026-11-04T19:06:06)
  Superseding: [v2] alloc_tag: don't remove /proc/allocinfo under the codetag module lock (2026-11-04T17:27:18):
    [v2,01/51] alloc_tag: don't remove /proc/allocinfo under the codetag module lock
    [v2,02/51] scsi: esas2r: don't copy kernel pointers out in EXPRESS_IOCTL_GET_MOD_INFO
    [v2,03/51] ALSA: cs46xx: hand the region to the region proc files
    [v2,04/51] PNP: isapnp: don't go on when isapnp_cfg_begin() fails
    [v2,05/51] xtensa: simdisk: remove the proc entry before the disk
    [v2,06/51] powerpc/pseries: put the node that the ofdt property commands look up
    [v2,07/51] lockd: don't hand out the terminator of nlm_end_grace
    [v2,08/51] powerpc/pseries/lparcfg: don't drop the last byte of a write
    [v2,09/51] profiling: report it when /proc/profile can't be created
    [v2,10/51] zorro: size the proc files like what they serve
    [v2,11/51] sparc: led: consume the whole write
    [v2,12/51] powerpc/rtas: consume the whole write to /proc/powerpc/rtas/progress
    [v2,13/51] sched/psi: don't drop the last byte of a trigger write
    [v2,14/51] proc: sysctl: don't stop readdir at an entry that is being unregistered
    [v2,15/51] PCI/proc: don't truncate the position of config space accesses
    [v2,16/51] PNP: isapnp: don't read past the end of the buffer on a large pread()
    [v2,17/51] s390/dasd: don't look in front of the buffer on an empty write
    [v2,18/51] platform/x86: toshiba_acpi: reject malformed brightness and fan writes
    [v2,19/51] xtensa: simdisk: don't read the file name without the lock
    [v2,20/51] powerpc/rtas_flash: don't read past the validate message
    [v2,21/51] powerpc/rtasd: zero the error log buffer
    [v2,22/51] ALSA: info: don't write past the end of a data entry
    [v2,23/51] scsi: BusLogic: don't return 0 from writes to the proc file
    [v2,24/51] scsi: ips: don't return 0 from writes to the proc file
    [v2,25/51] wifi: libipw: don't return 0 from writes to debug_level
    [v2,26/51] scsi: core: NUL-terminate what is written to the host proc files
    [v2,27/51] um: NUL-terminate what is written to /proc/exitcode
    [v2,28/51] ntfs3: don't warn when a huge label is written
    [v2,29/51] proc: don't walk through a non-directory when resolving a name
    [v2,30/51] net: pktgen: reject device names with a '/'
    [v2,31/51] proc: don't WARN about a name that is already registered
    [v2,32/51] proc: resume readdir after the last name it returned
    [v2,33/51] selftests/proc: check a /proc listing while entries come and go
    [v2,34/51] proc: let proc_remove() remove the entry it was given
    [v2,35/51] proc: warn about entries left in /proc/net of a dying namespace
    [v2,36/51] proc: don't let NOMMU map procfs files
    [v2,37/51] proc/vmcore: don't let vmcore_cleanup() run twice at once
    [v2,38/51] powerpc/crash_dump: check ioremap_cache() in copy_oldmem_page()
    [v2,39/51] powerpc/crash_dump: recover from a machine check in copy_oldmem_page()

Latest series: [v2] fsverity: lift ioctl() input masking and runtime inode flag to VFS (2026-11-05T11:55:27)
  Superseding: [v1] fsverity: lift ioctl() input masking and runtime inode flag to VFS (2026-11-04T19:46:10):
    [1/5] fsverity: strip FS_VERITY_FL from FS_IOC_SETFLAGS
    [2/5] fsverity: add I_VERITY_BUILDING inode state flag
    [3/5] btrfs: use I_VERITY_BUILDING instead of private flags
    [4/5] ext4: use I_VERITY_BUILDING instead of private flags
    [5/5] f2fs: use I_VERITY_BUILDING instead of private flags

Latest series: [v3] fs: reclaim inodes with I_METADATA_WRITEBACK (2026-11-09T16:51:15)
  Superseding: [v2] fs: reclaim inodes with I_METADATA_WRITEBACK (2026-11-05T12:41:29):
    [RFC,v2,01/13] ext2: add ext2_inode_block() helper
    [RFC,v2,02/13] ext2: don't read the inode block in ext2_sync_inode_metadata()
    [RFC,v2,03/13] ext2: sync inode metadata in ext2_evict_inode()
    [RFC,v2,04/13] ext4: use sb_find_get_block_nonatomic() in ext4_get_inode_loc_noio()
    [RFC,v2,05/13] ext4: don't read the inode block in ext4_sync_inode_metadata()
    [RFC,v2,06/13] ext4: sync inode metadata in ext4_evict_inode()
    [RFC,v2,07/13] minix: add minix_inode_block() helper
    [RFC,v2,08/13] minix: don't read the inode block in minix_sync_inode_metadata()
    [RFC,v2,09/13] minix: sync inode metadata in minix_evict_inode()
    [RFC,v2,10/13] udf: don't allocate the inode block in udf_sync_inode_metadata()
    [RFC,v2,11/13] udf: sync inode metadata in udf_evict_inode()
    [RFC,v2,12/13] fat: sync inode metadata in fat_evict_inode()
    [RFC,v2,13/13] fs: don't strand I_METADATA_WRITEBACK inodes outside the LRU

Latest series: [v3] ext4: validate extent root during fast commit replay (2026-11-09T22:12:11)
  Superseding: [v2] ext4: validate extent root during fast commit replay (2026-11-08T20:19:06):
    [v2] ext4: validate extent root during fast commit replay

Checked 24 series in 8.25 seconds.
This project currently has 321 active patches.


-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html

