Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795792294;
	b=m+p39sQ/7Qql7EAt+S76fxvdbGJ0K6aM72TD+a9Vn0R5wsWBKEhijPNFlYERPcEuA4Ab
	 wVw1rZYT0T34SSaa3eyXLwGqZO0AXJMqXzrjg0VSZ21rbJlSa6i+SKEfPWZmE+xdV0OeW
	 gJRruj4qzZ2gtG3IUPGCl/k1WbYiJBlW4Lx0iqMeZlYynU3p5UCztQYMfwN3pLhDFx30K
	 Sr0g+fEXZWfjVeGD+rlYS9xo33pBY+9C6jqn0IFnabhZj2RwwqwgTVzxfj0BTtRStf+0V
	 Wds8Nc5aVBvxYpKIMOqzXfvLepkqH15mCqYZm7dnyMnR7773k0TAvApXS3vye+Z2nBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795792294;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=wD87qI5TkOwaLeBDNcRrxiySNeMzp5+p17ySQ9flz+o=;
	b=weoSu72yTd1AXESoDsBzK9nZZfVwuBqTT0OGdNKJjC3Rhm3Kr6KtMl0Htdr0viPqjLAO
	 uB/onp48hzjV3zQ35dR6Cl/V72ACiMTnENobfbxYvHgX8TQ6PqQWVM7FUazuszOpd402E
	 loUc2soiqICBW58O4KPFesuwQDF9MFUl/+6dE2667UFhZXQ9SGxJuwrAhumkqqZZY95Ft
	 EpSyPQt23bcDp5em4d9SNMDZPfb98krn+uNcr+mo6MTb2SclhB/wwogmsrbM+/cJ4gB2F
	 qiCeG2RjamSRLQdCqkhTt3d72CnIe+bolECcuhcVfUOWilvpr6yfJ6RHYpNdydoYPig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ORbPrzvP;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88477606A31E;
	Fri, 27 Nov 2026 15:11:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88477606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ORbPrzvP
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4aav3419316;
	Fri, 27 Nov 2026 15:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=wD87qI5TkOwaLeBDNcRrxiySNeMz
	p5+p17ySQ9flz+o=; b=ORbPrzvPU1Sgq6U7n1tKOT3qUo/vOApjhZzQ4jiR74Db
	MF3ZztDsGLFTZIoipKlFEJyAsK388eoW7QSk9Y2BzlknTGwZXyd61NvBANkfw8wJ
	79ENkYgwRBcukQp+corJ0x6/mgg8wuCVsbrZKGfRnnILmty+4nfeqVRKFEboPi0V
	xXe/60V+9Ztrc97fGInNPTI9pomW34PmLDTrImPJhoq/k+0JKvdk/adjMRAhayDV
	sF2YR5i2PqaqIvy4KZsk6aHw9gRbOvIm83Prmu3xfLj81amF9x5bB4qqml0oofbk
	nL0E/O3cWVK5O9Uhhno6hwgqDOZJ+gGY6pDTFwjrHA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fape7b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:19 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE4NJZ3245779;
	Fri, 27 Nov 2026 15:11:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5uxx9a3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 15:11:18 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARFBDe641157086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 15:11:13 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F36B2005A;
	Fri, 27 Nov 2026 15:11:13 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82F662004D;
	Fri, 27 Nov 2026 15:11:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.17.190])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 15:11:10 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: [PATCH v2 00/13] ext4: fix endio zeroout corruption by tracking
 to-be-converted unwritten IOs
Date: Fri, 27 Nov 2026 20:40:47 +0530
Message-Id: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNwQ6CMBAFf4X0bAktZBFP/ofhQNsFNpHWtEBQw
 r9bSLwYPc5LZt7KAnrCwC7JyjzOFMjZCPKUMN03tkNOJjKTmQSRyZzjMhYcrSHHX+gdV1PHUYM
 sGwTR5hWL5sNjS8tRvdWRewqj88/jZBb7+umVP3uz4Bk36mwEiAK0NNc72WlJSQ2pdsN+cfgx8
 N+XAEYqVSEY/eXX27a9AT0VBEP6AAAA
X-Change-ID: 20261023-ext4-endio-zero-bug-ec627ae61f39
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfXy1PwwrVONGst
 5fVBXc007Wji6QzbR8bfnuFwXY1ybNGFuuewoLekQk3uwDTXwso1oJqkPdrf6HysGojEodGJ4AP
 hLhvTXcJYjTxeWz4ouxRVBmnl9keyKHi5gETI/a1PmO3CJs3fVRibKbwD4/O5sbekrvbwQiIzaw
 7Vy9Ojs34kV1eOGVzHzJQRdW3WTHGUBB1pLeecW2GwM4ttpdD2/C4Bp+vl5r0kIOL482DLSEM+m
 oL1Whw/kMSF6mzpS4kg0ggJ3D/0OFOBwnjA1voOZrziIuZJFR2Larfu5ix9ZC2H96zlBO4ps0iu
 tFHZxIXg5PvdIj9ISvYpDcZfUpCIvZDa3ZbXGJ8U/g3XDWu2zR/AhgGvVXnoH7tZ+dCuRDzxhRs
 dIT9tw/sf4WXDQz6rHSNlUbLTCotri1pqRaF4U94sSlmgPn3as7EjoDHch1AoVqoX2+f+V7OJdB
 UqhnioAaDpSR51rcuCQ==
X-Proofpoint-ORIG-GUID: EadmPV3IHjj_mGEBweYto8tRi_WNCnzk
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b099d98 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=NEAV23lmAAAA:8 a=vgSNgNkbMx7QuSeZ4E8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: FsbzdHBwHR0rUFiOxIXQ7U8XH_U1OflP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA2MCBTYWx0ZWRfX6IK8FRiXBh4D
 FM3jicdJvfsuLkFuUi0INp547QbPC1ehAvX90w/P0TIVhqhzhzsYUBLK1x3Z4OLos4W0z/3a/nD
 MOoP2JkMgv/7MkWmaEHd4CMwmG56UvM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611270060

** Changes since v1 **

v1: https://lore.kernel.org/all/20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com

* The design to fix has completely changed from v1. Instead of tracking 
  inflight IOs, we track to-be-converted ranges in the extent status
  cache. This gives us much more accurate accounting

* Most of the details regarding the design are in subsequent patches
  arranged as follows:

  Patch 1: disable zeroout, this can be backported by distros as a quick fix
  Patch 2-4: introduce convert pending es type and helpers to handle it
  Patch 5: introduce get block flags that can be used to add such extents
  Patch 6-8: onboard IO paths to use conv pending tracking
  Patch 9: don't zeroout if conv pending blocks are present in the extent
  Patch 10: add some useful tracepoints
  Patch 11-12: misc fixes
  Patch 13: re enable zeroout fallback

* Testing: this passes my targeted testing for endio corruption (faliing before
  this patch), -g quick tests for 1k, 4k and 64k bs (4k pagesize) and all ext4 
  kunit tests (incl the newly added ones). I plan to run more auto group and
  stress testing parallely.

** Original Cover (Fix design is outdated) **

There is a data corruption in the zeroout fallback
ext4_split_extent_zeroout() when we encounter an error like ENOSPC
while trying to perform endio extent splitting.

The issue was discovered by Fedora coreos community while using 1kb
blocks size on a 64kb pagesize arch like powerpc or aarch64 and the
discussion can be found at [1].

** The Issue **

The issue can be encountered as follows:

1. Make an FS with no reserved to root reserved blocks and fill it
   completely.
2. Delete a file so that ext4_sb_info thinks there is free space but
   mballoc doesnt have any (until txn is committed).
3. Now when endio kicks in it eventually reaches:

ext4_handle_unwritten_extents
  ext4_split_convert_extents
    ext4_split_extent
      ext4_split_extent_at
        ext4_ext_insert_extent
          ext4_new_meta_blocks  // extent tree split/grow needs a block
            ext4_mb_new_blocks
              ext4_claim_free_clusters  // thinks we have free space but mballoc
                                           has none until txn commit frees it
              ext4_mb_regular_allocator
                // return -ENOSPC
    // ext4_split_extent fallsback to zeroout
    ext4_split_extent_zeroout
      // We try to zeroout surrounding unwritten ranges. This code has a bug
         where we zero an unwritten extent which could have valid data on disk 
         whose endio has not yet converted it

The main issue is that zeroout assumes any unwritten extent is valid to
zeroout but it could actually be a soon-to-be-converted extent holding
valid data.

** The fix **

The way this series fixes it is by per-inode tracking the no. of
unwritten IOs that are submitted but not yet converted
(ei->i_conv_pending_ios). If we end up in the zeroout fallback and see
there are such IOs existing in the inode, then we don't zeroout and just
return back the original error. More design notes can be found in
subsequent patches.

For direct IO, ext4_iomap_begin() is called once per mapping and has no
way to account something only once per dio. So we first fix it in a
simple way by relying on inode->i_dio_count which is already
incremented/decremented once per dio. The last patch optimizes this by
moving dio accounting to i_conv_pending_ios as well, by using a custom
ext4_iomap_next() (needed because we want to increment once per
dio). Since iomap_next() infra was added in 7.2+ this can't be
backported so kept this approach separate.

There are other approaches considered like completely disabling zeroout
(not ideal as it's a useful fallback) or tracking the conv_pending ranges
in extent cache (this is an intrusive change) however the current
approach was chosen as a middle ground to balance complexity vs
accuracy of accounting.

** Backport Notes **

This issue seems to have existed ever since we had the zeroout logic
however this was never encountered until we moved extent splitting from
writeback time to endio time in commit:

ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O") (merged
in 7.0)

which changed the dioread_nolock writeback/dio path to submit I/O
without pre-splitting extents, deferring the split to endio. This means
multiple concurrent writes can share a single unwritten extent, and a
failed split on one of them could zeroout data belonging to another,
which exposes this issue in the zeroout logic. 

Note that the issue in zeroout was always present but the above patch
just uncovered it. However, for the purpose of backports, I've used this
patch. Seeing how we never saw this issue before this, hopefully just
backporting it till 7.0 should be fine.

** Testing **

I've tested -g quick for various configurations to catch any obvious
issues or counter leaks, saw no regressions. I'll continue to test for
auto group. I've also added some new tests to hit this regression which
I'll post soon.

[1] https://github.com/coreos/fedora-coreos-tracker/issues/2234

Thoughts and suggestions welcome.

Regards,
ojaswin

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
Ojaswin Mujoo (13):
      ext4: disable zeroout fallback in ext4_split_extent()
      ext4: introduce CONVERT_PENDING extent status type
      ext4: preserve convert pending extents when adding unwrit extents to es cache
      ext4: add es helper to convert unwrit to convert pending without changing i_es_seq
      ext4: add support to track convert pending ranges in ext4_map_blocks()
      ext4: add tracking for unwritten to-be-converted ranges in dio write path
      ext4: add tracking for unwritten to-be-converted ranges in non iomap buffered path
      ext4: add tracking for unwritten to-be-converted ranges in iomap buffered path
      ext4: don't zeroout if conv pending ranges are present
      ext4: add tracepoints for extent split and convert
      ext4: update extent status cache when zeroing extents
      ext4: don't drop the extents in case extent split fails
      ext4: re-enable zeroout fallback

 fs/ext4/ext4.h                |  11 ++-
 fs/ext4/extents.c             |  86 +++++++++++++++++--
 fs/ext4/extents_status-test.c |   8 +-
 fs/ext4/extents_status.c      | 132 +++++++++++++++++++++++-----
 fs/ext4/extents_status.h      |  13 ++-
 fs/ext4/inode.c               | 129 ++++++++++++++++++++++++++--
 fs/ext4/page-io.c             |  43 ++++++++++
 include/trace/events/ext4.h   | 194 +++++++++++++++++++++++++++++++++++++++++-
 8 files changed, 577 insertions(+), 39 deletions(-)
---
base-commit: bae28a1b11f422d0214654800d9425e042295c71
change-id: 20261023-ext4-endio-zero-bug-ec627ae61f39

Best regards,
-- 
Ojaswin Mujoo <ojaswin@linux.ibm.com>

