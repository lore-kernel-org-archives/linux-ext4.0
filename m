Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95DACCA47E
	for <linux-ext4@archiver.kernel.org>; Wed, 22 Jun 2022 19:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376714AbiFVTrH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 22 Jun 2022 15:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376568AbiFVTqh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2022 15:46:37 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1544D18E1F;
        Wed, 22 Jun 2022 12:46:37 -0700 (PDT)
Received: from localhost (mtl.collabora.ca [66.171.169.34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: krisman)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id A968766016F3;
        Wed, 22 Jun 2022 20:46:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1655927195;
        bh=Vv3wdcVedOUHth4VcuGI5j9l1Soza4otK3K1St9HAZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJwD5XfdZRyrlv1x0IqrFHAj50wZ302Sm04Dk7g4/XEE4WSNocAZ5F2jd/vr5Jyl6
         jIrlzHq9l7NpPrjnjV3x/GaTT4dLB21s04itOjJKUmVu3SoER9q5dhpsS1nRnfN8lo
         0uSqdvxY9kgZUyxI8jOj1weEKrfeJCSsRhmsrqbU/eZ+XoIq7fsebgJfCCt1L3vlZ4
         D/LUe5q3Bly0qOG2mHJZDeoQjiulc2Plqie1WUmCLVdytr3IMQBVLYbQAcARluGxzf
         oVqWHIp+sHc1qAlJBbPMEHMr8ikrB2f896mVu4a2ULNu8007wk5T/odqsEDOAYXltr
         MXzF3jB06Sxdg==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     viro@zeniv.linux.org.uk, tytso@mit.edu, jaegeuk@kernel.org
Cc:     ebiggers@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel@collabora.com
Subject: [PATCH 7/7] f2fs: Enable negative dentries on case-insensitive lookup
Date:   Wed, 22 Jun 2022 15:46:03 -0400
Message-Id: <20220622194603.102655-8-krisman@collabora.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622194603.102655-1-krisman@collabora.com>
References: <20220622194603.102655-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Instead of invalidating negative dentries during case-insensitive
lookups, mark them as such and let them be added to the dcache.
d_ci_revalidate is able to properly filter them out if necessary based
on the dentry casefold flag.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 fs/f2fs/namei.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index c549acb52ac4..20c3391bb209 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -566,17 +566,8 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 		goto out_iput;
 	}
 out_splice:
-#if IS_ENABLED(CONFIG_UNICODE)
-	if (!inode && IS_CASEFOLDED(dir)) {
-		/* Eventually we want to call d_add_ci(dentry, NULL)
-		 * for negative dentries in the encoding case as
-		 * well.  For now, prevent the negative dentry
-		 * from being cached.
-		 */
-		trace_f2fs_lookup_end(dir, dentry, ino, err);
-		return NULL;
-	}
-#endif
+	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
+		d_set_casefold_lookup(dentry);
 	new = d_splice_alias(inode, dentry);
 	err = PTR_ERR_OR_ZERO(new);
 	trace_f2fs_lookup_end(dir, dentry, ino, !new ? -ENOENT : err);
@@ -627,16 +618,6 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 		goto fail;
 	}
 	f2fs_delete_entry(de, page, dir, inode);
-#if IS_ENABLED(CONFIG_UNICODE)
-	/* VFS negative dentries are incompatible with Encoding and
-	 * Case-insensitiveness. Eventually we'll want avoid
-	 * invalidating the dentries here, alongside with returning the
-	 * negative dentries at f2fs_lookup(), when it is better
-	 * supported by the VFS for the CI case.
-	 */
-	if (IS_CASEFOLDED(dir))
-		d_invalidate(dentry);
-#endif
 	f2fs_unlock_op(sbi);
 
 	if (IS_DIRSYNC(dir))
-- 
2.36.1

