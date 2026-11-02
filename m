Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.54.127.64
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630284;
	b=SwyEg6mPMXlcbxUukHiBTs1GaB3ut6bZRtmEUT+Y6IoCiNEImB8Jt/IWtod1u+ewAtyH
	 nQ7/66pWx2bRcuYQYAlwItKg+oYHrhfsiYeh7faVJoFZNJ9GmM+MwoMvDDZoXAn2HBYvs
	 1v368BmmLQI9+EnNEOSSNbKJoEAcHkIW6eKi70MlqfC6en0KjVHd47talBhsjgS29+kd9
	 Y5LneRKXF8kAtc79oQmeI1cvyRWN82ymGPxmA5FADTkboqzxjtQ7xp/dnso0kux7BU6g1
	 lVfMclxqvBxiPWxiNotdKsRPKWdoDmgigndnwpTbXfkETg8lCHNwXMe9siIw/Vo0Z4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630284;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Envelope-From;
	bh=wBx+MW7ytenVQ5QcD+McGMQds+5D0/R/JflXMW9QXVY=;
	b=q3m9w6ARhd+A3HuDa+AQq9iBMZKfI7e39jg7Ur7oKwgNfOsLxGsNZuCYdPG5fBakqvS2
	 Dw7IRTFC+VZ+3aT6+FfLvd+iBxSJRdVNzyEeAJoOzAWQfs1U8FseOhMk6Pw3i6q3QDibb
	 IfPO3KqJ2GEhtiQhiRSnJ4UeNrnWXCQ5qn7QTcSEjUMV2hDIzUZoRL4T2tsNaHWIBmEGy
	 SP03keOdzNbjuCgwlzydkksjz2kf91w7RTDCOVkG2Bg8rzs7gfjPpOYMIoF3SWhJacz1c
	 IxdoPbAlF5MIE7K3yV6wBeeOPeiHyPQxrhj+CfM2fBXJEsMpQPp+ig5OCUVarg0o2yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=elliotjb.com;
	spf=pass smtp.mailfrom=elliotjb.com;
	dkim=pass header.d=elliotjb.com header.i=@elliotjb.com header.a=rsa-sha256 header.s=default header.b=jTDCxYcp;
	arc=none smtp.remote-ip=198.54.127.64
Received: from out-zbxj-a64.jellyfish.systems (out-zbxj-a64.jellyfish.systems [198.54.127.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF37606E036
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 14:38:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EF37606E036
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=elliotjb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=elliotjb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=elliotjb.com header.i=@elliotjb.com header.a=rsa-sha256 header.s=default header.b=jTDCxYcp
Received: from mail.privateemail.com (unknown [77.233.63.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.privateemail.com (Postfix) with ESMTPSA id 4jJDnf1dkwz8sWQ;
	Mon, 02 Nov 2026 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=elliotjb.com;
	s=default; t=1793630265;
	bh=wBx+MW7ytenVQ5QcD+McGMQds+5D0/R/JflXMW9QXVY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jTDCxYcpoCoLfht1/lMrbebeKE2Uf4oJKrmL/F0A0bwtQvHvxrHrxOMyBhbxG8w5y
	 CcFH0jrHpECE4E2Y3up7GOw4zHlHj8cyboOpogp39rLTvnRAaR4aVyKsJB5QtUMlqp
	 bBfC/8YXfQ7o2kU8rpcAvtQMGSDeWuiBf+d44kvd4pIcjj7WsRgcGgf/bTCx0iCaKy
	 JbmYC58tgorEix7PngBCQdw1sNqTTyuRZYZv3+bSp14QxY6Q5d7aaxJQ8TEZfTkgnS
	 IW9ELlsHqLm+uVytjISV1j7Y0a9Aj8UykVcTOvAFzgebsqPH83P4e/ihTCCBZK6QJF
	 fxoJnlTX2vxGg==
From: Elliot Berman <elliotjb@elliotjb.com>
Date: Mon, 02 Nov 2026 06:37:03 -0800
Subject: [PATCH 6.1.y 1/2] ext4: fix NULL folio dereference in mballoc
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
Message-Id: <20261102-ext4-ntfs3-null-folio-v1-1-4fd91ee23a4a@elliotjb.com>
References: <20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com>
In-Reply-To: <20261102-ext4-ntfs3-null-folio-v1-0-4fd91ee23a4a@elliotjb.com>
To: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Sasha Levin <sashal@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Yongjian Sun <sunyongjian1@huawei.com>, Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev, 
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 ntfs3@lists.linux.dev, Tom Bereknyei <tomberek@gmail.com>, 
 Elliot Berman <elliotjb@elliotjb.com>
X-Mailer: b4 0.15.2
X-Envelope-From: elliotjb@elliotjb.com

In 6.1, __filemap_get_folio() returns NULL on failure. The backported
folio conversion of mballoc keeps the original IS_ERR() checks, so they
are always false here. The fast-path lookup in ext4_mb_load_buddy_gfp()
has no FGP_CREAT and returns NULL whenever the bitmap or buddy page of
an initialised group has been evicted from the page cache, e.g. by
drop_caches or memory pressure. The next block allocation from that
group then oopses under ext4_mb_regular_allocator().

$ echo 3 > /proc/sys/vm/drop_caches, in 0.51 seconds)
$ dd if=/dev/zero of=/mnt/b0 bs=1M count=4 conv=fsync
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 5f19067 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 0 PID: 908 Comm: dd Not tainted 6.1.191 #1-NixOS
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
RIP: 0010:ext4_mb_load_buddy_gfp (fs/ext4/mballoc.c:1536 (discriminator 1)) ext4
Call Trace:
 <TASK>
ext4_mb_regular_allocator (fs/ext4/mballoc.c:1641 fs/ext4/mballoc.c:2798) ext4
ext4_mb_new_blocks (fs/ext4/mballoc.c:5793) ext4
 ? ext4_find_extent (fs/ext4/extents.c:925) ext4
ext4_ext_map_blocks (fs/ext4/extents.c:4369) ext4
   ...

Check for NULL instead and return -ENOMEM, as failures did before the
conversion.

Fixes: d34e4fd4e73f ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
Fixes: 862483175d3d ("ext4: convert bd_buddy_page to bd_buddy_folio")
Reported-by: Tom Bereknyei <tomberek@gmail.com>
Signed-off-by: Elliot Berman <elliotjb@elliotjb.com>
---
 fs/ext4/mballoc.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e77d56c533c0..d0b276ce9401 100644
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
2.54.0

