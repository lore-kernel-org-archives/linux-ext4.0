Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713854;
	b=Co7KPOB/F1R2kuIwVOKxt7CtlGJNcXGuWZD1nzffQ+eS70QypYSP8WLW3p4d6usi40yg
	 MfOuu7caZf7vp/6OBcchYPjF4gFdB/saZO49IYemMvGzeN5zk3o2R6YPKPLiKcLxsrukU
	 fP6alO6jiit7ULiP6SVXEqG2NfWvW3p2riP9RqPxjI2ew9Xdm5u3X0nCHVtvruHHcdqCh
	 GufilXAa2Cs4wrnfTLOorJjLRAEYYPItt/OgJwlum8l5YnSexDgdQ/Q8vbuyqPlzrEAxd
	 S/cPFKIgYy/3CfGUWrsmQcJ9qK0B3moESUrLWoIT9r8J48t+RUrGSsdfTTlCFG03Dqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713854;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+YoUrwnGFlf9PhKVVziY+9mIf92auvk+c99LsR9rxiE=;
	b=OhNtEDYhv51RNchv3Jv5x9+gobZ2XCdteMNplVnIW2RAZ5jZQyISLhOOxpWAGuUO1Am1
	 traR7ulw5wtmGOtoAfjP8wAcJmUP+oKR43QReDLZ4NC9tOesKdrnAQ6f09pEA6qBttMM4
	 S/9JuUmbbJoCyR5QWiXRgiWk473hr0bSbGWPcHQxSuti9YeFVIGln89nLWVu8KN8jxhZY
	 T8sBYVmOQ/JpJ71j6uzfQAD/mp+jzn95ph59JatYn+jkXRXfapso5Ggd7WrTt4ZAoD4fk
	 eG3lT59xENGVxXBDypwXjjpgxsISBBOiuXAMi0y34gN4ETMWLaFyw7E2jqR2oer0eHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vv37Wz74;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E46606EE85
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74E46606EE85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vv37Wz74
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48b001cd92bso2251519f8f.2
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713853; x=1794318653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+YoUrwnGFlf9PhKVVziY+9mIf92auvk+c99LsR9rxiE=;
        b=Vv37Wz74K2zKKqrTIFa2vRnZ3BwHkxJqiL0+/oOVOY5Vx9/FB5nGDhCGFjbGJnSAPY
         afR7uYtZo1GNt/QLTXx2XbvXwg0KRT6nfeEP0lCJAM1mjKY/9DDvEOZVLjr7dYKCbs8D
         E0XMC28jM00134ZHJAOLF/weJTBe6kpUWg7BWVZvdghLo5EKhhScVjOFpJlXJyqP+sXQ
         5nRTdVn+Q7EUG/Ums/FMNqEVNeV0gojGOlyXQpcj07qpzEKYXgImWBn58BvQj+cBaDFg
         3tHASe7t2zWlEjqV8tujhXroeS0c4aRUOTSoSOib4r4jM8VWBxT5J2MB1995cjovunD2
         63DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713853; x=1794318653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+YoUrwnGFlf9PhKVVziY+9mIf92auvk+c99LsR9rxiE=;
        b=HZ67jrWusDX52vexqYLByckqfV1qyWNkPYwKTWMJYbkEM/i+0G2vfhu8VeRvIEg5iD
         NUKhQSWvob1FNCqEqaVNSmqWTfGhPswT6H9Tri0Jhew+6nORgRhvMrRphox0kNtCTOD1
         d0wCXCdV7VsCVdLST+tOPPyffWYQHZu7wGQW1R8XBxa0UrkMT89FDjOyEPdYxR6w+Vpv
         sPy4BVHd0u9Trqpb9TH0U5wskAsiYq9xAFOP7LVTkRF636vARjUDWWhVlm2coaRyoHPY
         dYaxokcGTYmFIb4JLPQPdTkG/9QJex6YqfH8XKfclyBimJFVVBfsufeX/sq7cMmvtb8o
         SYZg==
X-Gm-Message-State: APuU4Z8tpXlN4VEU/WmqiJ2wAUTgJEj4PMiYyjZ6KvcDsZYh3+3AwAXt
	gXMovDVYmItUQy5nRZJABgSC3FkjCZm+D4+94yxajKBOr/b7U3nMJs15ota7E90V+aI=
X-Gm-Gg: AYBFou36YOQdC+QK5XSSw8jg9VDetKz4B4XePaAQx9WFEJx6BHk5Aj+HX/U8eIMBO0D
	2LcRcnrNPl7kFWrqprIvaHuVDavZ7ZVEzwBJYWucxHAMCYyXxEb+KafavHsR+PpQNWPRD3onylh
	PIoGR5MPqWuPh0en5Iq83WiAoXrsgsUh0XlfTgmhS9f/JoLkHOLkOyDTwUVo7GjVoQn3FUsHk3C
	FZWh/Rh6H3zCjYSAomjWmT8aHLQDNf+oT+5nvdW6CsBnNpqE8gUPo3tQ5p1Vb/LcTvzC2i5DKzt
	X/jDlrYki4WwyIyDPkv30W3k7n1BaQErj33fOy0OiXg2hOyvsPRY8KaTFn58NtIoK3IUs0isP9r
	hPNrppaNq8FCaJpWsp1oqIrogX32pzMxYdJ4zj7hiMv0El+8b6Xx0+QKmwZ4TS0lefuK76j4RJf
	UDCJGAcwyHMedLVCy7s/sSJHzDSc9/nKeZzQvykV34k/BrocLLhLv9UBll1Cbm/7GuT3n0w4vlg
	Z2B5yfxR+ZB82BM6wfpi5wnYJomzNjP/dJMky8SBrTUKDzPjF5HeXxTlE9eRwOWHx6/HIQzdzKr
	rkK//trcScwQhlt8BxCXE3JddhAnYLAuTS2M9HACb/dMRJiKIoMAoiBFqxZq
X-Received: by 2002:a05:6000:2889:b0:48e:f10:ceb8 with SMTP id ffacd0b85a97d-48e6e2e769amr27231528f8f.11.1793713852889;
        Tue, 03 Nov 2026 05:50:52 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:52 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 04/13] libext2fs: add helper for dx_root_info lookup
Date: Tue,  3 Nov 2026 13:50:28 +0000
Message-ID: <20261103135037.610132-5-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
References: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
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

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Add dirdata support infrastructure in the new lfsck.h header, with
data structures (lu_fid, ext4_dirent_data_header, ext4_dirent_hash)
related to dirdata fields.

Also changes to ext2_fs.h and ext2fs.h to support INCOMPAT_DIRDATA.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/htree.c     |  2 +-
 e2fsck/pass1.c      |  2 +-
 e2fsck/pass2.c      |  7 +++----
 lib/ext2fs/ext2fs.h | 19 +++++++++++++++++++
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 4ea8f30b..efb85827 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -298,7 +298,7 @@ void do_htree_dump(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 		goto errout;
 	}
 
-	rootnode = (struct ext2_dx_root_info *) (buf + 24);
+	rootnode = ext2fs_get_dx_root_info(current_fs, buf);
 
 	fprintf(pager, "Root node dump:\n");
 	fprintf(pager, "\t Reserved zero: %u\n", rootnode->reserved_zero);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 0331711a..0777b8e0 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2804,7 +2804,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 		return 1;
 
 	/* XXX should check that beginning matches a directory */
-	root = (struct ext2_dx_root_info *) (block_buf + 24);
+	root = ext2fs_get_dx_root_info(fs, block_buf);
 
 	if ((root->reserved_zero || root->info_length < 8) &&
 	    fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 319e7e0e..cf1678c8 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -650,7 +650,7 @@ static void parse_int_node(ext2_filsys fs,
 	int		csum_size = 0;
 
 	if (db->blockcnt == 0) {
-		root = (struct ext2_dx_root_info *) (block_buf + 24);
+		root = ext2fs_get_dx_root_info(fs, block_buf);
 
 #ifdef DX_DEBUG
 		printf("Root node dump:\n");
@@ -677,8 +677,7 @@ static void parse_int_node(ext2_filsys fs,
 				&cd->pctx)))
 			goto clear_and_exit;
 	}
-
-	limit = (struct ext2_dx_countlimit *) ent;
+	limit = (struct ext2_dx_countlimit *)ent;
 
 #ifdef DX_DEBUG
 	printf("Number of entries (count): %d\n",
@@ -1236,7 +1235,7 @@ inline_read_fail:
 		(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 		limit = (struct ext2_dx_countlimit *) (buf+8);
 		if (db->blockcnt == 0) {
-			root = (struct ext2_dx_root_info *) (buf + 24);
+			root = ext2fs_get_dx_root_info(fs, buf);
 			dx_db->type = DX_DIRBLOCK_ROOT;
 			dx_db->flags |= DX_FLAG_FIRST | DX_FLAG_LAST;
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 91d26986..cf12716e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -2262,6 +2262,25 @@ _INLINE_ int ext2fs_htree_intnode_maxrecs(ext2_filsys fs, int blocks)
 						sizeof(struct ext2_dx_entry));
 }
 
+_INLINE_ struct ext2_dx_root_info *ext2fs_get_dx_root_info(ext2_filsys fs,
+							 char *buf)
+{
+	struct ext2_dir_entry *de = (struct ext2_dir_entry *)buf;
+
+	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_DIRDATA))
+		return (struct ext2_dx_root_info *)(buf +
+						    EXT2_DIR_NAME_LEN(1) +
+						    EXT2_DIR_NAME_LEN(2));
+
+	/* get dotdot first */
+	de = (struct ext2_dir_entry *)((char *)de + de->rec_len);
+
+	/* dx root info is after dotdot entry */
+	de = EXT2_NEXT_DIRENT(de);
+
+	return (struct ext2_dx_root_info *)de;
+}
+
 /*
  * log base 2, rounded down
  */
-- 
2.52.0

