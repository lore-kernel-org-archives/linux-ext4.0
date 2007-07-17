From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [EXT4 set 7][PATCH 1/1]Remove 32000 subdirs limit.
Date: Tue, 17 Jul 2007 15:19:49 +0530
Message-ID: <1184665789.7063.8.camel@garfield.linsyssoft.com>
References: <1183275498.4010.135.camel@localhost.localdomain>
	 <20070710224011.e60b9864.akpm@linux-foundation.org>
	 <1184322648.4315.2.camel@garfield.linsyssoft.com>
	 <20070713095343.d2e76775.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:33832 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbXGQKGs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jul 2007 06:06:48 -0400
In-Reply-To: <20070713095343.d2e76775.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-07-13 at 09:53 -0700, Andrew Morton wrote:
> On Fri, 13 Jul 2007 16:00:48 +0530 Kalpak Shah <kalpak@clusterfs.com> wrote:
> 
> > > >  
> > > > -	if (inode->i_nlink >= EXT4_LINK_MAX)
> > > > +	if (EXT4_DIR_LINK_MAX(inode))
> > > >  		return -EMLINK;
> > > 
> > > argh.  WHY_IS_EXT4_FULL_OF_UPPER_CASE_MACROS_WHICH_COULD_BE_IMPLEMENTED
> > > as_lower_case_inlines?  Sigh.  It's all the old-timers, I guess.
> > > 
> > > EXT4_DIR_LINK_MAX() is buggy: it evaluates its arg twice.
> > 
> > #define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)
> > 
> > This just checks if directory has hash indexing in which case we need not worry about EXT4_LINK_MAX subdir limit. If directory is not hash indexed then we will need to enforce a max subdir limit. 
> > 
> > Sorry, I didn't understand what is the problem with this macro?
> 
> Macros should never evaluate their argument more than once, because if they
> do they will misbehave when someone passes them an
> expression-with-side-effects:
> 
> 	struct inode *p = q;
> 
> 	EXT4_DIR_LINK_MAX(p++);
> 
> one expects `p' to have the value q+1 here.  But it might be q+2.
> 
> and
> 
> 	EXT4_DIR_LINK_MAX(some_function());
> 
> might cause some_function() to be called twice.
> 
> 
> This is one of the many problems which gets fixed when we write code in C
> rather than in cpp.

Thanks. Here is the fix converting these macros into inlined functions.


----
The EXT4_DIR_LINK_MAX(dir) and EXT4_DIR_LINK_EMPTY(dir) macros were
evaluating their argument twice so convert them into inlined functions.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: linux-2.6.22/fs/ext4/namei.c
===================================================================
--- linux-2.6.22.orig/fs/ext4/namei.c
+++ linux-2.6.22/fs/ext4/namei.c
@@ -1742,7 +1742,7 @@ static int ext4_mkdir(struct inode * dir
        struct ext4_dir_entry_2 * de;
        int err, retries = 0;

-       if (EXT4_DIR_LINK_MAX(dir))
+       if (ext4_dir_link_max(dir))
                return -EMLINK;

 retry:
@@ -2062,7 +2062,7 @@ static int ext4_rmdir (struct inode * di
        retval = ext4_delete_entry(handle, dir, de, bh);
        if (retval)
                goto end_rmdir;
-       if (!EXT4_DIR_LINK_EMPTY(inode))
+       if (!ext4_dir_link_empty(inode))
                ext4_warning (inode->i_sb, "ext4_rmdir",
                              "empty directory has too many links (%d)",
                              inode->i_nlink);
@@ -2201,7 +2201,7 @@ static int ext4_link (struct dentry * ol
        struct inode *inode = old_dentry->d_inode;
        int err, retries = 0;

-       if (EXT4_DIR_LINK_MAX(inode))
+       if (ext4_dir_link_max(inode))
                return -EMLINK;

        /*
Index: linux-2.6.22/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.22.orig/include/linux/ext4_fs.h
+++ linux-2.6.22/include/linux/ext4_fs.h
@@ -797,12 +797,18 @@ struct ext4_dir_entry_2 {
   #define is_dx(dir) (EXT4_HAS_COMPAT_FEATURE(dir->i_sb, \
                                              EXT4_FEATURE_COMPAT_DIR_INDEX) && \
                      (EXT4_I(dir)->i_flags & EXT4_INDEX_FL))
-#define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)
-#define EXT4_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2 || (dir)->i_nlink == 1)
+static inline int ext4_dir_link_max(struct inode *dir)
+{
+       return (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX);
+}
+static inline int ext4_dir_link_empty(struct inode *dir)
+{
+       return ((dir)->i_nlink == 2 || (dir)->i_nlink == 1);
+}
 #else
   #define is_dx(dir) 0
-#define EXT4_DIR_LINK_MAX(dir) ((dir)->i_nlink >= EXT4_LINK_MAX)
-#define EXT4_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2)
+#define ext4_dir_link_max(dir) ((dir)->i_nlink >= EXT4_LINK_MAX)
+#define ext4_dir_link_empty(dir) ((dir)->i_nlink == 2)
 #endif

 /* Legal values for the dx_root hash_version field: */
