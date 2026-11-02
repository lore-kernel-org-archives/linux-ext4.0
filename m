Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793644038;
	b=a7cfUmzppeZdXbQqo8ZUmmvgwTFRkzMdRQdbQbLdHUVgzrofDYGM7wSPekVkyLpttQnS
	 3oBSy/Wxo0HmZfkxJ0o9kImx5FAs5ioVR1Ey8JRbUjvWLluLKflQhJxV35NaNem81hpYz
	 S8bA0Ltgs7UlVnp4T8HTsAPRCrxmiAEO2k6IxqAdI+7kI6oRKKw9AvQMx6w5/BD3CgccO
	 v8wEKkbRPTm6wc5trDwD5CCKnKDwS/N0CDnyJIDXmzlgNj8uuv+RG8tsS151OR18CITtj
	 0ZBQTu6XFwZuAMVbUFYLLQfWm33TwvXKCOX4IxoPoPEbeL3xZH6Z0rQ5HSDZeoprqsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793644038;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-TM-AS-GCONF:X-Proofpoint-Reinject:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=hNxz90Ffp8EQvDdpfRrjvRNqKKWwnRzrsfTMSXkRyRQ=;
	b=dZcFjgCGYvwpxfxRyaDV4OrErDkDO5QodErfTfZ+XA5EtZ4+Ot7nbWQwqIk/nozOTJpY
	 S6C26WPpQq9iZEjcaz6oysnfpKrM2U9K0o3m4SUV3b1VvZFC1blhExsXgoxAZNF5igGWo
	 PG8MPNbFCAd1FmN3JuZGSPqbylSQ3sdfgB6bqelUzy4BZKliuZYy5EoiwZ4uur/yz4UUc
	 39j3vdq8G6KniOlHtLyJYUMs3sQYXbxUT9eWFWcVZWiBfLhBwwpruf+BqNF7UDag9llhj
	 MhQa4IoVfbNaBF2rGoaydkxr0ncq4KwAlXbS01cEQX0yCDxkmWuZowcaSefrzuwQYjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=pUlLqOzh;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24BE606A32F;
	Mon,  2 Nov 2026 18:27:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C24BE606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=pUlLqOzh
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HiHmM3489271;
	Mon, 2 Nov 2026 18:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hNxz90
	Ffp8EQvDdpfRrjvRNqKKWwnRzrsfTMSXkRyRQ=; b=pUlLqOzhso3freUzkQ3hrm
	bxOkJSD4gFk60AE4ASJLtKcD6Vuw2uHA2fbjIUZXBC61tQFnRPu8KHxikPX1xRZC
	f8Gfky8etzZoQXZMo+gCFNYNU3UTqCPLqaT2Ml6hPryaZzuDS7JwEaA45iE6lVs2
	kKur87NPt6FHfgi9cxwqzXiQ+Uhl87GV7SYnh9fA0WUqIXeVPjq320dTQPCgwSJV
	OZG0D4z2VY4CnsjQsK5CP81Yzx8/xOPrXs3DWS0JrLQku7SAY+16EICuwCZplegk
	cBoNymdQeRlmWynHa14VL0w2F9jC9qw9UCProJV7O/Uq3XWLw2Z2L2HhSSn3iaCA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hn5rhjb7g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:01 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2HZ3tn1272225;
	Mon, 2 Nov 2026 18:27:00 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hntnpyddm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Nov 2026 18:27:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6A2IQwQV13697334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Nov 2026 18:26:59 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DCAC120043;
	Mon,  2 Nov 2026 18:26:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC6C420040;
	Mon,  2 Nov 2026 18:26:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.25.71])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Nov 2026 18:26:56 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Mon, 02 Nov 2026 23:56:17 +0530
Subject: [PATCH 2/8] ext4: fix endio zeroout corruption by tracking
 unwritten to-be-converted IOs
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
Message-Id: <20261102-ext4-endio-zero-bug-v1-2-266d2bb9e6dc@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: vnpbSvxbWVZnKvTyTgNQgBuUyC_Xh01F
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX5zJ+EoISvHoZ
 WGqLnWGdEN/l1qETYwqJuCV+TH5MEZnbpptRXN+2ov19Y6zIr2HtYqiJgHtiLshGOObh+ev+p5x
 4WGtrjzLSDkzpWqs2jyfJszeee5UZvU=
X-Authority-Analysis: v=2.4 cv=LokHWXdc c=1 sm=1 tr=0 ts=6ae8d5f5 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=KK7gg9ZJj2oIaeODp_sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA3MiBTYWx0ZWRfX4113FXQvMpjd
 41i9ABTdDw4vhBJAyDGnxXg6ogelMct3MireaHzc+10/rioAiG4Qp4B49LAGB4gngFy3erUv8HM
 DLC3XWFcymL7+ssP449Y7R2szZ4lDCYZd9u1UlHjEhGRSB1wQUTHKnhpt/iXl+mPjKJ34ah/KMF
 x2KKd5ebXUzpxgo2mh8IPZ1w5pJ0U0BBmKzqDtelOZK48yYjUQ3aSICdC8ksWZM8a+/ql8semXq
 lWldzAD4GeYyDmfEg5MrTESqrf8KS/zyb5aQvw6/Z2EOWyuAdwY/dbRwg5HdR4hgiBsu7prpayh
 Km+Lf8+DzP+w054TjRbnGow9loSfNvzG1vEpzAE2KsZL+kTxKcF6Oq6NpEb1vqMrJ/pK0QYsHi1
 xxVz0BIBmvCiXnd01TovwqWLW7Z8xI7gjQonOcW3TPz3HPDXNa5w2kHDiN2SeWSN+SAc/ukGcyn
 siw74n/KHJyG5r1w80w==
X-Proofpoint-GUID: g82ksEokMsCBQCEQDErQR0PM0jbEAs98
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_05,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020072

In case endio conversion fails due to factors like ENOSPC or ENOMEM, ext4
uses a fallback where we zeroout the unwritten extents instead of
splitting. However, not all unwritten extents can be zeroed out
unconditionally as they might have data underneath which is pending endio
conversion. Zeroing out such an extent can cause silent corruption.

To fix this we track the IOs which are about to undergo conversion in
ei->i_conv_pending_ios. The zeroout code then uses this counter to
determine if it's safe to zeroout.

Design Notes:

**Locking**

The only mutual exclusion we need is between an IO that is about to be
submitted over an unwritten extent and zeroout. This is done using a
dedicated rwsem, ei->i_conv_pending_sem with the following rules:

1. Incrementing the counter must down_read(i_conv_pending_sem).
2. A zeroout must check the counter and zero data under
   down_write(i_conv_pending_sem)
3. Decrementing the counter needs no lock. At worst, this makes zeroout
   bail out due to a stale, elevated counter value, which is acceptable
4. Changes to i_conv_pending_ios should use atomic helpers.

This design provides us the required exclusion while ensuring that fast
paths don't see any heavy lock contention. Atomic counters help parallel
modifications to be serialized.

** Tolerance for false positives **

We trade false positives for simplicity of implementation because having a
false positive here will just error the endio which is still better than
silently corrupting the data. We can always optimize our tracking to make
it more accurate in the future.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/ext4/ext4.h              | 19 ++++++++++
 fs/ext4/extents-test.c      |  2 +
 fs/ext4/extents.c           | 78 ++++++++++++++++++++++++++++++++------
 fs/ext4/inode.c             | 92 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c             | 12 ++++++
 include/trace/events/ext4.h |  1 +
 6 files changed, 192 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b72f90b6375b..1a01b1f809f7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -736,6 +736,11 @@ enum {
  * Look EXT4_MAP_QUERY_LAST_IN_LEAF.
  */
 #define EXT4_GET_BLOCKS_QUERY_LAST_IN_LEAF	0x1000
+/*
+ * Caller may convert an unwritten extent (possibly zeroing parts of it)
+ * without elevating the i_conv_pending_ios count to account for itself.
+ */
+#define EXT4_GET_BLOCKS_NO_CONV_ACC		0x2000
 
 /*
  * The bit position of these flags must not overlap with any of the
@@ -1235,6 +1240,15 @@ struct ext4_inode_info {
 #ifdef CONFIG_FS_ENCRYPTION
 	struct fscrypt_inode_info *i_crypt_info;
 #endif
+	/*
+	 * Number of in-flight IOs pending unwritten->written conversion. Used
+	 * by the zeroout fallback to avoid zeroing out data of such IOs.
+	 * Incrementing needs down_read(i_conv_pending_sem), zeroout needs
+	 * down_write(i_conv_pending_sem), decrementing needs no lock. See
+	 * comment above ext4_conv_pending_inc().
+	 */
+	atomic_t i_conv_pending_ios;
+	struct rw_semaphore i_conv_pending_sem;
 };
 
 /*
@@ -3983,6 +3997,11 @@ extern int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
 				  struct ext4_map_blocks *map, int flags);
 extern int ext4_map_create_blocks(handle_t *handle, struct inode *inode,
 				  struct ext4_map_blocks *map, int flags);
+extern void ext4_conv_pending_inc(struct inode *inode);
+extern void ext4_conv_pending_sum(struct inode *inode, int n);
+extern int ext4_conv_pending_inc_trylock(struct inode *inode);
+extern void ext4_conv_pending_dec(struct inode *inode);
+extern void ext4_conv_pending_sub(struct inode *inode, int n);
 extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 						   int num,
 						   struct ext4_ext_path *path);
diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index c3836ecb89f9..4d63c2050135 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -271,6 +271,8 @@ static int extents_kunit_init(struct kunit *test)
 
 	ext4_es_init_tree(&ei->i_es_tree);
 	rwlock_init(&ei->i_es_lock);
+	atomic_set(&ei->i_conv_pending_ios, 0);
+	init_rwsem(&ei->i_conv_pending_sem);
 	INIT_LIST_HEAD(&ei->i_es_list);
 	ei->i_es_all_nr = 0;
 	ei->i_es_shk_nr = 0;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a229983f91dd..d255884cf075 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3311,6 +3311,40 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 	return path;
 }
 
+/*
+ * Returns true with i_conv_pending_sem held for write if it's safe to zeroout,
+ * else drops the lock and returns false. The caller must call
+ * ext4_conv_pending_zeroout_unlock() once the zeroout IO is complete.
+ *
+ * Callers are expected to have elevated i_conv_pending_ios to account for
+ * themselves, so a count of 1 is their own. Callers that haven't must pass
+ * EXT4_GET_BLOCKS_NO_CONV_ACC in flags, in which case any count is another IO.
+ *
+ * Refer to comment above ext4_conv_pending_inc() for details.
+ */
+static bool ext4_conv_pending_zeroout_lock(struct inode *inode, int flags)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int pending, thresh;
+
+	thresh = (flags & EXT4_GET_BLOCKS_NO_CONV_ACC) ? 0 : 1;
+
+	down_write(&ei->i_conv_pending_sem);
+	pending = atomic_read(&ei->i_conv_pending_ios);
+
+	WARN_ON_ONCE(pending < 0);
+	if (pending > thresh || pending < 0) {
+		up_write(&ei->i_conv_pending_sem);
+		return false;
+	}
+	return true;
+}
+
+static void ext4_conv_pending_zeroout_unlock(struct inode *inode)
+{
+	up_write(&EXT4_I(inode)->i_conv_pending_sem);
+}
+
 static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 				     struct ext4_ext_path *path,
 				     struct ext4_map_blocks *map, int flags)
@@ -3328,6 +3362,9 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 	ee_len = ext4_ext_get_actual_len(ex);
 	is_unwrit = ext4_ext_is_unwritten(ex);
 
+	if (!ext4_conv_pending_zeroout_lock(inode, flags))
+		return -EINVAL;
+
 	if (flags & EXT4_GET_BLOCKS_CONVERT) {
 		/*
 		 * EXT4_GET_BLOCKS_CONVERT: Caller wants the range specified by
@@ -3338,9 +3375,11 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 		loff_t map_end = (loff_t) map->m_lblk + map->m_len;
 		loff_t ex_end = (loff_t) ee_block + ee_len;
 
-		if (!is_unwrit)
+		if (!is_unwrit) {
 			/* Shouldn't happen. Just exit */
-			return -EINVAL;
+			err = -EINVAL;
+			goto out_unlock;
+		}
 
 		/* zeroout left */
 		if (map->m_lblk > ee_block) {
@@ -3350,7 +3389,7 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 			err = ext4_issue_zeroout(inode, lblk, pblk, len);
 			if (err)
 				/* ZEROOUT failed, just return original error */
-				return err;
+				goto out_unlock;
 		}
 
 		/* zeroout right */
@@ -3361,7 +3400,7 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 			err = ext4_issue_zeroout(inode, lblk, pblk, len);
 			if (err)
 				/* ZEROOUT failed, just return original error */
-				return err;
+				goto out_unlock;
 		}
 	} else if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
 		/*
@@ -3370,9 +3409,11 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 		 * Zeroout the map range leaving rest as it is.
 		 */
 
-		if (is_unwrit)
+		if (is_unwrit) {
 			/* Shouldn't happen. Just exit */
-			return -EINVAL;
+			err = -EINVAL;
+			goto out_unlock;
+		}
 
 		lblk = map->m_lblk;
 		len = map->m_len;
@@ -3380,16 +3421,23 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 		err = ext4_issue_zeroout(inode, lblk, pblk, len);
 		if (err)
 			/* ZEROOUT failed, just return original error */
-			return err;
+			goto out_unlock;
 	} else {
 		/*
 		 * We no longer perform unwritten to unwritten splits in IO paths.
 		 * Hence this should not happen.
 		 */
 		WARN_ON_ONCE(true);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out_unlock;
 	}
 
+	/*
+	 * The zeroout IO is done, no need to hold off new unwritten IOs while we
+	 * update the extent tree.
+	 */
+	ext4_conv_pending_zeroout_unlock(inode);
+
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
 		return err;
@@ -3401,6 +3449,10 @@ static int ext4_split_extent_zeroout(handle_t *handle, struct inode *inode,
 		return err;
 
 	return 0;
+
+out_unlock:
+	ext4_conv_pending_zeroout_unlock(inode);
+	return err;
 }
 
 /*
@@ -3743,7 +3795,8 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 	split_map.m_lblk = map->m_lblk;
 	split_map.m_len = map->m_len;
 
-	if (max_zeroout && (*allocated > split_map.m_len)) {
+	if (max_zeroout && (*allocated > split_map.m_len) &&
+	    ext4_conv_pending_zeroout_lock(inode, flags)) {
 		if (*allocated <= max_zeroout) {
 			/* case 3 or 5 */
 			zero_ex1.ee_block =
@@ -3756,7 +3809,7 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 				split_map.m_len - ee_block);
 			err = ext4_ext_zeroout(inode, &zero_ex1);
 			if (err)
-				goto fallback;
+				goto zeroout_unlock;
 			split_map.m_len = *allocated;
 		}
 		if (split_map.m_lblk - ee_block + split_map.m_len <
@@ -3770,16 +3823,17 @@ ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 						      ext4_ext_pblock(ex));
 				err = ext4_ext_zeroout(inode, &zero_ex2);
 				if (err)
-					goto fallback;
+					goto zeroout_unlock;
 			}
 
 			split_map.m_len += split_map.m_lblk - ee_block;
 			split_map.m_lblk = ee_block;
 			*allocated = map->m_len;
 		}
+zeroout_unlock:
+		ext4_conv_pending_zeroout_unlock(inode);
 	}
 
-fallback:
 	path = ext4_split_convert_extents(handle, inode, &split_map, path,
 					  flags | EXT4_GET_BLOCKS_CONVERT, NULL);
 	if (IS_ERR(path))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6ede3644a738..280ba3d359e3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -669,6 +669,98 @@ int ext4_map_query_blocks(handle_t *handle, struct inode *inode,
 	return retval;
 }
 
+static void _ext4_conv_pending_mod(struct inode *inode, int n)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	atomic_add(n, &ei->i_conv_pending_ios);
+}
+
+/*
+ * In case endio conversion fails due to factors like ENOSPC or ENOMEM, ext4
+ * uses a fallback where we zeroout the unwritten extents instead of splitting.
+ * However, not all unwritten extents can be zeroed out unconditionally as
+ * they might have data underneath which is pending endio conversion. Zeroing
+ * out such an extent can cause silent corruption.
+ *
+ * To fix this we track the IOs which are about to undergo conversion in
+ * ei->i_conv_pending_ios. The zeroout code then uses this counter to
+ * determine if it's safe to zeroout.
+ *
+ * Design Notes:
+ *
+ * **Locking**
+ *
+ * The only mutual exclusion we need is between an IO that is about to be
+ * submitted over an unwritten extent and zeroout. This is done using a
+ * dedicated rwsem, ei->i_conv_pending_sem with the following rules:
+ *
+ * 1. Incrementing the counter must down_read(i_conv_pending_sem).
+ * 2. A zeroout must check the counter and zero data under
+ *    down_write(i_conv_pending_sem)
+ * 3. Decrementing the counter needs no lock. At worst, this makes zeroout bail
+ *    out due to a stale, elevated counter value, which is acceptable
+ * 4. Changes to i_conv_pending_ios should use atomic helpers.
+ *
+ * This design provides us the required exclusion while ensuring that fast paths
+ * don't see any heavy lock contention. Atomic counters help parallel
+ * modifications to be serialized.
+ *
+ * ** Tolerance for false positives **
+ *
+ * We trade false positives for simplicity of implementation because having a
+ * false positive here will just error the endio which is still better than
+ * silently corrupting the data. We can always optimize our tracking to make it
+ * more accurate in the future.
+ */
+void ext4_conv_pending_inc(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	down_read(&ei->i_conv_pending_sem);
+	_ext4_conv_pending_mod(inode, 1);
+	up_read(&ei->i_conv_pending_sem);
+}
+
+void ext4_conv_pending_sum(struct inode *inode, int n)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	down_read(&ei->i_conv_pending_sem);
+	_ext4_conv_pending_mod(inode, n);
+	up_read(&ei->i_conv_pending_sem);
+}
+
+/*
+ * Same as ext4_conv_pending_inc() but doesn't sleep if a zeroout is in
+ * progress. Returns -EAGAIN and leaves the counter untouched in that case.
+ */
+int ext4_conv_pending_inc_trylock(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	if (!down_read_trylock(&ei->i_conv_pending_sem))
+		return -EAGAIN;
+
+	_ext4_conv_pending_mod(inode, 1);
+	up_read(&ei->i_conv_pending_sem);
+	return 0;
+}
+
+void ext4_conv_pending_dec(struct inode *inode)
+{
+	_ext4_conv_pending_mod(inode, -1);
+}
+
+void ext4_conv_pending_sub(struct inode *inode, int n)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	down_read(&ei->i_conv_pending_sem);
+	_ext4_conv_pending_mod(inode, -n);
+	up_read(&ei->i_conv_pending_sem);
+}
+
 int ext4_map_create_blocks(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map, int flags)
 {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7d8aedfbbb87..866a6a70535e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1429,6 +1429,8 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_es_shrink_lblk = 0;
 	ei->i_es_seq = 0;
 	ei->i_reserved_data_blocks = 0;
+	atomic_set(&ei->i_conv_pending_ios, 0);
+	init_rwsem(&ei->i_conv_pending_sem);
 	spin_lock_init(&(ei->i_block_reservation_lock));
 	ext4_init_pending_tree(&ei->i_pending_tree);
 #ifdef CONFIG_QUOTA
@@ -1505,6 +1507,16 @@ static void ext4_destroy_inode(struct inode *inode)
 		ext4_msg(inode->i_sb, KERN_ERR,
 			 "Inode %llu (%p): EXT4_STATE_DISKSIZE_GROW_PENDING not cleared!",
 			 inode->i_ino, EXT4_I(inode));
+
+	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS) &&
+	    !ext4_emergency_state(inode->i_sb)) {
+		int pending = atomic_read(&EXT4_I(inode)->i_conv_pending_ios);
+
+		if (WARN_ON_ONCE(pending))
+			ext4_msg(inode->i_sb, KERN_ERR,
+				 "Inode %llu (%p): i_conv_pending_ios (%d) not cleared!",
+				 inode->i_ino, EXT4_I(inode), pending);
+	}
 }
 
 static void ext4_shutdown(struct super_block *sb)
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 92048da9dae4..7d255c47c446 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -43,6 +43,7 @@ struct partial_cluster;
 	{ EXT4_GET_BLOCKS_CONVERT,		"CONVERT" },		\
 	{ EXT4_GET_BLOCKS_METADATA_NOFAIL,	"METADATA_NOFAIL" },	\
 	{ EXT4_GET_BLOCKS_NO_NORMALIZE,		"NO_NORMALIZE" },	\
+	{ EXT4_GET_BLOCKS_NO_CONV_ACC,		"NO_CONV_ACC" },	\
 	{ EXT4_GET_BLOCKS_CONVERT_UNWRITTEN,	"CONVERT_UNWRITTEN" },  \
 	{ EXT4_GET_BLOCKS_ZERO,			"ZERO" },		\
 	{ EXT4_GET_BLOCKS_IO_SUBMIT,		"IO_SUBMIT" },		\

-- 
2.55.0

