From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/11] quota: Stop setting IMMUTABLE and NOATIME flags
 directly
Date: Wed, 19 Apr 2017 12:34:03 +0200
Message-ID: <20170419103403.GA16052@quack2.suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 12-04-17 09:26:00, Jan Kara wrote:
> Hello,
> 
> this series removes setting of IMMUTABLE and NOATIME flags from generic quota
> code and moves it to filesystem's quota_on / quota_off handlers. Since this
> was the only place where generic code was modifying inode flags that need to
> be persistent on disk, we can remove functions syncing inode->i_flags to
> on-disk flags after this. This was motivated by recent statx() work that
> wants consistent view of inode flags without holding i_mutex.
> 
> Patches passed basic testing for ext2, ext4, reiserfs, compile-tested for jfs
> only. Please review, patches are mostly trivial but I could have missed
> something. If people are fine with the changes, I plan to merge them through
> my tree.

Since there were no objections to the patches I have pulled them into my
tree and will push them to Linus during the merge window.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
