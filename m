From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] vfs: introduce try_to_writeback_inodes_sb(_nr)
Date: Thu, 26 Apr 2012 13:11:56 +1000
Message-ID: <20120426031156.GY9541@dastard>
References: <4F98B9A7.8060209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	miaox@cn.fujitsu.com, Kamal Mostafa <kamal@canonical.com>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Miao Xie <miaoxie1984@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F98B9A7.8060209@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 26, 2012 at 10:57:43AM +0800, Miao Xie wrote:
> writeback_inodes_sb(_nr) grabs s_umount lock when it want to start writeback,
> it may bring us deadlock problem when doing umount. So we introduce new
> functions -- try_to_writeback_inodes_sb(_nr) -- which use down_read_trylock()
> instead of down_read() to avoid that deadlock problem.
> 
> This idea came from Christoph Hellwig.
> Some code is from the patch of Kamal Mostafa.

This just re-implements writeback_inodes_[nr]_sb_if_idle() with a
trylock instead of a blocking lock.

Just replace the blocking lock in writeback_inodes_[nr]_sb_if_idle()
with a trylock and use that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
