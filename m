From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] allow tune2fs to set/clear resize_inode
Date: Tue, 26 Feb 2008 17:34:23 -0500
Message-ID: <20080226223423.GF8190@mit.edu>
References: <472F80F5.3030608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37631 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbYBZWfE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Feb 2008 17:35:04 -0500
Content-Disposition: inline
In-Reply-To: <472F80F5.3030608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 05, 2007 at 02:45:41PM -0600, Eric Sandeen wrote:
> (this patch has been carried in Red Hat / Fedora rpms for a while, not 
> sure why it never got sent upstream... clearing this allows for mounting 
> filesystems with a resize_inode on older systems)

I just checked in the following into the e2fsprogs maint branch.

       	       	      		     - Ted

commit 037914e28f69110020195fe9f9ea56e5274ff2c0
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Feb 26 17:31:06 2008 -0500

    tune2fs: Add support to clear the resize_inode feature
    
    This requires an fsck aftwards.  We don't allow setting the
    resize_inode feature because extensive work to tune2fs or e2fsck to
    safely relocate blocks is necessary in order to reserve the blocks
    needed by the resize inode.
    
    Addresses-Red-Hat-Bugzilla: #167816
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 435556f..40cdb96 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -429,12 +429,19 @@ option.
 .TP
 .B sparse_super
 Limit the number of backup superblocks to save space on large filesystems.
+.TP
+.B resize_inode
+Reserve space so the block group descriptor table may grow in the
+future.
+.B Tune2fs 
+only supports clearing this filesystem feature.
 .RE
 .IP
 After setting or clearing 
-.B sparse_super
-and 
-.B filetype 
+.BR sparse_super ,
+.BR filetype ,
+or
+.B resize_inode
 filesystem features,
 .BR e2fsck (8)
 must be run on the filesystem to return the filesystem to a consistent state.
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ee7af4b..4529e24 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -116,6 +116,7 @@ static __u32 ok_features[3] = {
 
 static __u32 clear_ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
+		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,	/* Compat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE,		/* Incompat */
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
@@ -389,7 +390,9 @@ static void update_feature_set(ext2_filsys fs, char *features)
 	if (FEATURE_CHANGED(E2P_FEATURE_RO_INCOMPAT,
 			    EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER) ||
 	    FEATURE_CHANGED(E2P_FEATURE_INCOMPAT,
-			    EXT2_FEATURE_INCOMPAT_FILETYPE)) {
+			    EXT2_FEATURE_INCOMPAT_FILETYPE) ||
+	    FEATURE_CHANGED(E2P_FEATURE_COMPAT,
+			    EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
 		sb->s_state &= ~EXT2_VALID_FS;
 		printf("\n%s\n", _(please_fsck));
 	}
