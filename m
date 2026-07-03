Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDC82F9984;
	Fri,  3 Jul 2026 03:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783049020; cv=none; b=aLPbq2OraOi3MBVwo4oj0az4G7DZydrpEsmDOwRVXSz2uarYLSDupuILcEB0T9dvXLS6Pnwd3ZvbDWMjh4exL3OX5NjW+/tpY9ESIjxK6Jv4RwuQxD5PkYF7zRKc73RDmJ+1UD0EIXyaA29/g244rdP6QqF59NdzW9+1lAlGegY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783049020; c=relaxed/simple;
	bh=X2SI7UvmclVAS8Ei57K3cAeV+SKDgtAA+HDWQZHKm9k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iJ927UqxR5S4KYGxHks+Mb3rULYk8XVTgRdFO1Dg64dDu4/ZDrszVp7wROcPcu1gHZMMZeXIYZ/27xTpBbnw+5V8bGBNrKCBKLR0OdrVqbisx61Fo/dWlnwta4pd/2XgqQdWSSSVDGONUD9ZGEbfWokcoHaUSWVNq+Sp1hyhyiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=aB7N4hOK; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="aB7N4hOK"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6632t3ig3348555;
	Thu, 2 Jul 2026 20:23:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=/CzHcWGqx
	VgUtiWKtueGj4vnyKDNUQr1LUkcqBBy+t4=; b=aB7N4hOKcD/TUoXUcw8a49JDn
	paTEI4+QhkJt6goLVqJtigb9+V90VK6n5wIEU+QEguP3PbF4K1ytbTGOwd8kVOmi
	rWbWFK7nkMTom+JdmmV6TGqKAZwaktgLEhI8OD4dxR7u3ap4oumK/EJIIDAEHvoH
	nPFzxSfOlmF0DcVJaIOEjG35jOCcEpD6KAlG2fBLC7WQXFDIY+/3xONUgBftpZbV
	065kOz4xmGC/HXvTnx7HyjNovnH3OjgGX3X9nAJ5cHPP9H9KOSfwt3RzlVyvV8BB
	cB6bJku6+l8PFFzfMrkI8vSuyBVsdZ1RLKPwUd/7bYB4lQ6MY4oV29NhXCG8Q==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f2e1h0rej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 02 Jul 2026 20:23:07 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 2 Jul 2026 20:23:07 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 2 Jul 2026 20:23:04 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v3] ext4: fix race in ext4_convert_inline_data() leading to BUG_ON in writepages
Date: Fri, 3 Jul 2026 11:23:03 +0800
Message-ID: <20260703032304.4088040-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: cKNmnNzTNdgeDSNIk5mBmUerMamaujQr
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDAyOCBTYWx0ZWRfXxeIpzRYmLIQH
 lFrW2iuXE4HluOOXJkCzMq2r4YacPUqWiSKiWGxeCnxYljgnaOLDZVxbGpaUz4QBLbxorSJojNT
 vTahYRGMmVoAm+QHteuCtH1ChLRI4US0oEpHJqVETTHOvfctoYHL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDAyOCBTYWx0ZWRfX/HG8iOmplGLB
 hjTmSeXp00in3itRtCD1usjaZCzA42oW8op3ikW8wPhFdLKMs8knSm4FNuapq8M7EezHv0DTeaT
 wPNZxE8KGKVgjiIIklkwgvNYaH76dN8ouy9G0N4Up+LIkiBvGNX76T4hhqVAaMtMyez2yllukAj
 eJfbO4ChdSEGENXKCwxhT+z5MFSVcnUqIxynr/r+BR3xhlKUgrXotacA3Zk/CSyPdHOSgOpzPZe
 U8kkV3ZUPQJctShEXM0MJ06OX3vwQNz7bFgy4zPAVxu5jIHN2dgZrC6jSuFwSzq4tRPCVTeUBic
 UGHxzosReyia92ay9SUaEMfF3oTxkl3i9yCoQLBL6vboKa/ThFXEjwWcbaFpl6tqBCpR+NkwMYt
 Cu/flJGGvYZHpGazZD+j/EV3oH7jOVsoSIRZ2Lrm5KwvM89dNIyqGdQeqTOlvB657QjQOp3DAk+
 wnBmEJoqoxB7DS2agZA==
X-Proofpoint-GUID: cKNmnNzTNdgeDSNIk5mBmUerMamaujQr
X-Authority-Analysis: v=2.4 cv=GsByPE1C c=1 sm=1 tr=0 ts=6a472b1b cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=6yhk5WB4rwwjWNa3LaoA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607030028

ext4_convert_inline_data() has two unsafe lockless fast paths that can
observe a transient state from a concurrent convert_inline_data_nolock()
that has destroyed inline data but then fails and restores it.  A racing
thread sees the transient state, concludes no conversion is needed, and
creates dirty pages via block_page_mkwrite().  The restoring thread then
re-sets inline data + MAY_INLINE_DATA, leaving dirty pages coexisting
with inline data, triggering BUG_ON in ext4_do_writepages().

A similar race exists with ext4_da_convert_inline_data_to_extent():
after it copies data to page cache and clears MAY_INLINE_DATA, a
concurrent convert_inline_data_nolock() can restore MAY_INLINE_DATA.

Simply moving the MAY_INLINE_DATA check inside xattr_sem would require
taking the write lock, starting a journal handle, and reading the inode
location on every call -- even for inodes that have long since been
converted.  This causes measurable performance regression on filesystems
with the inline_data feature enabled.

Fix this by introducing EXT4_STATE_INLINE_CONVERTED, a monotonic
(set once, never cleared) per-inode state bit indicating that inline
data has been successfully copied out to page cache or a data block.
This provides:

1. A safe lockless fast path in ext4_convert_inline_data(): once the
   bit is set, return 0 immediately without any locking overhead.

2. A WARN_ON_ONCE guard in convert_inline_data_nolock(): if the bit
   is unexpectedly set at restore time, warn.  This should not happen
   given the MAY_INLINE_DATA check prevents entering nolock when DA
   conversion is in progress.

3. Inside xattr_sem, only call convert_inline_data_nolock() when both
   has_inline_data AND MAY_INLINE_DATA are set.  When has_inline_data
   is set but MAY_INLINE_DATA is clear, DA conversion is in progress;
   skip convert_nolock to avoid destroy+restore re-setting MAY.

The bit is set in all successful conversion paths:
- ext4_convert_inline_data_nolock() on success
- ext4_convert_inline_data() when inline data is gone after nolock
- ext4_da_convert_inline_data_to_extent() after page cache copy
- ext4_convert_inline_data_to_extent() after block_commit_write

Fixes: 7b4cc9787fe3 ("ext4: evict inline data when writing to memory map")
Reported-by: syzbot+d1da16f03614058fdc48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
v3:
- Introduce EXT4_STATE_INLINE_CONVERTED monotonic bit for safe lockless
  fast path, avoiding performance regression from always taking xattr_sem.
- Add WARN_ON_ONCE at restore point as sanity check.
- Skip convert_nolock when MAY_INLINE_DATA is clear (DA convert in
  progress) to prevent destroy+restore re-setting MAY.

v2:
- Reworked fix: root cause confirmed via ftrace.
- Removed both unsafe lockless fast paths, serialize under xattr_sem.
- Skip convert_nolock when MAY_INLINE_DATA is clear (DA convert in
  progress) to prevent destroy+restore from re-setting MAY.

 fs/ext4/ext4.h   |  1 +
 fs/ext4/inline.c | 44 ++++++++++++++++++++++++++------------------
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b9b0ada7774b..310aeb14f9f0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2049,6 +2049,7 @@ enum {
 	EXT4_STATE_FC_FLUSHING_DATA,	/* Fast commit flushing data */
 	EXT4_STATE_ORPHAN_FILE,		/* Inode orphaned in orphan file */
 	EXT4_STATE_FC_REQUEUE,		/* Inode modified during fast commit */
+	EXT4_STATE_INLINE_CONVERTED,	/* inline data copied out, do not restore */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field, offset)				\
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..1b6abacf12e6 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -671,6 +671,8 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
 
 	if (folio)
 		block_commit_write(folio, from, to);
+	if (folio && !ret)
+		ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
 out:
 	if (folio) {
 		folio_unlock(folio);
@@ -921,6 +923,7 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
 	clear_buffer_new(folio_buffers(folio));
 	folio_mark_dirty(folio);
 	folio_mark_uptodate(folio);
+	ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
 	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	*fsdata = (void *)CONVERT_INLINE_DATA;
 
@@ -1172,8 +1175,14 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 	}
 
 out_restore:
-	if (error)
-		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
+	if (error) {
+		WARN_ON_ONCE(ext4_test_inode_state(inode,
+					EXT4_STATE_INLINE_CONVERTED));
+		ext4_restore_inline_data(handle, inode, iloc, buf,
+					 inline_size);
+	} else {
+		ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
+	}
 
 out:
 	brelse(data_bh);
@@ -1959,22 +1968,16 @@ int ext4_convert_inline_data(struct inode *inode)
 	handle_t *handle;
 	struct ext4_iloc iloc;
 
-	if (!ext4_has_inline_data(inode)) {
-		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	if (!ext4_has_feature_inline_data(inode->i_sb))
+		return 0;
+
+	/*
+	 * Once inline data has been successfully copied out (to page
+	 * cache or a data block), this bit is set and never cleared.
+	 * It is safe to check without locks -- the bit is monotonic.
+	 */
+	if (ext4_test_inode_state(inode, EXT4_STATE_INLINE_CONVERTED))
 		return 0;
-	} else if (!ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
-		/*
-		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
-		 * cleared. This means we are in the middle of moving of
-		 * inline data to delay allocated block. Just force writeout
-		 * here to finish conversion.
-		 */
-		error = filemap_flush(inode->i_mapping);
-		if (error)
-			return error;
-		if (!ext4_has_inline_data(inode))
-			return 0;
-	}
 
 	needed_blocks = ext4_chunk_trans_extent(inode, 1);
 
@@ -1990,8 +1993,13 @@ int ext4_convert_inline_data(struct inode *inode)
 	}
 
 	ext4_write_lock_xattr(inode, &no_expand);
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		error = ext4_convert_inline_data_nolock(handle, inode, &iloc);
+	if (!ext4_has_inline_data(inode)) {
+		ext4_set_inode_state(inode, EXT4_STATE_INLINE_CONVERTED);
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	}
 	ext4_write_unlock_xattr(inode, &no_expand);
 	ext4_journal_stop(handle);
 out_free:
-- 
2.43.0

