Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAD13CC7EB
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2026 06:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787119793; cv=none; b=uVoMAXlks45hVt/sRcspzpSfqfyKrXtZOkjvZl6Vvp3xHACACgCRwmCOOHufW1RJZjRIoVR9OZ22xVH52itA4Xm9kt9Z9qVPsGpX4pFR+WuCBU/AeICKjwydhz6h0zzEl7Hw8drdzlb5Ibc/CB5bpTuL6ZE9Lq+yhz3YA9wiZOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787119793; c=relaxed/simple;
	bh=MtdW5OSvBIj39lpuInK2A0ybIroMuxLCR+VpOBgqU7s=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=PL6Syf2prtOj2S5ZNq2xS58KVxv9ksOgUkwdAmCMIOOx4SRYcVYiy9LI0Ys877IMVDwHd5nX0O3zEvEfvHFhlWfXqOYUpNzJJXDzUl/FvQxAZSCVApL39DhoHfQQG9tdeIy8xhqcjqewB+aPI4kulo7pjdD4rKt8xZIgtlOux58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=R9mZFcIL; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="R9mZFcIL"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260819060940epoutp0474a594bc9dfc7672d080b18eb347b9f5~NH-jiGESc1400714007epoutp04R
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2026 06:09:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260819060940epoutp0474a594bc9dfc7672d080b18eb347b9f5~NH-jiGESc1400714007epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787119780;
	bh=cy+gxLzvqhQc6Uel3Lj4nja/UwgS310Mo85HoQFCz7E=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=R9mZFcILkksf8db2gB59KPudRxcxjXSrMvlGk+6KL6HoeUNmeF7JAHPT4sdw0o8+Q
	 a3WpchovAI8gObaRQ1jhUedNDmMG+lZszq4y507vyjEkqcU86r+mWg8SbwhCkpszNh
	 iaGzEKpJXa1tLjlsXTDnRUUcQuTDWU5VvNrv+td8=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20260819060940epcas2p1589afeccda042d75d2e898a9bffac25c~NH-jP1Tfq3069830698epcas2p1U;
	Wed, 19 Aug 2026 06:09:40 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.207]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hPx441nD9z2SSKg; Wed, 19 Aug
	2026 06:09:40 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] jbd2: don't advance j_fc_off before the buffer is recorded
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>,
	"jack@suse.com" <jack@suse.com>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"junzheyu1@gmail.com" <junzheyu1@gmail.com>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3>
Date: Wed, 19 Aug 2026 15:09:39 +0900
X-CMS-MailID: 20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d
References: <CGME20260819060939epcms2p37bb8589b2f8a52a2b14bef38fadcf69d@epcms2p3>

jbd2_fc_get_buf() increments journal->j_fc_off before jbd2_journal_bmap()
and __getblk() have had a chance to fail.  When either does, the slot
j_fc_wbuf[fc_off] is never assigned, but j_fc_off already counts it.

ext4 then fails the fast commit and falls back, and the fallback path
reaches jbd2_fc_release_bufs() via ext4_fc_commit ->
jbd2_fc_end_commit_fallback -> __jbd2_fc_end_commit -> ext4_fc_cleanup.
That walks down from j_fc_off - 1 and put_bh()es every slot until it
sees NULL, so it also touches the slot that was never written.
j_fc_wbuf comes from a plain kmalloc() and is never zeroed, so a slot
used for the first time holds uninitialised heap data.

Advance j_fc_off only after the buffer head has been stored.  That
restores the invariant that j_fc_off covers exactly the filled slots,
which is what jbd2_fc_release_bufs() relies on: the live buffers of the
current fast commit sit above the NULLs the previous one released, so
stopping at the first NULL is correct.

Reproduced on a KASAN kernel with an ext4 fast_commit filesystem on a
loop device, truncating the backing file under the live mount so that
only the journal's fast-commit region falls past the end of the device.
__getblk() then fails for the first fast-commit block while the rest of
the journal is still addressable, so the journal is not aborted and the
fast commit reaches the fallback path.  j_fc_wbuf was poisoned to make
the read of the never-written slot visible:

  BUG: KASAN: wild-memory-access in jbd2_fc_release_bufs+0x6b/0xd0
  Write of size 4 at addr 5a5a5a5a5a5a5ab2 by task sync/961
   jbd2_fc_release_bufs+0x6b/0xd0
   ext4_fc_cleanup+0x97/0x830
   __jbd2_fc_end_commit+0x37/0xc0
   ext4_fc_commit+0x524/0x560
   ext4_sync_file+0x3c4/0x4b0
   __x64_sys_fsync+0x20/0x30

With this patch the same run leaves j_fc_off at 0 across repeated
__getblk() failures and completes cleanly.

Fixes: ff780b91efe9 ("jbd2: add fast commit machinery")
Reported-by: Yu Junzhe <junzheyu1@gmail.com>
Closes: https://lore.kernel.org/linux-ext4/7e4b109d-64c3-444f-a5dc-93c2ca4576cc@gmail.com/
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/jbd2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 00f5a98f3d4f..55b4ce010228 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -843,7 +843,6 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
 
 	fc_off = journal->j_fc_off;
 	blocknr = journal->j_fc_first + fc_off;
-	journal->j_fc_off++;
 	ret = jbd2_journal_bmap(journal, blocknr, &pblock);
 	if (ret)
 		return ret;
@@ -853,6 +852,7 @@ int jbd2_fc_get_buf(journal_t *journal, struct buffer_head **bh_out)
 		return -ENOMEM;
 
 	journal->j_fc_wbuf[fc_off] = bh;
+	journal->j_fc_off++;
 
 	*bh_out = bh;
 

base-commit: 9091c97be34083587a75db174aab51551d8e8543
-- 
2.43.0
