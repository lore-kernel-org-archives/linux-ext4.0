Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E4AC10F0D
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 15:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B7AF2084C
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 15:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554220146;
	bh=ZS9y98i16xygu0zu+wJ3ifdcMp238qH7OAyxgKi2mvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=o/wrmIIfWy4dwM3083JQAhKGWe6+Dnpw4hOUoZnBMI3Ut3uszdty3irvMxONHgFP4
	 J+35HkiSvxx3SOM60KOH3p69ebWCNfqZnt3c7I+FMEKfXG4KrsgD8PboLVn/59n4M9
	 6cQtDMMK09dWL3+omxLzyjw1QHlXfgAR8LuisV2s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbfDBPsi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 11:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730664AbfDBPsf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 2 Apr 2019 11:48:35 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E9602146E;
        Tue,  2 Apr 2019 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554220114;
        bh=ZS9y98i16xygu0zu+wJ3ifdcMp238qH7OAyxgKi2mvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZBFMH0vSgg9muf0p7CxAXRE4+kBgTnryrfHGeqtHuyMQh6MkW5Rnk64wUKv4Gka8
         dX1SPoqS5MSqc7ovL2tIRqD7DFoeDf4f6+uud/PTvi8vNAjPHp6rvGT3sSEWBKPYA2
         DTbsulOBb1PAKa43ipPUdYtoGqDeXl0x68gopxPo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: [PATCH v4 07/17] fs/dcache.c: add shrink_dcache_inode()
Date:   Tue,  2 Apr 2019 08:45:50 -0700
Message-Id: <20190402154600.32432-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190402154600.32432-1-ebiggers@kernel.org>
References: <20190402154600.32432-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When a filesystem encryption key is removed, we need all files which had
been "unlocked" (had ->i_crypt_info set up) with it to appear "locked"
again.  This is most easily done by evicting the inodes.  This can
currently be done using 'echo 2 > /proc/sys/vm/drop_caches'; however,
that is overkill and not usable by non-root users.

To evict just the needed inodes we also need the ability to evict those
inodes' dentries, since an inode is pinned by its dentries.  Therefore,
add a function shrink_dcache_inode() which iterates through an inode's
dentries and evicts any unused ones as well as any unused descendants
(since there may be negative dentries pinning the inode's dentries).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/dcache.c            | 32 ++++++++++++++++++++++++++++++++
 include/linux/dcache.h |  1 +
 2 files changed, 33 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index aac41adf47433..1d940484c2d17 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1507,6 +1507,38 @@ void shrink_dcache_parent(struct dentry *parent)
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
+/**
+ * shrink_dcache_inode - prune dcache for inode
+ * @inode: inode to prune
+ *
+ * Evict all unused aliases of the specified inode from the dcache.  This is
+ * intended to be used when trying to evict a specific inode, since inodes are
+ * pinned by their dentries.  We also have to descend to ->d_subdirs for each
+ * alias, since aliases may be pinned by negative child dentries.
+ */
+void shrink_dcache_inode(struct inode *inode)
+{
+	for (;;) {
+		struct select_data data;
+		struct dentry *dentry;
+
+		INIT_LIST_HEAD(&data.dispose);
+		data.start = NULL;
+		data.found = 0;
+
+		spin_lock(&inode->i_lock);
+		hlist_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias)
+			d_walk(dentry, &data, select_collect);
+		spin_unlock(&inode->i_lock);
+
+		if (!data.found)
+			break;
+
+		shrink_dentry_list(&data.dispose);
+		cond_resched();
+	}
+}
+
 static enum d_walk_ret umount_check(void *_data, struct dentry *dentry)
 {
 	/* it has busy descendents; complain about those instead */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 60996e64c5798..1b5f295dc1156 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -246,6 +246,7 @@ extern struct dentry * d_obtain_alias(struct inode *);
 extern struct dentry * d_obtain_root(struct inode *);
 extern void shrink_dcache_sb(struct super_block *);
 extern void shrink_dcache_parent(struct dentry *);
+extern void shrink_dcache_inode(struct inode *);
 extern void shrink_dcache_for_umount(struct super_block *);
 extern void d_invalidate(struct dentry *);
 
-- 
2.21.0

