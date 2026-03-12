Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4642C40DFA1;
	Thu, 12 Mar 2026 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337561; cv=none; b=nVcC9O/D26EeCj0ddqzhhQFl7BejKjayyh+Mcl/uVUDKWFBFtdZW9UmG6IaBm0187v4zsCeBMUXfRjspyBY0ds/v5Ius+AtLsMPahMTDpOLChvW7gQD/s9klb6xZwRo1KTgEDIYBCrZ3/tMuWg7meQaAUJgEovopVip8Pyzs5ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337561; c=relaxed/simple;
	bh=u9RCVBYhrCsw7Sc05k3oH2aQEDTtub9S34F3Er/32co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGY9rbqR2q++ifxDw75hJjN5hpDpDFAwvFdrtMbxbmsSsE1N9yeJwAhC7K6a5QiabAByjk8ySFubpQUD6HolAzpNKZTPlC4RjcR2ha6sScr+F2treCMHZej3QYFTI4GDsHNAoJeJYaevVNMt3GkvS5xuoJsuuIx4SvHf90HJr/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OdXKD4+C; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OdXKD4+C"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62CE1YYa2279199;
	Thu, 12 Mar 2026 17:45:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=WYzfgkmHlyhFYbGgh0uRwqZNtZjxr5
	mKmghWjhspuGM=; b=OdXKD4+ClFuTrWEpbUGXBt7PgIlSSm3y+wGfQHNLmo3Tb1
	HLIEmXoQ/ragR0xmsGu+Gt288nWVUSUTVda6uVhOh8ArlI1GW5VyyE7Pr8UdFvT9
	LnrsQ/CIwIuDTFcElEFX8E5m9wdsHOxa6a8CIS6f6UkD/6VhRkpkRzWm8F5JNzzY
	sA8QTEKjKkmahhnR+bWkQ65gFkhVs6kYUPLgeP3GCcIS6yHoO5QZtzOrw0qqlqf8
	F4tWFYPUgIG7gwSbG0DM7F/gyfoOIqD757SnZ400bx7vOl5XDcPbtbJOHYpukbW7
	bgutMSTFFDfKHhrYbjpgKVS81kqK3HoMtlirDHTA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh91m3cg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 17:45:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62CENQul008821;
	Thu, 12 Mar 2026 17:45:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha73dwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 17:45:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CHjqcu29950658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 17:45:52 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0CF720070;
	Thu, 12 Mar 2026 17:45:52 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 232562006A;
	Thu, 12 Mar 2026 17:45:51 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.24.67])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 12 Mar 2026 17:45:50 +0000 (GMT)
Date: Thu, 12 Mar 2026 23:15:48 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: syzbot <syzbot+ccf1421545dbe5caa20c@syzkaller.appspotmail.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
Subject: Re: [syzbot] [ext4?] kernel BUG in ext4_es_cache_extent (4)
Message-ID: <abL7zFZvQv9yddtu@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <6989419b.050a0220.3b3015.0065.GAE@google.com>
 <69a73447.a70a0220.b118c.0012.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lUyFTQojouXCY1ux"
Content-Disposition: inline
In-Reply-To: <69a73447.a70a0220.b118c.0012.GAE@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TbriprdI-fL0ncyXZM4aJpabLFLnFqzc
X-Authority-Analysis: v=2.4 cv=E6/AZKdl c=1 sm=1 tr=0 ts=69b2fbd4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=edf1wS77AAAA:8 a=3g80flMcAAAA:8 a=VwQbUJbxAAAA:8
 a=c0fGERfNswHVGkjTFikA:9 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10
 a=ODdyehY1IsyT0BtBtVMA:9 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22
 a=3urWGuTZa-U-TZ_dHwj2:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDE0MSBTYWx0ZWRfX1w8pbJdgQN4Y
 hzIbMrBjHka8FcHORRbkEOug/EVbvEozu34l893cJCdM7+KtcYu3i2UIXYuSBYQOjkvn1SNk4/v
 HEthWx12i1WzI5HohywaaR/ZiK4isbtCMcXu+i08U0tRcgd9Mn54mzzukK1YTeFDOhiV5fyOfXB
 WqywMq6q43D4lo8WUoGKdNTG/WEFMEKIYkqVL2ycRD3AreB6pSToJOXb74qfs31ccTQVsAWTyoX
 +SBHd/dqJ/SYjFfw2vg+FA+EYwUXSm8yGhO9SS0eR6sZaKQOkyyka5M0oZLtGlYbBkHwph8TMYR
 0jtYIaBg8ZJWw51RzHMe67qnNamaXRkZJZVgn44y2FVtToGYVZXP1VQKMh6QRdT/wYK29l3cvR/
 QSIRHG0nxNAeod+w5VDlldRnzuzW7fBOlU4XaBq7fcZwtYBkV4KwyI7J9Fodmyjzv7cmHFYatxd
 i8bdW6fC+ofwgBfc/eg==
X-Proofpoint-ORIG-GUID: TbriprdI-fL0ncyXZM4aJpabLFLnFqzc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_02,2026-03-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120141


--lUyFTQojouXCY1ux
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 03, 2026 at 11:19:35AM -0800, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    af4e9ef3d784 uaccess: Fix scoped_user_read_access() for 'p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13811b5a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=779072223d02a312
> dashboard link: https://syzkaller.appspot.com/bug?extid=ccf1421545dbe5caa20c
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1620e552580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13810a02580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/f6b75c8f432f/disk-af4e9ef3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4513ad566789/vmlinux-af4e9ef3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f7eea878db42/bzImage-af4e9ef3.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/8d81a7f0b7b8/mount_0.gz
>   fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=1351b006580000)
> 

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

--lUyFTQojouXCY1ux
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename=2-0001-ext4-add-logging-to-debug-issue.patch

From 7086e36d23ddbee429c3f0ca271f7e188f81bd61 Mon Sep 17 00:00:00 2001
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Date: Tue, 10 Feb 2026 17:59:17 +0530
Subject: [PATCH] ext4: add logging to debug issue

---
 fs/ext4/extents.c        | 28 ++++++++++++++++++++++++++++
 fs/ext4/extents_status.c | 20 ++++++++++++++++++++
 fs/ext4/mballoc.c        | 27 +++++++++++++++++++++++++++
 3 files changed, 75 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3630b27e4fd7..89a681f6e5ca 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -529,6 +529,7 @@ static void ext4_cache_extents(struct inode *inode,
 	int i;
 
 	KUNIT_STATIC_STUB_REDIRECT(ext4_cache_extents, inode, eh);
+	ext4_warning_inode(inode, "%s: caching extents\n", __func__);
 
 	for (i = le16_to_cpu(eh->eh_entries); i > 0; i--, ex++) {
 		unsigned int status = EXTENT_STATUS_WRITTEN;
@@ -2006,6 +2007,22 @@ ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 		goto errout;
 	}
 
+	ext4_warning_inode(
+		inode,
+		"%s: add newext [%u, %u, %llu, unwrit:%d] to extent tree.\n",
+		__func__, le32_to_cpu(newext->ee_block),
+		ext4_ext_get_actual_len(newext), ext4_ext_pblock(newext),
+		ext4_ext_is_unwritten(newext));
+
+	if (ex) {
+		ext4_warning_inode(
+			inode,
+			"%s: ext at current path: [%u, %u, %llu, unwrit:%d]\n",
+			__func__, le32_to_cpu(ex->ee_block),
+			ext4_ext_get_actual_len(ex), ext4_ext_pblock(ex),
+			ext4_ext_is_unwritten(ex));
+	}
+
 	/* try to insert block into found extent and return */
 	if (ex && !(gb_flags & EXT4_GET_BLOCKS_SPLIT_NOMERGE)) {
 
@@ -2832,6 +2849,11 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 	int i = 0, err = 0;
 	int flags = EXT4_EX_NOCACHE | EXT4_EX_NOFAIL;
 
+	ext4_warning_inode(
+		inode,
+		"%s: remove range [%u, %u] from extent tree\n",
+		__func__, start, end);
+
 	partial.pclu = 0;
 	partial.lblk = 0;
 	partial.state = initial;
@@ -4456,6 +4478,12 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		map->m_flags |= EXT4_MAP_UNWRITTEN;
 	}
 
+	ext4_warning_inode(
+		inode,
+		"%s: add newext [%u, %u, %llu, unwrit:%d] to extent tree.\n",
+		__func__, le32_to_cpu(newex.ee_block),
+		ext4_ext_get_actual_len(&newex), ext4_ext_pblock(&newex),
+		ext4_ext_is_unwritten(&newex));
 	path = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index a1538bac51c6..009c22108a7f 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -847,6 +847,10 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes,
 	struct rb_node *parent = NULL;
 	struct extent_status *es;
 
+	ext4_warning_inode(inode, "%s: add lblk:%u len:%u pblk:%llu status:0x%x]\n", __func__,
+			   newes->es_lblk, newes->es_len, ext4_es_pblock(newes),
+			   ext4_es_status(newes));
+
 	while (*p) {
 		parent = *p;
 		es = rb_entry(parent, struct extent_status, rb_node);
@@ -921,6 +925,10 @@ void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 
 	es_debug("add [%u/%u) %llu %x %d to extent status tree of inode %lu\n",
 		 lblk, len, pblk, status, delalloc_reserve_used, inode->i_ino);
+	ext4_warning_inode(
+		inode,
+		"%s: add lblk:%u len:%u pblk:%llu 0x%x to es\n",
+		__func__, lblk, len, pblk, status);
 
 	if (!len)
 		return;
@@ -1031,6 +1039,11 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 	bool conflict = false;
 	int err;
 
+	ext4_warning_inode(
+		inode,
+		"%s: cache extent lblk:%u len:%u pblk:%llu status:0x%x\n",
+		__func__, lblk, len, pblk, status);
+
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 		return;
 
@@ -1493,6 +1506,11 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	bool count_reserved = true;
 	struct rsvd_count rc;
 
+	ext4_warning_inode(
+		inode,
+		"%s: remove [%u,%u] range from extent status tree of inode %lu\n",
+		__func__, lblk, end, inode->i_ino);
+
 	if (reserved == NULL || !test_opt(inode->i_sb, DELALLOC))
 		count_reserved = false;
 	if (status == 0)
@@ -1633,6 +1651,8 @@ void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 
 	es_debug("remove [%u/%u) from extent status tree of inode %lu\n",
 		 lblk, len, inode->i_ino);
+	ext4_warning_inode(inode, "%s: remove lblk:%u len:%u from es\n",
+			   __func__, lblk, len);
 
 	if (!len)
 		return;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dbc82b65f810..a37d6e3e004d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2004,6 +2004,18 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 	int last = first + count - 1;
 	struct super_block *sb = e4b->bd_sb;
 
+	ext4_fsblk_t pblk =
+		ext4_group_first_block_no(e4b->bd_sb, e4b->bd_group) +
+		(first << EXT4_SB(e4b->bd_sb)->s_cluster_bits);
+
+	if (inode)
+		ext4_warning_inode(inode, "%s: trying to free pblk:%llu count:%d\n",
+				__func__, pblk, count);
+	else
+		ext4_warning(sb, "%s: trying to free pblk:%llu count:%d\n",
+				__func__, pblk, count);
+
+
 	if (WARN_ON(count == 0))
 		return;
 	BUG_ON(last >= (sb->s_blocksize << 3));
@@ -3101,6 +3113,12 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	if (!err && ac->ac_status != AC_STATUS_FOUND && ac->ac_first_err)
 		err = ac->ac_first_err;
 
+	ext4_warning_inode(
+		ac->ac_inode,
+		"%s: Best len %d, origin len %d, ac_status %u, ac_flags 0x%x, cr %d ret %d\n",
+		__func__, ac->ac_b_ex.fe_len, ac->ac_o_ex.fe_len, ac->ac_status,
+		ac->ac_flags, ac->ac_criteria, err);
+
 	mb_debug(sb, "Best len %d, origin len %d, ac_status %u, ac_flags 0x%x, cr %d ret %d\n",
 		 ac->ac_b_ex.fe_len, ac->ac_o_ex.fe_len, ac->ac_status,
 		 ac->ac_flags, ac->ac_criteria, err);
@@ -6251,6 +6269,10 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	sb = ar->inode->i_sb;
 	sbi = EXT4_SB(sb);
 
+	ext4_warning_inode(ar->inode,
+			   "%s: Allocation requested for: lblk:%u len:%d\n",
+			   __func__, ar->logical, ar->len);
+
 	trace_ext4_request_blocks(ar);
 	if (sbi->s_mount_state & EXT4_FC_REPLAY)
 		return ext4_mb_new_blocks_simple(ar, errp);
@@ -6334,6 +6356,11 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 			ext4_mb_pa_put_free(ac);
 	}
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
+		ext4_warning_inode(
+			ar->inode,
+			"%s: Allocation found: lblk:%u, len:%d, pblk:%llu\n",
+			__func__, ar->logical, ac->ac_b_ex.fe_len,
+			ext4_grp_offs_to_block(sb, &ac->ac_b_ex));
 		*errp = ext4_mb_mark_diskspace_used(ac, handle);
 		if (*errp) {
 			ext4_discard_allocated_blocks(ac);
-- 
2.52.0


--lUyFTQojouXCY1ux--

