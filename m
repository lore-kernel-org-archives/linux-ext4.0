Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276883;
	b=IngGfkInbN7cDTz8Cpe17yHxseM7u9Bcx5ZDmRqUzIYwMt4ofL4EU9WiJWwGzWyNq4kq
	 WPIDzVAikJ5B5jZz0CkzgzQplOZcfffMvpsZpKQOtJVHItirYbwgK5Iu4DwjLroXxDMo/
	 G96dOKxLMRGdylK/FG0mDjml23ydK9/tgxoAL9+CBZvvlmeYOsvB/ifyVyxrHnp0vP4e8
	 JUVe/gSUV/iAm2gnFDu1k9bXVRYGLdNP3eqwGRho4oaRTGPdNtN/nwdeLgF7+hbbJzrEU
	 Q3uCng4LMNSDjvBW5H+MolM7EQvScDPKhrkeCLHLDbmwWmNouHwZCvL/e1wbTwTkwlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276883;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+YoUrwnGFlf9PhKVVziY+9mIf92auvk+c99LsR9rxiE=;
	b=iWLicXx2w1YDYNFZcGpJvQvXMAsIoZISMDRAf3dtA8SMyZ2cO+qa8g3T5qkU/fYvqIeI
	 Ohif8UKwmoU1VTflT85H8qj0O1tsNix2JUnM4anCat9DTyVEiBSGp/qLlyVeucIybJst9
	 jjD4bAL9dnmzgv0p4jAm5LxggrYy5hJJgHmuBZRLQAPJtfjaqyXzDMW3CV8EyxuvMhvmk
	 Nw33DoVpvhS9/1ts4XGfbxYUVYMRugQpbncJmkYhSrL0iaK7+62hR+nqXHJMg2Q6BoG0v
	 CeLAVJPzXh7pKpxAEGiuYfJ1gYJUzR3J5tnnnwj8e3RmUDqnbTHvcvS+2bVUUha+WJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ktfoeNi3;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022B9606A321
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 022B9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ktfoeNi3
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a20a37703bso16805505e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276881; x=1793881681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+YoUrwnGFlf9PhKVVziY+9mIf92auvk+c99LsR9rxiE=;
        b=ktfoeNi3OLeYCwOkr+GLYfpEfK3tSo5F3Vw1QMkBXcUv+iJJZHCV/0W29xE0jRcenW
         CRaOuTn+KXekBIXTPlefRoLDiJHK4viSnjeBbGqmkuIZMbmugxdfG0pAyBwjud7IlkwO
         zVlkV39zu2loBGDSWJ60Xah+1x+1hOoTvLVXfcu2BMA3hCtYRLSHuR6UnQuWF1oNGraU
         Bsw4DFfQkVcos/LqdYuE6VsLCf1idTbwEsBG5gPpNgFmYEIfiv/RSHp9e2/tzTeQ/nuY
         nyxyWMkF2wJgX733dYqTtQgzAYBwYQAQnd5ZFpsJR72YIlV3kBDwdSPtTh44MM6605pH
         j8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276881; x=1793881681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+YoUrwnGFlf9PhKVVziY+9mIf92auvk+c99LsR9rxiE=;
        b=w488lQAB7AgyCwAouqL9Iw74hk4GkvpZgQRIvwk2HdwXwpi0l1Z+VDdBPixRc3YNVG
         ZiyPPk5xBEqgZf/EzRcombou0uS/c3/8iahTCep7GlbIXaarO5186fOdRz0Nk6KbN1d7
         u7io5CnznNYoTD0k+1Vsn2DLI6TBzEg4c+puo6pIpPML1SZD50ZVdUmCMp4sBPWvLtVD
         3Alzs6kMxz6RbgEOYpKVhF3rhAOlY94ZsLmxfsvvzgIZjxi3/a+rqV/BR5KAAY0V+Wib
         jCqZh4ZklCdWwq8xBjYASTGsnJV6bmj26lQGG5/jKo+sVsbU8HBMNWDp0Pvoj3Lqv9Sh
         t6Rw==
X-Gm-Message-State: AFq9FYL18yGUtjUadPzMRc9hFbZuGRbkkgpQwl73zLwjN4mw0j7DgEbC
	X4Fbl8krloBf/2ZJBARGqyFsd0SXGmiEskbjPDOBOVlKPRDhIyTWsfKQLSZGWw9b
X-Gm-Gg: AYBFou1Vj1BJQepdCbi2t8afdz/V0FDa/COZni4aTY6D+Yd7WKdKAR5IRnti3S+7+nv
	KvE+Loc82bWVnehYxA+8iNsQGV0wjyjZhYBZUACrRr4SFK8QXhvueNF2ChkC2+tEGAIW5W3QWMn
	8NAE9shtilFe3NdzMEoMfwMIjBdGiJgwRxYF5wIHTAntcH8qOyDMu/acwnwHJ+5ZLiXYxFkMHCt
	szQeCW4PC4+bTOuaZGeEPaCA2/Y5GwXDlRR9fod4urS7eeiD1ZnKIa7mjDvrWbgt4WBKav4Tg+2
	RUebYgjBL3qqWw5XbMcxHeniMeAkkYA+wIhxgcx17PMXREphM9GFQrhN2K50gnyMd27Lvlbq4iy
	fo5U92kQ0qxwhPwKZq6uIxxVeTAtw4TwDariilgdD3eY9WBaqlF/AALh4Lao0plx9FnTlwgCBWx
	LcEpwoL+rSkPNadFaMymQ5lA+3jYObxRWnpgfVTE5IrqxAaW1VgTkqO5KoC4IWtpQ8Ye6/o53U0
	JqdLAWrfv61EDz75DCY6SqnN97JKbQ4Vx3f8Q3pb73EeWMHoFNnSKkjRuosfN69zErtxbexty5o
	BZH3ItUkOdXAanRPJrw/KIQvY8azezs86S/873J407LVpWNRAptTv6wOwpnx
X-Received: by 2002:a05:600c:3512:b0:4a2:c9b:9b98 with SMTP id 5b1f17b1804b1-4a9665876a3mr118093025e9.17.1793276881231;
        Thu, 29 Oct 2026 05:28:01 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm59729615e9.2.2026.10.29.05.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:00 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 04/13] libext2fs: add helper for dx_root_info lookup
Date: Thu, 29 Oct 2026 12:27:35 +0000
Message-ID: <20261029122744.230678-5-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
References: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
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

