Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644041;
	b=tspdOuVcCS0ObSCtSItElxi+UpW3rfF42ycLgNLvnBf8X8FbdYFG+BcsT/6Ncr8G0UeQ
	 me0IVp7HTB4Igz3FOT18RAPLj+oC5nHa/+gogCDRdZ8BNExO5ubWahSbXXr+YMDSpFeGq
	 Lkv0jnXrjzT/05D25jfoXauT6n3goZp1RMnBxAwn1MjWjPR07GpkrnFmItHnpGQu99OHi
	 rwFAu0tA9IlwZtHX0kOi3PFIpRIJhWjiRf4l1USvkHkbCKmZNlWIxQSG9ntmkAPuZrEB2
	 l0cRmZasrOLyMgnPKm2AsIjpIrVn8L02Jlu5n0ZNMtlzpxRPTdz2lUk7pd02p4+ca/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644041;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=IGE3ly9MV1Gr1qS4ng0EqqPCWkx+OWvmUL62FmsSUmE=;
	b=wxOKvKJpYN4Cs+Cos2psyBXfUstwiC02yPD2Sgs9KzjUC2d3jnDXvmyw6TITkKpz6rXC
	 HuaijZeOOSd9fsQFwrb15xgA9v9Bqbm0p9dL3KP7lP1caxWlOjGqRhzfRL4KV9+GO6wTM
	 OA5NGHm4M7GX+icX374udaofb/MIVI9fNUmOq52sWAmMvdxLnzTiDTEK8VcoHGb4lL04/
	 WfANc8iBxIrN6g44xOsJRlq1k72ySsn22S4ZfSI5NQOlFLywbIgI9W7EPNkuMTKg+8RUP
	 AO7U4QzeRugi50tnNoNZC93IWRa+eHxEDgeZG8L/HsCxZ7/L8u+Tx8//0ZzIddLcUVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=aby3ICGK;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E84606D801;
	Mon,  2 Nov 2026 18:27:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5E84606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=aby3ICGK
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HibD32394651;
	Mon, 2 Nov 2026 18:27:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IGE3ly
	9MV1Gr1qS4ng0EqqPCWkx+OWvmUL62FmsSUmE=; b=aby3ICGK34kXkuj+U9MdXJ
	7iBzRkqIURaVTjTe3hj12zlM7GEbYY7g+2xkIguAD3O7XZc0oEzXpWG5L2O+7XxL
	UoydECO9aKwDqxUBh8AYgIv7HzqkjOqgLtvvwxQyUtjqSM0qDZ4JSYnszfhBx3tc
	JiXjsdC0Ynex2euGdwqbsdoqZWI3z7ZMru7dXrCNPMPXV7iVA6zsmfaWDtLmG0vx
	GrZHVZvi6B6mVBhalRUcq0clHQWxEbgskXfPLbgfUhgkJPlDOUGdMU87VnjKEdC6
	Tmw8TpvQlBNFIW0EdtLEmJnogBRxPAGquClgZO6MuHMLfhwn/ZU6ZMY+RXNjWDYQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn6rd2689-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HYvDI1340206;
	Mon, 2 Nov 2026 18:27:09 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hnv5gq5q0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A2IR6Uj38928850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Nov 2026 18:27:06 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FBC220040;
	Mon,  2 Nov 2026 18:27:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A80A720043;
	Mon,  2 Nov 2026 18:27:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.25.71])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Nov 2026 18:27:04 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Mon, 02 Nov 2026 23:56:20 +0530
Subject: [PATCH 5/8] ext4: don't zeroout if we have inflight direct IOs
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
Message-Id: <20261102-ext4-endio-zero-bug-v1-5-266d2bb9e6dc@linux.ibm.com>
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
X-Proofpoint-GUID: xqlGs70y2bF__2HNreLugK6OcPzVLjBj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX5wBgdry64Qim
 4tXdlGY1DJA4YXQIFl7KdHKHu8up97CRo56s0D7ZaeUquk0pbb9oud4ImdW/5pBU9SPLOstsG8K
 VoIsRqUP0CqrBY/+wgImOJHvqb7rl9tJKrupQhkeHXIZVhCCeJqsvHpi56IAXSCCVyPVS0Z8kux
 pYiqlX1xgQT4zd0au1kyllt1o8S0c0Wk7x8z4eHJXmJNqAmogRPUbK2TjbJXJ5t5QOJOubecILf
 9dMRZZ5iWF9vSE7YxgEfM3Dkh7hSvaDkgzn6r4berNZuDGirvAIM80PtHmCnzeai73+0V3/AitI
 +hvMxyHhqsiSvzP57BOgKTjGrkMNCZq4nIyzNAp7/ywn40Qn/u1WsRvlUm3PX44RrT1R22nWznH
 344VQH0fnwwBiXFUq5CTeBRBo9odoaY6rS59ziQA6t1AGORnggWJ0C3jiwSld1TBaSb9p1mGGaJ
 lWIaMir1XWcIpvTlX9Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX/U2URcVZfx3U
 9vjNpUt0JmULZJwRwRDxNE95f0wxw3bxWrsptYMnHLyO3vW6/fzPutrKq3LwXcJtMVRFdJX0Uws
 /XHgjax6t+YZxlFaEDm8S2IhqSZD3iE=
X-Authority-Analysis: v=2.4 cv=QK391QLL c=1 sm=1 tr=0 ts=6ae8d5fe cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=PZbrOloShCCzKOjG55sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: zVc1HOEGOnI4TvCuzjoffDZrnAMsiUVi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_05,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020072

When endio conversion of an unwritten extent fails (e.g. ENOSPC while
trying to split the extent), ext4 falls back to zeroing out the unwritten
portions of the extent and marking it as written. This is safe only when no
other in-flight writes have valid data underneath other parts of the same
unwritten extent, otherwise the zeroout would silently corrupt that data.

Commit ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
changed the dio path to submit I/O without pre-splitting extents, deferring
the split to endio. This means multiple concurrent writes can share a
single unwritten extent, and a failed split on one of them could zeroout
data belonging to another.

Buffered IO fixes this by counting such IOs on unwritten extents in
i_conv_pending_ios and decrementing them after conversion. However, due to
the way dio iomap is designed, it is not very straightforward for the FS
layer to increment once per unwritten IO.

Hence, to keep it simple use the existing inode->i_dio_count which is
incremented/decremented once per dio. zeroout code can now use
i_dio_count with i_conv_pending_ios to decide if zeroout is safe to do.

The only thing missing is the mutual exclusion of i_dio_count increment vs
the zeroout decision. To fix that, add ext4_conv_pending_barrier() in
ext4_iomap_begin() which just rotates i_conv_pending_sem before returning
an unwritten mapping for a write. This ensures that either a racing zeroout
has finished before we issue an IO over unwritten extent, or zeroout starts
after our dio is accounted for.

This design is overly cautious in disabling zeroout (eg, we will disable it
for all inflight dio, not just dio over unwritten extents) but it keeps the
code simple.

Fixes: ea96cb5c4ae3 ("ext4: don't split extent before submitting I/O")
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/ext4.h    |  2 ++
 fs/ext4/extents.c |  9 ++++++++-
 fs/ext4/inode.c   | 43 ++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 44cd9f12d350..bf390b3b5606 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4002,6 +4002,8 @@ extern void ext4_conv_pending_sum(struct inode *inode, int n);
 extern int ext4_conv_pending_inc_trylock(struct inode *inode);
 extern void ext4_conv_pending_dec(struct inode *inode);
 extern void ext4_conv_pending_sub(struct inode *inode, int n);
+extern void ext4_conv_pending_barrier(struct inode *inode);
+extern int ext4_conv_pending_barrier_trylock(struct inode *inode);
 extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 						   int num,
 						   struct ext4_ext_path *path);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 96d8ad012b2a..e4e65f3f576d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3333,10 +3333,17 @@ static bool ext4_conv_pending_zeroout_lock(struct inode *inode, int flags)
 	pending = atomic_read(&ei->i_conv_pending_ios);
 
 	WARN_ON_ONCE(pending < 0);
-	if (pending > thresh || pending < 0) {
+	if (pending < 0) {
 		up_write(&ei->i_conv_pending_sem);
 		return false;
 	}
+
+	pending += atomic_read(&inode->i_dio_count);
+	if (pending > thresh) {
+		up_write(&ei->i_conv_pending_sem);
+		return false;
+	}
+
 	return true;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8b5cb37cdd6d..9d7d4da0071f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -692,9 +692,9 @@ static void _ext4_conv_pending_mod(struct inode *inode, int n)
  * they might have data underneath which is pending endio conversion. Zeroing
  * out such an extent can cause silent corruption.
  *
- * To fix this we track the IOs which are about to undergo conversion in
- * ei->i_conv_pending_ios. The zeroout code then uses this counter to
- * determine if it's safe to zeroout.
+ * To fix this we track the no. of buffered IOs which are about to undergo
+ * conversion in ei->i_conv_pending_ios. The zeroout code then uses this counter
+ * to determine if it's safe to zeroout.
  *
  * Design Notes:
  *
@@ -715,6 +715,9 @@ static void _ext4_conv_pending_mod(struct inode *inode, int n)
  * don't see any heavy lock contention. Atomic counters help parallel
  * modifications to be serialized.
  *
+ * Note that dio does not use i_conv_pending_ios; instead we use i_dio_count to
+ * disable zeroout if there are any other inflight dios.
+ *
  * ** Tolerance for false positives **
  *
  * We trade false positives for simplicity of implementation because having a
@@ -756,6 +759,30 @@ int ext4_conv_pending_inc_trylock(struct inode *inode)
 	return 0;
 }
 
+/*
+ * Rotate i_conv_pending_sem. This guarantees mutual exclusion against a
+ * concurrent endio zeroout, which holds i_conv_pending_sem exclusive. This
+ * barrier ensures either the zeroout has completed before we return, or it will
+ * start after we have accounted for the io and will see it while zeroing out.
+ * This can be used for paths that might not be changing ei->i_conv_pending_ios
+ */
+void ext4_conv_pending_barrier(struct inode *inode)
+{
+	down_read(&EXT4_I(inode)->i_conv_pending_sem);
+	up_read(&EXT4_I(inode)->i_conv_pending_sem);
+}
+
+/*
+ * Same as ext4_conv_pending_barrier() but doesn't sleep on i_conv_pending_sem.
+ */
+int ext4_conv_pending_barrier_trylock(struct inode *inode)
+{
+	if (!down_read_trylock(&EXT4_I(inode)->i_conv_pending_sem))
+		return -EAGAIN;
+	up_read(&EXT4_I(inode)->i_conv_pending_sem);
+	return 0;
+}
+
 void ext4_conv_pending_dec(struct inode *inode)
 {
 	_ext4_conv_pending_mod(inode, -1);
@@ -4073,6 +4100,16 @@ int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 out:
+	if ((flags & IOMAP_WRITE) && (map.m_flags & EXT4_MAP_UNWRITTEN)) {
+		if (flags & IOMAP_NOWAIT) {
+			ret = ext4_conv_pending_barrier_trylock(inode);
+			if (ret)
+				return ret;
+		} else {
+			ext4_conv_pending_barrier(inode);
+		}
+	}
+
 	/*
 	 * Sometimes I/O to an encrypted file has to be broken up to guarantee
 	 * DUN contiguity.  Handle this by limiting the length of the mapping

-- 
2.55.0

