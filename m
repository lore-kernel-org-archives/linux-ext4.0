From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: optimize ext4 direct I/O locking for reading
Date: Fri, 30 Sep 2016 01:22:33 -0400
Message-ID: <20160930052233.puwov5avj4kfedin@thunk.org>
References: <20160921052744.5223-1-tytso@mit.edu>
 <20160921132609.GA30232@infradead.org>
 <20160921143748.xswkovbjrtcgs3bq@thunk.org>
 <20160922123143.GO2834@quack2.suse.cz>
 <20160922133031.zjiyudqwthqp742g@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160922133031.zjiyudqwthqp742g@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've been looking at your patch and testing it, and it looks like
works fine as-is.

The other thing I like about this patch is it allows us to drop
ext4_inode_{block,resume}_unlocked_dio() and EXT4_STATE_DIOREAD_LOCK.

Thanks!!

					- Ted
