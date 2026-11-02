Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637228;
	b=g1U3uyDF7kI2yvNGEeR2b9El8S0mekT/Vo3b7IJ/VXL6hcbsEFX8sHrIS33ZBjZPBjC+
	 65Uldzf06Y3jQV1tB0tn3QOQSJemQbBhdFtXF5/bmNcAdbLLAlhZ/eVnXm5uRUnf97r5R
	 NA/qR/SHx3JK3Lg9LDp23pTOFYHCW7/ajVuML9I8pLXFnm6O9iRB1jg68cvQLwSXU0RBZ
	 cUCwh14D5aQD1lcU13Tgv82Qa/nrTbsvd9JK8YBeb4nEaUVDjEz6G5AsDqk7ffWd6xsH5
	 bAnHlXaYRFhIHeWbeuZbzDvnDQxJbbb/wDmnJfS1YbFkAavqoV3c0LSTWFJpfxDHapw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637228;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=+CGY7tF70V7u0OLBsqICi+tyqkgLNUWhoT5j+slS+i4=;
	b=3G7vkvoVVP6ktyrEGKsKd11QDnSZAeXLXa1D9cbeW8IxdVH6/9ecj3EyISdgtINwTpR3
	 mJ3gSMI7rbaisyJxFzjF3ryZAbKgDmcR76jMYPwmYVGM/3+YuPW52Yvm//Fsk1e7awDSV
	 TtuWSxZQfinUJMHCtKPTz16rC4VgE5lxT70y1lfMm0jzMv89NXVEeIsbWW94fxoZS5HLU
	 03lJ/z9fE4YJFVM1L/og0jbkR59PJ5R8SHlL8LVqoWOzIdI7rDtkZaNBz7dvb0gWMoRHJ
	 3G7v/i4aBIrdTEUvNoqdrhN7jc3M/wAjgAn2+4q0tvsTtnhLa0wgrQmf88hbh07xBKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=nMHmjLx6;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641AF608B071;
	Mon,  2 Nov 2026 16:33:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 641AF608B071
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=nMHmjLx6
Received: from CPC-namja-026ON.localdomain (unknown [4.213.232.20])
	by linux.microsoft.com (Postfix) with ESMTPSA id 70DD320B7166;
	Mon,  2 Nov 2026 08:33:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 70DD320B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793637213;
	bh=+CGY7tF70V7u0OLBsqICi+tyqkgLNUWhoT5j+slS+i4=;
	h=From:To:Cc:Subject:Date:From;
	b=nMHmjLx6ZrNTEQcSPL+YLY1D6PQ4a0bqbF7xWfK0RDhwJx5kIfu6sc3Zt5YZoF2si
	 SVN9PM9f/9Qp2pTFa8dqpLdekjyFSsSlVzXnVXrNiRXLWUlmOKDXv4OUh1vh4iifbr
	 A+zFwfPPoTxQjtY3kTpDxrCVYQH2gQKAZGjJs444=
From: Naman Jain <namjain@linux.microsoft.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sasha Levin <sashal@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: stable@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.1] ext4: honor NULL returns from __filemap_get_folio()
Date: Mon,  2 Nov 2026 16:33:41 +0000
Message-ID: <20261102163341.2170232-1-namjain@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
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

The bitmap and buddy folio conversions assume that
__filemap_get_folio() returns error pointers. In Linux 6.1, however,
it returns NULL both when a non-creating lookup misses and when folio
creation fails.

A cache miss therefore passes the IS_ERR() check and reaches
folio_test_uptodate(NULL) in ext4_mb_load_buddy_gfp(). Creating-lookup
failures can also dereference NULL in its slow paths and in
ext4_mb_get_buddy_page_lock().

Restore NULL checks at all six lookup sites and return -ENOMEM when a
creating lookup fails. Preserve the folio locking and migration checks
without changing the global filemap API.

Fixes: d34e4fd4e73f ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
Fixes: 862483175d3d ("ext4: convert bd_buddy_page to bd_buddy_folio")
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
---
 fs/ext4/mballoc.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e77d56c533c0b..d0b276ce9401c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1375,8 +1375,8 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 	poff = block % blocks_per_page;
 	folio = __filemap_get_folio(inode->i_mapping, pnum,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+	if (!folio)
+		return -ENOMEM;
 	BUG_ON(folio->mapping != inode->i_mapping);
 	e4b->bd_bitmap_folio = folio;
 	e4b->bd_bitmap = folio_address(folio) + (poff * sb->s_blocksize);
@@ -1389,8 +1389,8 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 	/* blocks_per_page == 1, hence we need another page for the buddy */
 	folio = __filemap_get_folio(inode->i_mapping, block + 1,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+	if (!folio)
+		return -ENOMEM;
 	BUG_ON(folio->mapping != inode->i_mapping);
 	e4b->bd_buddy_folio = folio;
 	return 0;
@@ -1533,7 +1533,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 
 	/* Avoid locking the folio in the fast path ... */
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
+	if (!folio || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
 		/*
 		 * folio_test_locked is employed to detect ongoing folio
 		 * migrations, since concurrent migrations can lead to
@@ -1543,11 +1543,11 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 		 * try to get the folio with lock in both cases to avoid
 		 * concurrency.
 		 */
-		if (!IS_ERR(folio))
+		if (folio)
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
 				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-		if (!IS_ERR(folio)) {
+		if (folio) {
 			if (WARN_RATELIMIT(folio->mapping != inode->i_mapping,
 	"ext4: bitmap's mapping != inode->i_mapping\n")) {
 				/* should never happen */
@@ -1567,8 +1567,8 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 			folio_unlock(folio);
 		}
 	}
-	if (IS_ERR(folio)) {
-		ret = PTR_ERR(folio);
+	if (!folio) {
+		ret = -ENOMEM;
 		goto err;
 	}
 	if (!folio_test_uptodate(folio)) {
@@ -1585,12 +1585,12 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	poff = block % blocks_per_page;
 
 	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
-	if (IS_ERR(folio) || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
-		if (!IS_ERR(folio))
+	if (!folio || !folio_test_uptodate(folio) || folio_test_locked(folio)) {
+		if (folio)
 			folio_put(folio);
 		folio = __filemap_get_folio(inode->i_mapping, pnum,
 				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
-		if (!IS_ERR(folio)) {
+		if (folio) {
 			if (WARN_RATELIMIT(folio->mapping != inode->i_mapping,
 	"ext4: buddy bitmap's mapping != inode->i_mapping\n")) {
 				/* should never happen */
@@ -1609,8 +1609,8 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 			folio_unlock(folio);
 		}
 	}
-	if (IS_ERR(folio)) {
-		ret = PTR_ERR(folio);
+	if (!folio) {
+		ret = -ENOMEM;
 		goto err;
 	}
 	if (!folio_test_uptodate(folio)) {
-- 
2.43.0

