From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: optimize ext4 direct I/O locking for reading
Date: Mon, 3 Oct 2016 09:41:03 +0200
Message-ID: <20161003074103.GE6457@quack2.suse.cz>
References: <20160921052744.5223-1-tytso@mit.edu>
 <20160921132609.GA30232@infradead.org>
 <20160921143748.xswkovbjrtcgs3bq@thunk.org>
 <20160922123143.GO2834@quack2.suse.cz>
 <20160922133031.zjiyudqwthqp742g@thunk.org>
 <20160930052233.puwov5avj4kfedin@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160930052233.puwov5avj4kfedin@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 30-09-16 01:22:33, Ted Tso wrote:
> I've been looking at your patch and testing it, and it looks like
> works fine as-is.

Glad to hear that!

> The other thing I like about this patch is it allows us to drop
> ext4_inode_{block,resume}_unlocked_dio() and EXT4_STATE_DIOREAD_LOCK.

Well, not completely - we still need to deal with unlocked writes that
happen in ext4_direct_IO_write() when overwrite == 1. But that should be
doable in a similar way. We could just demote inode_lock to a shared mode
instead of dropping it in ext4_direct_IO_write() and then we could drop the
bits you mention above. I can look into that when I'll be looking into
converting ext4 into the new iomap infrastructure but that's definitely
material for the next merge window.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
