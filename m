Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458843;
	b=lh0zPAF96xw9DC2GCtGhhKqYsp5dqzmp4hZwsLJph6t7A2sLhZq1Lb2Jm8KOd5rDCNDN
	 /palbrGoA4d3lr9Xx/yYRGNJY3BrY8p2tEEFW4Yh9Vu44npV+Om0UpqH0XdbNUJRvZlJQ
	 azXDRIAf3A0ZV/ZbW10gxMTLpymvNoMdjNEJtgs0YAZ9zSWF5gqnWcAbDr4yiK6YlpdoE
	 5F/HjK7YO1u1PKca1tK6EeAhz/h6AyYBCB1O3NJb2pSZ61q+nbYwcYc9VMR9Td9zhgEgt
	 AtRq0DQogwKJzqrAjRcIiimV1Kuwhg+fNROPEDXFRByMk6V16wvjsSncWCvVWjrsprg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458843;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wfAtadED3NJM9aYMVROVlR72SwrHmn90J5E5Nv+ArQo=;
	b=qQC/7hoacQFDA4Y7L1kKpQUn/Neo0ktP2UL1BNCtAKzf6seLQpGWGw0xBJWOoBViGEF5
	 apc0hDVgKe3EQFCZTTI3jFp1HkB1ow6o5lW13XtPJJdCux7rDh2i+7oi1PHKpDrfmpH8U
	 tqyqr0PnkgfbRfzq+aats+YUQCJ76p9IDR1H2RDQJd1GF5z3UZCMTEec0R6kYwwl4cBR0
	 /3+dT8CmW/sYOE9u9osi/W/rPWdSQmQDp3YCbm/vUckuXN1Psso9FIfy5qPR0j3VPjz/h
	 YYVP/4VjeUg6s83solVTxVDueZmooh4sJDplThDvoQ6Fhlhhac4wZVgBAtX7BXvYZ0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=CD649tWU;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B5E606A890
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9B5E606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=CD649tWU
Received: from trampoline.thunk.org (pool-173-48-111-191.bstnma.fios.verizon.net [173.48.111.191])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AC4lJFp031130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 23:47:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1794458840; bh=wfAtadED3NJM9aYMVROVlR72SwrHmn90J5E5Nv+ArQo=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=CD649tWUB6UyTeSQ3VcWg1ywtdyGMYHsjJrxiymgRDvOSyFiRSlvUhpLtECk1mgyf
	 f3Oegq2CUekqn8f2HI+JL++gIQUC2E+fc84B0WucDyQhjK2Y5VUoJAB9TXeVRK8HR5
	 JdEWOlbajifKnUq89aiTVWenUE6BT2j6ahpkjmBVmf1VwoXrwZkMntbsRjj4uSpGHi
	 hZRXUqdAuOBIhqwiSAt6Cd9PV0U6QGPHaldKAX6+jOHu4wwR/8AbwBAiosPLMMX4AM
	 hZCoKW0kQ2S91U3v4qzyfyJM7qF2ZEX5JWbxAJHhTv/unFS15vGsN5o16rK7xKG3dU
	 /hft/7uU3OgsA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 21CC42E00BB; Wed, 11 Nov 2026 23:47:19 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 00/23] ext4: lots of misc bug fixes 
Date: Wed, 11 Nov 2026 23:46:49 -0500
Message-ID: <20261112044712.1577296-1-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
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

While an LLM was creating a whole batch of KUnit tests for ext4[1],
the AI found a large number of potential bugs.  After validating the
list of bugs using a smarter LLM, the fixes for the valid bugs are in
this patch set.  A summary of all the bugs, how they are fixed, and
their criticality level --- e.g., "Critical (data loss)", "High
(metadata corruption)", "Low (32-bit compat)", etc. --- can be found
in report-bugfixes.md[2].

[1] https://lore.kernel.org/r/20261112040638.1576836-1-tytso@mit.edu
[2] https://drive.google.com/file/d/1pnTKAVf9pAoCK27619uP4_3_hpE04SkR/view

Some of these bug fixes may be duplicative of the backlog of AI slop
patch backlog (sorry, submitters; I'll be processing them now that the
merge window is closed).

Of course, these patches are *also* potentially AI slop, so while I've
given them a very light review, we'll have to see what Sashiko has to
say, and they need a more in-depth review before they get landed.


Theodore Ts'o (23):
  ext4: only update s_mount_opts when EXT4_TUNE_FL_MOUNT_OPTS is set
  ext4: return -EFSBADCRC when skipping a corrupt backup superblock
  ext4: don't allow enabling casefold via EXT4_IOC_SET_TUNE_SB_PARAM
  ext4: persist the htree hash seed when enabling dir_index online
  ext4: enforce feature prerequisites when tuning a mounted fs
  ext4: handle s_lastcheck_hi in the get/set tune superblock ioctls
  ext4: pass missing ioctls through ext4_compat_ioctl
  ext4: fix inverted err_report_sec check in ext4_update_super()
  ext4: fix err_report_sec_store() timer and value handling
  ext4: fix inode table accounting in count_overhead()
  ext4: handle flex groups straddling s_first_meta_bg in online resize
  ext4: reject EXT4_IOC_GROUP_ADD inputs larger than a block group
  ext4: propagate ext4_alloc_group_tables() errors from ext4_resize_fs()
  ext4: reject online shrink before probing the device size
  ext4: cap migrated extents at EXT_INIT_MAX_LEN
  ext4: don't treat a handle restart as an error in finish_range()
  ext4: don't clobber the migration result in ext4_ext_migrate()
  ext4: fix EOF clamping of the range in mext_check_adjust_range()
  ext4: bound the MMP update and check intervals
  ext4: fix MMP claim of a cleanly unmounted filesystem
  ext4: fix device comparison overflow in ext4_getfsmap_dev_compare()
  ext4: don't allocate over indirect branches that failed to load
  ext4: don't stop EXT4_IOC_GET_ES_CACHE at uncached ranges

 fs/ext4/ext4.h                |   8 +
 fs/ext4/extents-test.c        |  30 +++
 fs/ext4/extents.c             |  13 +-
 fs/ext4/extents_status-test.c |  17 +-
 fs/ext4/extents_status.c      |  23 +++
 fs/ext4/fsmap-test.c          |  56 ++++++
 fs/ext4/fsmap.c               |   2 +-
 fs/ext4/indirect-test.c       |  90 ++++++++-
 fs/ext4/indirect.c            |  19 +-
 fs/ext4/ioctl-test.c          | 356 ++++++++++++++++++++++++++++++++--
 fs/ext4/ioctl.c               | 145 +++++++++-----
 fs/ext4/migrate-test.c        | 210 +++++++++++++++++++-
 fs/ext4/migrate.c             |  20 +-
 fs/ext4/mmp-test.c            | 222 ++++++++++++++++++++-
 fs/ext4/mmp.c                 |  67 +++++--
 fs/ext4/move_extent-test.c    |  21 ++
 fs/ext4/move_extent.c         |   4 +-
 fs/ext4/resize-test.c         | 118 +++++++++++
 fs/ext4/resize.c              |  70 +++++--
 fs/ext4/super-test.c          |  37 ++++
 fs/ext4/super.c               |  28 ++-
 fs/ext4/sysfs-test.c          |  55 ++++++
 fs/ext4/sysfs.c               |  21 +-
 23 files changed, 1504 insertions(+), 128 deletions(-)

-- 
2.56.0.542.g3ef89b7020-goog

