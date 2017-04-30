From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: evict inline data when writing to memory map
Date: Sun, 30 Apr 2017 00:13:57 -0400
Message-ID: <20170430041357.5nrbpocxzbx5tf7p@thunk.org>
References: <20170313004708.29838-1-ebiggers3@gmail.com>
 <20170313233313.GA23580@infradead.org>
 <20170314233239.GA127087@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Nick Alcock <nick.alcock@oracle.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170314233239.GA127087@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 14, 2017 at 04:32:39PM -0700, Eric Biggers wrote:
> I'm working on this, and I discovered there's still a bug.  After the data is
> written with mwrite, if the filesystem is then mount-cycled, the contents of the
> file are the old contents rather than the new contents.
> 
> I believe this is caused by a bug in ext4_convert_inline_data().  Specifically,
> the new block containing the evicted data is journalled using a buffer_head
> associated with the block device.  This is wrong because it can overwrite data
> that is later written through non-journalled writeback.

I'll apply this patch for now, since it fixes a userspace-triggerable
BUG, but you're right.  ext4_convert_inline_data() is busted; it
should not be using data journalling, but rather it should check to
make sure the page is already in memory (and creating it if
necessary), and just write it out to memory.

This is a separate bug, and we should fix it, but the first patch is
correct and should go in.

					- Ted
