Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644048;
	b=v1H4dgAAR32xCEYyyu+kUZ6izr3M5bvDpqv0k8mZBG3fAMXttzrW43OUulZ8nYbEk8y0
	 ffQOR+T690aa6mHqXJrvyb/KPrpfvNV9iSZUEtCvGhVpGdD9z7PlF2y96UtB7ucdX8QNz
	 0QwIVHxdEBC+ylChi1FqlYS7SAcuB6yuFBp0glngbRiJ0mWv9a2VJg8VAJgj9a4kDKsFx
	 hYS1Pjp7uOLfcHk8fsf3ClW1q+0L3+Ud05G8NfcQw/gSr1IzhZnHtC8VKqUIRroaRDCgA
	 5ld+rvSKhmzKPrXC6W2E89A+3fSbkoAuaXup/Jw/1aOCFvFSP9ER+WDsm2YmziytyqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644048;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=+623cCAEu9LmKYW6GsS5k5IFrbteS08/Ze0P6Rmqjas=;
	b=KUphOgW22jYkLKwIZwrMizcfeE/X25gpcicMCS0BvlK1RkobFC4AecPKOLn1Io2tvw3V
	 dGIiCts+BFyjQLKzL/qao/8IxEkui0dF2tJTf3EIniKgRxYUtHVfu7F9nrQzfzL4I4OpR
	 yH3v2U6UOi+JW/Ej9s39kZk/Nw2y4wzzXzj8QFdH2Vfl5QkGthw1L3T1kXe5joYPBTc4r
	 0wIJAtCDrcr8jPTyCtsSjy7HpHzlnl0cP6BhiY6CFC9AffgHMFbRVEt+/rP3SZYSLR7sf
	 TlsuaLW3pG7qmBjIL9FNbUFFKbFrvlFloUK6/oiIpkj7PDw/xURKNKCx+lYJ5rxe0sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="JD/A9Znc";
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892AF606EE97;
	Mon,  2 Nov 2026 18:27:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 892AF606EE97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=JD/A9Znc
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HiPaH2394291;
	Mon, 2 Nov 2026 18:27:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+623cC
	AEu9LmKYW6GsS5k5IFrbteS08/Ze0P6Rmqjas=; b=JD/A9ZnchBwkd3OPLhTipm
	fRWc45G8tqzNtiipKbUSNAKHNlrmtWXx3X8YEbOfXGBhj2VD74t2lHOX9iZrnIor
	nAg9sTGC3tOHngcH4ETBVvqeA8Xs7wedobfYwDEwVOgfLl+d0MMqauibREGAGAx8
	m3KAkFATVbfOK7IGBhTAA0cEN3XhCa1L5+0TVpFTbpNO5Nv45kvC2GJECkUOi/Bd
	KiTMvXwfAl+q8/pzZAXje2Ft/+ICUOaBkTKXarCl0UjYQQgk2shEXbthzBZGqMwo
	5WOYHNVtE5RL5ymNo4Fo8/KKId1nXoYjHcxSvyyo+qK8bsQtk8Nw928mJetuk1FQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn6rd268m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HZ1p01313084;
	Mon, 2 Nov 2026 18:27:16 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hnwbxy0hr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A2IRE0X45023648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Nov 2026 18:27:14 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B08320043;
	Mon,  2 Nov 2026 18:27:14 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA80A20040;
	Mon,  2 Nov 2026 18:27:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.25.71])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Nov 2026 18:27:11 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Mon, 02 Nov 2026 23:56:23 +0530
Subject: [PATCH 8/8] ext4: optimize inflight dio tracking for zeroout
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
Message-Id: <20261102-ext4-endio-zero-bug-v1-8-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: FHx4B7K5hd8iOMz6ahJqJSCx8uMDodg6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX3QVIm4CHQ60o
 nFkMoMDAs8xmXrRyXKgS6bE91pMH/tLdcuSb8iN+rnYWA1iwwQEU2gAkJxrtttLRJNm+EpDFGZ+
 h1jRGK8olxkE6RYG470MxRnmSQ7bxmn51H3g/5YXAh5RWYSdiLSQJ/wt9wlFyzar5ltkG26drpB
 prNeajjxNnpRzEvsfDea/HhJJ4GeNWN+wy1ztmqFMrnGxn7CtT6xyIcHza5J0YtyQvP7NMxvaZB
 zM8HEKJ19Y2wJzVaIksq7+y/Z6G19CH0xGjvVn7AvLORBTVUysR2wiKhldsJL76HPdHkWYPpLs2
 5b8+EiVM0ZDT54wGo8xa7bH5gWLKPn3yCL25as8r10y4WizuW49SfKPRM6KOTChs+BmJ7BaBSbJ
 5HrwKiHFCPoUWxpKs8p2J0IqcYMeYFjKJ6VvSYIpyapDc1egyF0IrbcozMZBlTGWrEtHepi6uc6
 uY764bCoSsZ4y5hxjQw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfXwOHEViDOiSf9
 ez6SwatbiDQ84ZCj6VwubzZNDwRLPXPf6bSXp8t7aseIjgB6lPh54XVOmgSsh5y+7Sg22a3oNdr
 CaD6fL3RL/DARaXDBZFq3z0/fz9qF5g=
X-Authority-Analysis: v=2.4 cv=QK391QLL c=1 sm=1 tr=0 ts=6ae8d605 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=752qX7MUr42qtAX2WOgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: hs3ulAhxgTx4Go2qf4NVXwzMqgo7xcYZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_05,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020072

Earlier zeroout used inode->i_dio_count to detect in-flight DIOs
that might have valid data underneath an unwritten extent. However,
i_dio_count accounts for every DIO on the inode, including reads and writes
that never touch an unwritten extent, which makes it prone to false
positives and needlessly suppresses the zeroout fallback.

Optimize this by moving DIO accounting to i_conv_pending_ios, which is only
incremented for DIOs that actually encounter an unwritten extent, and
decremented once at endio after the conversion is done.

The main issue is that ext4_iomap_begin() doesn't have any way to track
something only once per dio, hence, we use a custom ext4_iomap_next() that
utilizes iter->private to ensure we increment the i_conv_pending_ios only
once per a dio that encounters unwritten extents.

Now that dio has moved to i_conv_pending_ios, we need to pass NO_CONV_ACC
get blocks flag to ext4_ext_convert_to_initialized(). This path is
reachable from dio but doesn't need to account in i_conv_pending_ios
because we don't issue any IO before conversion, hence the flag helps
zeroout to make the right call.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/ext4.h    |  2 --
 fs/ext4/extents.c | 11 ++-----
 fs/ext4/file.c    | 12 +++++++-
 fs/ext4/inode.c   | 85 ++++++++++++++++++++++++++++---------------------------
 4 files changed, 58 insertions(+), 52 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf390b3b5606..44cd9f12d350 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4002,8 +4002,6 @@ extern void ext4_conv_pending_sum(struct inode *inode, int n);
 extern int ext4_conv_pending_inc_trylock(struct inode *inode);
 extern void ext4_conv_pending_dec(struct inode *inode);
 extern void ext4_conv_pending_sub(struct inode *inode, int n);
-extern void ext4_conv_pending_barrier(struct inode *inode);
-extern int ext4_conv_pending_barrier_trylock(struct inode *inode);
 extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 						   int num,
 						   struct ext4_ext_path *path);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d546001fedc6..3150754b9766 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3333,13 +3333,7 @@ static bool ext4_conv_pending_zeroout_lock(struct inode *inode, int flags)
 	pending = atomic_read(&ei->i_conv_pending_ios);
 
 	WARN_ON_ONCE(pending < 0);
-	if (pending < 0) {
-		up_write(&ei->i_conv_pending_sem);
-		return false;
-	}
-
-	pending += atomic_read(&inode->i_dio_count);
-	if (pending > thresh) {
+	if (pending > thresh || pending < 0) {
 		up_write(&ei->i_conv_pending_sem);
 		return false;
 	}
@@ -4117,7 +4111,8 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	 * discovered unwritten extent to written.
 	 */
 	path = ext4_ext_convert_to_initialized(handle, inode, map, path,
-					       flags, allocated);
+					       flags | EXT4_GET_BLOCKS_NO_CONV_ACC,
+					       allocated);
 	if (IS_ERR(path))
 		return path;
 	ext4_update_inode_fsync_trans(handle, inode, 1);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 06ef7a9b9f83..52b1fb99484d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -458,6 +458,15 @@ static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
 	else if (!error && size && flags & IOMAP_DIO_UNWRITTEN)
 		error = ext4_convert_unwritten_extents(NULL, inode, pos, size,
 						       NULL, 0);
+
+	/*
+	 * If this dio covered an unwritten extent, we would have incremented
+	 * i_conv_pending_ios in ext4_iomap_next(). Decrement it now that
+	 * the conversion has completed (or failed).
+	 */
+	if (flags & IOMAP_DIO_UNWRITTEN)
+		ext4_conv_pending_dec(inode);
+
 	if (error)
 		return error;
 	/*
@@ -599,6 +608,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	size_t count = iov_iter_count(from);
 	bool extend = false;
 	bool ilock_shared = true;
+	bool conv_pending_inc = false;
 	int dio_flags = 0;
 
 	/*
@@ -664,7 +674,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	ret = iomap_dio_rw(iocb, from, &ext4_iomap_ops, &ext4_dio_write_ops,
-			   dio_flags, NULL, 0);
+			   dio_flags, &conv_pending_inc, 0);
 	if (ret == -ENOTBLK)
 		ret = 0;
 	if (extend) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0c924ad8210b..46f91d6d8ed5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -692,9 +692,9 @@ static void _ext4_conv_pending_mod(struct inode *inode, int n)
  * they might have data underneath which is pending endio conversion. Zeroing
  * out such an extent can cause silent corruption.
  *
- * To fix this we track the no. of buffered IOs which are about to undergo
- * conversion in ei->i_conv_pending_ios. The zeroout code then uses this counter
- * to determine if it's safe to zeroout.
+ * To fix this we track the IOs which are about to undergo conversion in
+ * ei->i_conv_pending_ios. The zeroout code then uses this counter to
+ * determine if it's safe to zeroout.
  *
  * Design Notes:
  *
@@ -715,9 +715,6 @@ static void _ext4_conv_pending_mod(struct inode *inode, int n)
  * don't see any heavy lock contention. Atomic counters help parallel
  * modifications to be serialized.
  *
- * Note that dio does not use i_conv_pending_ios; instead we use i_dio_count to
- * disable zeroout if there are any other inflight dios.
- *
  * ** Tolerance for false positives **
  *
  * We trade false positives for simplicity of implementation because having a
@@ -759,30 +756,6 @@ int ext4_conv_pending_inc_trylock(struct inode *inode)
 	return 0;
 }
 
-/*
- * Rotate i_conv_pending_sem. This guarantees mutual exclusion against a
- * concurrent endio zeroout, which holds i_conv_pending_sem exclusive. This
- * barrier ensures either the zeroout has completed before we return, or it will
- * start after we have accounted for the io and will see it while zeroing out.
- * This can be used for paths that might not be changing ei->i_conv_pending_ios
- */
-void ext4_conv_pending_barrier(struct inode *inode)
-{
-	down_read(&EXT4_I(inode)->i_conv_pending_sem);
-	up_read(&EXT4_I(inode)->i_conv_pending_sem);
-}
-
-/*
- * Same as ext4_conv_pending_barrier() but doesn't sleep on i_conv_pending_sem.
- */
-int ext4_conv_pending_barrier_trylock(struct inode *inode)
-{
-	if (!down_read_trylock(&EXT4_I(inode)->i_conv_pending_sem))
-		return -EAGAIN;
-	up_read(&EXT4_I(inode)->i_conv_pending_sem);
-	return 0;
-}
-
 void ext4_conv_pending_dec(struct inode *inode)
 {
 	_ext4_conv_pending_mod(inode, -1);
@@ -4100,16 +4073,6 @@ int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 out:
-	if ((flags & IOMAP_WRITE) && (map.m_flags & EXT4_MAP_UNWRITTEN)) {
-		if (flags & IOMAP_NOWAIT) {
-			ret = ext4_conv_pending_barrier_trylock(inode);
-			if (ret)
-				return ret;
-		} else {
-			ext4_conv_pending_barrier(inode);
-		}
-	}
-
 	/*
 	 * Sometimes I/O to an encrypted file has to be broken up to guarantee
 	 * DUN contiguity.  Handle this by limiting the length of the mapping
@@ -4132,7 +4095,47 @@ int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_next, ext4_iomap_begin);
+static int ext4_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			   struct iomap *srcmap)
+{
+	int ret = iomap_iter_next(iter, iomap, srcmap, ext4_iomap_begin, NULL);
+
+	/*
+	 * For dio, increment i_conv_pending_ios the first time we see an
+	 * unwritten mapping for this IO, so that it cleanly balances with the
+	 * single endio call. We use iter->private to track state to ensure we
+	 * only increment once per dio regardless of how many extents it spans.
+	 * The decrement happens in ext4_dio_write_end_io() if
+	 * IOMAP_DIO_UNWRITTEN is set.
+	 *
+	 * Hack alert: iomap_dio_bio_iter() fails a misaligned mapping with
+	 * -EINVAL before it sets IOMAP_DIO_UNWRITTEN, so endio would skip the
+	 * decrement. Don't increment for such a mapping. The alignment check
+	 * mirrors the one in iomap_dio_bio_iter()
+	 */
+	if (ret > 0 && iter->private &&
+	    (iter->flags & IOMAP_WRITE) && (iomap->type == IOMAP_UNWRITTEN) &&
+	    IS_ALIGNED(iter->pos | iomap_length(iter),
+		       bdev_logical_block_size(iomap->bdev))) {
+		bool *inc_done = (bool *)iter->private;
+
+		if (!*inc_done) {
+			/* NOWAIT dio must not sleep on i_conv_pending_sem */
+			if (iter->flags & IOMAP_NOWAIT) {
+				int err;
+
+				err = ext4_conv_pending_inc_trylock(iter->inode);
+				if (err)
+					return err;
+			} else {
+				ext4_conv_pending_inc(iter->inode);
+			}
+			*inc_done = true;
+		}
+	}
+
+	return ret;
+}
 
 const struct iomap_ops ext4_iomap_ops = {
 	.iomap_next		= ext4_iomap_next,

-- 
2.55.0

