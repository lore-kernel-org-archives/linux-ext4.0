Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644029;
	b=uKP8uW3Gq8pj3gopLspqdVRY3xvIUGPb/ntn3Qfz6TSvwpIq6ZT7LoOVRxCAAvffDW6C
	 j5Z1ft75BoWL6g9rWv0R88BI2utL/1vh3TyNKq9fWA6M5YbIdpEzqXHh2akdrjdb7daQg
	 T1djspTUfMhBLsB/oeC7kzPm3o+OvYEWKPKM2Aq8nXDI6/bXBFzpaDKWDO7vCimFUHadu
	 BlHzva74+gJ0TOYRsUiele9xoweJJ70dOJ3jISwt3AKWB5dkq/EC2PDn5L15Txz3+TB3n
	 pPIIjIwRRRXmAH9odIH6b9mXQjT2DG8zJE7yTuIZfJigOn+psMpn6gVX61H7nlkWS4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644029;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=6lqRgH+b5HJJxHTrfqu7S2kyxgaPyOjJy+M+RMuRTvs=;
	b=4+Ne158Zcs8hbhNvZCDLz34GGjRxQJK3XN4UezluF2TB1Z3eXkmbx/Y8IfzpJRZnj56x
	 d6wGfjh+N9cNPxHhzpvOikQjy4+C7wGNaB+tEjwkB3EBF8Ljb/ryd9hGI0luXC0h+omyq
	 h5Aw+Q47txeNqrkbw84o5aJ3UBobbYQp9vkKgE+d0Nc5EUEKMgh09yOWGaSVfzryWpwox
	 f6oxhxDxIHqIMjq6sjh8hs+8Qnu/rBFxPSnB0xG+k7AuxiXe3N6j1ZEdDGt+drfooJYHm
	 HubpmQVpcbeZJO1WXwxcQZVnZH9nGED64vwL/LOqsm3nnmWJ2AkqJVYW2THeIqIPMzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gBPvGdk0;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B31606A324;
	Mon,  2 Nov 2026 18:27:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1B31606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=gBPvGdk0
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HiOLB3547514;
	Mon, 2 Nov 2026 18:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=6lqRgH+b5HJJxHTrfqu7S2kyxgaP
	yOjJy+M+RMuRTvs=; b=gBPvGdk0OrfCacRJVEuESWhJMph61wWEZ01HgovpNaA3
	4MxxbISg50bpCCUcIDidvNibeEwC2MxuNj5ME6vD15Aym9kDhbfGaUuNnIDAG9QX
	X36rIqo9xa9Ss/v3C2RZS8qtgjzcbUZhMcShU8kHjM1WIja3k0/IGu6vZH7vuVyl
	qYa12mJwXe8vuKQlwYgp67a+cFj7yHEzWQHDlNUpBNPlV+1GdcpXphnMFNHqc2cT
	xwA1HpBv+y3K71F/JWbuuCdbeh+4FbWHIj8r6Gnozmd9A7HWWgr1eATExMaux33G
	oWkwhJzC+sddtg2BCEkku/xcKKmIw+1PpTFbJx86aw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn826j638-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:26:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HYuNR1313038;
	Mon, 2 Nov 2026 18:26:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hnwbxy0gq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:26:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A2IQr0j56164780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Nov 2026 18:26:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8411F20043;
	Mon,  2 Nov 2026 18:26:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7539B20040;
	Mon,  2 Nov 2026 18:26:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.25.71])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Nov 2026 18:26:51 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: [PATCH 0/8] ext4: fix endio zeroout corruption by tracking
 to-be-converted unwritten IOs
Date: Mon, 02 Nov 2026 23:56:15 +0530
Message-Id: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NQQ6CMBBFr0K6dghTSFFX3sOwgHaASaQ1LTQo4
 e5WEncu30v++5sI5JmCuGab8BQ5sLMJ8JQJPbZ2IGCTWMhCKixkCbTOFZA17OBN3kG3DEBaybo
 lhX15EWn59NTzelTvTeKRw+z86ziJ+LW/Xv23FxEKMN3ZoMJKaWluD7bLmnM35dpNotn3/QOvR
 4YWugAAAA==
X-Change-ID: 20261023-ext4-endio-zero-bug-ec627ae61f39
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: GadAIBSVajgIngUWgfi3S7AR-D-8PXGH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX7IEdGR5puDrs
 5Sfq4Bo7m2fHJPLUvN0pznVKNy1SewrXWONezfMPZGd6FET+jFXgRT8LNI3DEUjHhQAln+QVGJs
 2od5GCffvZzvW5lTED/Tl2K/Qyt3f0XDEDFArEzwmwSpVyh/irW7e7wNCjDobomZEhX0V1Bbt7f
 6hhWpbSuBOnBDqVP8gTOHVxnC95MMmhNd/7FXKiCVdyByh06teLQ4jD3wFgYd09AVwlEWeLrPbW
 6MbsWlxezwyEbEUXafVNGjunH7PXCBuKwEPDiYlbxYcnKK31sbuyVlk4v0DVWEf5wWNzzrkQ9I2
 4ECIkPuQW1mrTG4XCrrUfuxoX76E0avyZDngwAfbpG4UyKUfyD/GWNVyh/dWgXxhAHFiuG2M3J5
 ff6AA/e2pucFlLXfjXP+QoYUksIQJoQQfgOMvEwAGahPFmf+EoW1/Lb/eTARYYP104cS+jdmAD0
 ZC5JJHG9xubrec66wvg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX1W7WDlR6jIUB
 eu51X1nQnZ9tjrfzQvu98mMTq9t+gFuk0jbdLuhweI5tx3M0muA4w8m+goalD1oe/AqoUb5OMkp
 tdGIpRAcqS22L3SWudx5c9u4kdKQd4A=
X-Proofpoint-GUID: cHr4nkIpTTS-n_q8NXCTkQqgFIv9Aqv6
X-Authority-Analysis: v=2.4 cv=EsJHPicA c=1 sm=1 tr=0 ts=6ae8d5f0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=NEAV23lmAAAA:8
 a=VnNF1IyMAAAA:8 a=CNYaEmq5Eh7_Uq32rWQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_05,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020072

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
Ojaswin Mujoo (8):
      ext4: add extra_flags param to ext4_convert_unwritten_extents()
      ext4: fix endio zeroout corruption by tracking unwritten to-be-converted IOs
      ext4: add tracing for i_conv_pending_ios tracking
      ext4: don't zeroout if we have inflight unwritten IOs in non buffered-iomap path
      ext4: don't zeroout if we have inflight direct IOs
      ext4: make sure zero range WRITE_ZEROES uses NO_CONV_ACC flag
      ext4: don't zeroout if we have inflight unwritten IOs in buffered iomap path
      ext4: optimize inflight dio tracking for zeroout

 fs/ext4/ext4.h              |  29 +++++++--
 fs/ext4/extents-test.c      |   2 +
 fs/ext4/extents.c           | 117 ++++++++++++++++++++++++++++-------
 fs/ext4/file.c              |  14 ++++-
 fs/ext4/inode.c             | 146 +++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/page-io.c           |  27 +++++++-
 fs/ext4/super.c             |  12 ++++
 include/trace/events/ext4.h |  25 ++++++++
 8 files changed, 342 insertions(+), 30 deletions(-)
---
base-commit: 8c4f6e3376348fc3162eed86a05b933921c8f9ed
change-id: 20261023-ext4-endio-zero-bug-ec627ae61f39

Best regards,
-- 
Ojaswin Mujoo <ojaswin@linux.ibm.com>

