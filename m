Return-Path: <SRS0=7ymp=QW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69AAC10F02
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 22:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90131222DD
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Feb 2019 22:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DlWuhRsQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404465AbfBOWky (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Feb 2019 17:40:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56686 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404455AbfBOWku (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2019 17:40:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1FMcxWe146163;
        Fri, 15 Feb 2019 22:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=rFBuPAUp3qyHrOOVnWy4HHWdGelJ0ySma1MEojBeK4Y=;
 b=DlWuhRsQN5kmw/90osRqZIUez1X7TeWVRLI7Kmo3JJLaKkBIv/m6V3c1AfzbcvH/Fbv+
 Pat6xx5UMyo9oCVRyHCxwxWw36YcaWzwhLQybvwJNUtbYmWmiDXFFunEW33PVOvPUoXA
 QXGfkWN/0Z9F0oJjJtCSx3wAragBKmNc9NDTbsAQzGrHgvDE+dmf6X1MnccK3sZSLsqd
 y414B1CWKpfaaRFfeNsWyrhr3YsdHnUhXpCyIumo1j6uZgNE0s/q0K3/QUb07LBRYli/
 hXX4XlAFW5Ylxq3u/f3kV4GyW9T6f6uyQXsPYlFhYDrSG1WTLIp47m4Jj7sPgUTCu9mn 5A== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qhrem0cbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Feb 2019 22:39:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1FMdTnq026520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Feb 2019 22:39:30 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1FMdR7l015082;
        Fri, 15 Feb 2019 22:39:28 GMT
Received: from localhost (/10.145.178.102)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Feb 2019 14:39:27 -0800
Date:   Fri, 15 Feb 2019 14:39:25 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        viro@zeniv.linux.org.uk, jack@suse.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com,
        hughd@google.com, hch@infradead.org
Cc:     richard@nod.at, dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-mm@kvack.org,
        amir73il@gmail.com
Subject: [PATCH v2] vfs: don't decrement i_nlink in d_tmpfile
Message-ID: <20190215223925.GO32253@magnolia>
References: <20190214234908.GA6474@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214234908.GA6474@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=831 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902150147
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

d_tmpfile was introduced to instantiate an inode in the dentry cache as
a temporary file.  This helper decrements the inode's nlink count and
dirties the inode, presumably so that filesystems could call new_inode
to create a new inode with nlink == 1 and then call d_tmpfile which will
decrement nlink.

However, this doesn't play well with XFS, which needs to allocate,
initialize, and insert a tempfile inode on its unlinked list in a single
transaction.  In order to maintain referential integrity of the XFS
metadata, we cannot have an inode on the unlinked list with nlink >= 1.

XFS and btrfs hack around d_tmpfile's behavior by creating the inode
with nlink == 0 and then incrementing it just prior to calling
d_tmpfile, anticipating that it will be reset to 0.

Everywhere else, it appears that nlink updates and persistence is
the responsibility of individual filesystems.  Therefore, move the nlink
decrement out of d_tmpfile into the callers, and require that callers
only pass in inodes with nlink already set to 0.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: convert BUG_ON to WARN_ON per review comment
---
 fs/btrfs/inode.c  |    8 --------
 fs/dcache.c       |   10 ++++++----
 fs/ext2/namei.c   |    2 +-
 fs/ext4/namei.c   |    1 +
 fs/f2fs/namei.c   |    1 +
 fs/minix/namei.c  |    2 +-
 fs/ubifs/dir.c    |    1 +
 fs/udf/namei.c    |    2 +-
 fs/xfs/xfs_iops.c |   13 ++-----------
 mm/shmem.c        |    1 +
 10 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5c349667c761..bd189fc50f83 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10382,14 +10382,6 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (ret)
 		goto out;
 
-	/*
-	 * We set number of links to 0 in btrfs_new_inode(), and here we set
-	 * it to 1 because d_tmpfile() will issue a warning if the count is 0,
-	 * through:
-	 *
-	 *    d_tmpfile() -> inode_dec_link_count() -> drop_nlink()
-	 */
-	set_nlink(inode, 1);
 	d_tmpfile(dentry, inode);
 	unlock_new_inode(inode);
 	mark_inode_dirty(inode);
diff --git a/fs/dcache.c b/fs/dcache.c
index aac41adf4743..bb349d423055 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3042,12 +3042,14 @@ void d_genocide(struct dentry *parent)
 
 EXPORT_SYMBOL(d_genocide);
 
+/*
+ * Instantiate an inode in the dentry cache as a temporary file.  Callers must
+ * ensure that @inode has a zero link count.
+ */
 void d_tmpfile(struct dentry *dentry, struct inode *inode)
 {
-	inode_dec_link_count(inode);
-	BUG_ON(dentry->d_name.name != dentry->d_iname ||
-		!hlist_unhashed(&dentry->d_u.d_alias) ||
-		!d_unlinked(dentry));
+	WARN_ON(dentry->d_name.name != dentry->d_iname ||
+		!d_unlinked(dentry) || inode->i_nlink != 0);
 	spin_lock(&dentry->d_parent->d_lock);
 	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 	dentry->d_name.len = sprintf(dentry->d_iname, "#%llu",
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 0c26dcc5d850..8542e9ce9677 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -117,7 +117,7 @@ static int ext2_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 		return PTR_ERR(inode);
 
 	ext2_set_file_ops(inode);
-	mark_inode_dirty(inode);
+	inode_dec_link_count(inode);
 	d_tmpfile(dentry, inode);
 	unlock_new_inode(inode);
 	return 0;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2b928eb07fa2..7502432f9816 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2517,6 +2517,7 @@ static int ext4_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
 		ext4_set_aops(inode);
+		inode_dec_link_count(inode);
 		d_tmpfile(dentry, inode);
 		err = ext4_orphan_add(handle, inode);
 		if (err)
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 62d9829f3a6a..31a556af5f3a 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -780,6 +780,7 @@ static int __f2fs_tmpfile(struct inode *dir, struct dentry *dentry,
 		f2fs_i_links_write(inode, false);
 		*whiteout = inode;
 	} else {
+		inode_dec_link_count(inode);
 		d_tmpfile(dentry, inode);
 	}
 	/* link_count was changed by d_tmpfile as well. */
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 1a6084d2b02e..3249f86c476a 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -57,7 +57,7 @@ static int minix_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct inode *inode = minix_new_inode(dir, mode, &error);
 	if (inode) {
 		minix_set_inode(inode, 0);
-		mark_inode_dirty(inode);
+		inode_dec_link_count(inode);
 		d_tmpfile(dentry, inode);
 	}
 	return error;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 5767b373a8ff..7187e4fd7561 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -419,6 +419,7 @@ static int do_tmpfile(struct inode *dir, struct dentry *dentry,
 		drop_nlink(inode);
 		*whiteout = inode;
 	} else {
+		inode_dec_link_count(inode);
 		d_tmpfile(dentry, inode);
 	}
 	ubifs_assert(c, ui->dirty);
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 58cc2414992b..38bd021f9673 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -652,7 +652,7 @@ static int udf_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 		inode->i_data.a_ops = &udf_aops;
 	inode->i_op = &udf_file_inode_operations;
 	inode->i_fop = &udf_file_operations;
-	mark_inode_dirty(inode);
+	inode_dec_link_count(inode);
 	d_tmpfile(dentry, inode);
 	unlock_new_inode(inode);
 	return 0;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1efef69a7f1c..f48ffd7a8d3e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -191,18 +191,9 @@ xfs_generic_create(
 
 	xfs_setup_iops(ip);
 
-	if (tmpfile) {
-		/*
-		 * The VFS requires that any inode fed to d_tmpfile must have
-		 * nlink == 1 so that it can decrement the nlink in d_tmpfile.
-		 * However, we created the temp file with nlink == 0 because
-		 * we're not allowed to put an inode with nlink > 0 on the
-		 * unlinked list.  Therefore we have to set nlink to 1 so that
-		 * d_tmpfile can immediately set it back to zero.
-		 */
-		set_nlink(inode, 1);
+	if (tmpfile)
 		d_tmpfile(dentry, inode);
-	} else
+	else
 		d_instantiate(dentry, inode);
 
 	xfs_finish_inode_setup(ip);
diff --git a/mm/shmem.c b/mm/shmem.c
index 6ece1e2fe76e..4a7810093561 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2818,6 +2818,7 @@ shmem_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 		error = simple_acl_create(dir, inode);
 		if (error)
 			goto out_iput;
+		inode_dec_link_count(inode);
 		d_tmpfile(dentry, inode);
 	}
 	return error;
