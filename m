From: Theodore Tso <tytso@mit.edu>
Subject: Re: buggy_init_scritps and e2fsprogs 1.41.9
Date: Thu, 10 Sep 2009 17:32:26 -0400
Message-ID: <20090910213226.GB6705@mit.edu>
References: <200909101455.38400.coolo@suse.de> <20090910202927.GK23700@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Scott James Remnant <scott@canonical.com>
To: Stephan Kulow <coolo@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38159 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbZIJVc3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 17:32:29 -0400
Content-Disposition: inline
In-Reply-To: <20090910202927.GK23700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops, I sent the wrong version of the patch; it had a stupid typo in
it... (s/s_flag/s_flags).

							- Ted

commit 54c90e88b955b94de94d7d730ee8d53daa64453f
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Sep 10 17:31:04 2009 -0400

    ext4: Don't update superblock write time when filesystem is read-only
    
    This avoids updating the superblock write time when we are mounting
    the root file system read/only but we need to replay the journal; at
    that point, for people who are east of GMT and who make their clock
    tick in localtime for Windows bug-for-bug compatibility, and this will
    cause e2fsck to complain and force a full file system check.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f644a5c..9f87707 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3244,7 +3244,18 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
-	es->s_wtime = cpu_to_le32(get_seconds());
+	/*
+	 * If the file system is mounted read-only, don't update the
+	 * superblock write time.  This avoids updating the superblock
+	 * write time when we are mounting the root file system
+	 * read/only but we need to replay the journal; at that point,
+	 * for people who are east of GMT and who make their clock
+	 * tick in localtime for Windows bug-for-bug compatibility,
+	 * the clock is set in the future, and this will cause e2fsck
+	 * to complain and force a full file system check.
+	 */
+	if (!(sb->s_flags & MS_RDONLY))
+		es->s_wtime = cpu_to_le32(get_seconds());
 	es->s_kbytes_written =
 		cpu_to_le64(EXT4_SB(sb)->s_kbytes_written + 
 			    ((part_stat_read(sb->s_bdev->bd_part, sectors[1]) -
