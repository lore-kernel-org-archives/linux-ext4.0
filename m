From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 updates for 4.15
Date: Mon, 13 Nov 2017 11:25:34 -0500
Message-ID: <20171113162534.5xta72w2boeaxk3s@thunk.org>
References: <20171113031502.f6mctmlmgk5psh77@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171113031502.f6mctmlmgk5psh77@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I forgot to mention, there's a merge conflict when pulling the ext4
and fscrypt trees.  The fixup is relatively straightforward:

commit daf886f04e60eda3bbc957e79d81d72965afd947
Merge: a0b3bc855374 232530680290
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Nov 12 22:03:15 2017 -0500

    Merge tag 'ext4_for_linus' into test
    
    Add support for online resizing of file systems with bigalloc.  Fix a
    two data corruption bugs involving DAX, as well as a corruption bug
    after a crash during a racing fallocate and delayed allocation.
    Finally, a number of cleanups and optimizations.

diff --cc fs/ext4/inode.c
index 617c7feced24,9f836e2ec18c..737c43d724fb
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@@ -4587,15 -4640,10 +4640,13 @@@ void ext4_set_inode_flags(struct inode 
  		new_fl |= S_NOATIME;
  	if (flags & EXT4_DIRSYNC_FL)
  		new_fl |= S_DIRSYNC;
- 	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode) &&
- 	    !ext4_should_journal_data(inode) && !ext4_has_inline_data(inode) &&
- 	    !(flags & EXT4_ENCRYPT_FL))
+ 	if (ext4_should_use_dax(inode))
  		new_fl |= S_DAX;
 +	if (flags & EXT4_ENCRYPT_FL)
 +		new_fl |= S_ENCRYPTED;
  	inode_set_flags(inode, new_fl,
 -			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
 +			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX|
 +			S_ENCRYPTED);
  }
  
  static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
