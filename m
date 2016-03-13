From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Buffer Head Leak In mmp
Date: Sun, 13 Mar 2016 17:57:30 -0400
Message-ID: <20160313215730.GI29218@thunk.org>
References: <CAJ-febOhan58G=Aw+-CD6OD2iKuFY3dxkzBfVMCwBd6vXs1rFg@mail.gmail.com>
 <B747AA6A-644E-475E-BE24-07C400041058@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "vikram.jadhav07" <vikramjadhavpucsd2007@gmail.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38986 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbcCMV5e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Mar 2016 17:57:34 -0400
Content-Disposition: inline
In-Reply-To: <B747AA6A-644E-475E-BE24-07C400041058@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've made the changes Andreas suggested, and ended up with this.  Andreas, PTAL?

     	      	      	      		     	   - Ted

commit 0304688676bdfc8159e165313d71da19c118ba27
Author: vikram.jadhav07 <vikramjadhavpucsd2007@gmail.com>
Date:   Sun Mar 13 17:56:52 2016 -0400

    ext4: clean up error handling in the MMP support
    
    There is memory leak as both caller function kmmpd() and callee
    read_mmp_block() not releasing bh_check  (i.e buffer_head).
    Given patch fixes this problem.
    
    [ Additional changes suggested by Andreas Dilger -- TYT ]
    
    Signed-off-by: Jadhav Vikram <vikramjadhavpucsd2007@gmail.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 0a512aa..2444527 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -91,21 +91,22 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 	submit_bh(READ_SYNC | REQ_META | REQ_PRIO, *bh);
 	wait_on_buffer(*bh);
 	if (!buffer_uptodate(*bh)) {
-		brelse(*bh);
-		*bh = NULL;
 		ret = -EIO;
 		goto warn_exit;
 	}
-
 	mmp = (struct mmp_struct *)((*bh)->b_data);
-	if (le32_to_cpu(mmp->mmp_magic) != EXT4_MMP_MAGIC)
+	if (le32_to_cpu(mmp->mmp_magic) != EXT4_MMP_MAGIC) {
 		ret = -EFSCORRUPTED;
-	else if (!ext4_mmp_csum_verify(sb, mmp))
+		goto warn_exit;
+	}
+	if (!ext4_mmp_csum_verify(sb, mmp)) {
 		ret = -EFSBADCRC;
-	else
-		return 0;
-
+		goto warn_exit;
+	}
+	return 0;
 warn_exit:
+	brelse(*bh);
+	*bh = NULL;
 	ext4_warning(sb, "Error %d while reading MMP block %llu",
 		     ret, mmp_block);
 	return ret;
@@ -181,15 +182,13 @@ static int kmmpd(void *data)
 		    EXT4_FEATURE_INCOMPAT_MMP)) {
 			ext4_warning(sb, "kmmpd being stopped since MMP feature"
 				     " has been disabled.");
-			EXT4_SB(sb)->s_mmp_tsk = NULL;
-			goto failed;
+			goto exit_thread;
 		}
 
 		if (sb->s_flags & MS_RDONLY) {
 			ext4_warning(sb, "kmmpd being stopped since filesystem "
 				     "has been remounted as readonly.");
-			EXT4_SB(sb)->s_mmp_tsk = NULL;
-			goto failed;
+			goto exit_thread;
 		}
 
 		diff = jiffies - last_update_time;
@@ -211,9 +210,7 @@ static int kmmpd(void *data)
 			if (retval) {
 				ext4_error(sb, "error reading MMP data: %d",
 					   retval);
-
-				EXT4_SB(sb)->s_mmp_tsk = NULL;
-				goto failed;
+				goto exit_thread;
 			}
 
 			mmp_check = (struct mmp_struct *)(bh_check->b_data);
@@ -225,7 +222,9 @@ static int kmmpd(void *data)
 					     "The filesystem seems to have been"
 					     " multiply mounted.");
 				ext4_error(sb, "abort");
-				goto failed;
+				put_bh(bh_check);
+				retval = -EBUSY;
+				goto exit_thread;
 			}
 			put_bh(bh_check);
 		}
@@ -248,7 +247,8 @@ static int kmmpd(void *data)
 
 	retval = write_mmp_block(sb, bh);
 
-failed:
+exit_thread:
+	EXT4_SB(sb)->s_mmp_tsk = NULL;
 	kfree(data);
 	brelse(bh);
 	return retval;
