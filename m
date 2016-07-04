From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't call ext4_should_journal_data() on the
 journal inode
Date: Mon, 4 Jul 2016 11:02:45 -0400
Message-ID: <20160704150245.GD29557@thunk.org>
References: <1467495762-25353-1-git-send-email-vegard.nossum@oracle.com>
 <20160703051505.GA17739@thunk.org>
 <5778B921.9060603@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5778B921.9060603@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks, I've reworded the commit description as follows:

  ext4: don't call ext4_should_journal_data() on the journal inode
  
  If ext4_fill_super() fails early, it's possible for
  ext4_evict_inode() to call ext4_should_journal_data() before
  superblock options and flags are fully set up.  In that case, the
  iput() on the journal inode can end up causing a BUG().
  
  Work around this problem by reordering the tests so we only call
  ext4_should_journal_data() after we know it's not the journal inode.
  
  Fixes: 2d859db3e4 ("ext4: fix data corruption in inodes with journalled data")
  Fixes: 2b405bfa84 ("ext4: fix data=journal fast mount/umount hang")
  Cc: Jan Kara <jack@suse.cz>
  Cc: stable@vger.kernel.org
  Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
  Signed-off-by: Theodore Ts'o <tytso@mit.edu>
  Reviewed-by: Jan Kara <jack@suse.cz>


