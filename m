From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] ext3: make ext3 mount default to barrier=1
Date: Sat, 16 Jul 2011 16:46:50 -0400
Message-ID: <20110716204650.GA16882@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jeffm@suse.com, chris.mason@oracle.com, jack@suse.cz,
	reiserfs-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch turns on barriers by default for ext3.  mount -o barrier=0
will turn them off.  Based on a patch from Chris Mason in the SuSE tree.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Ted Ts'o <tytso@mit.edu>

Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c	2011-06-30 21:19:37.389544975 +0200
+++ linux-2.6/fs/ext3/super.c	2011-07-02 13:56:51.877784292 +0200
@@ -1718,6 +1718,8 @@ static int ext3_fill_super (struct super
 	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
 
+	/* enable barriers by default */
+	set_opt(sbi->s_mount_opt, BARRIER);
 	set_opt(sbi->s_mount_opt, RESERVATION);
 
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
