From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] ext4: evict inline data when writing to memory map
Date: Tue, 14 Mar 2017 16:32:39 -0700
Message-ID: <20170314233239.GA127087@gmail.com>
References: <20170313004708.29838-1-ebiggers3@gmail.com>
 <20170313233313.GA23580@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Nick Alcock <nick.alcock@oracle.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34796 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750824AbdCNXcn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Mar 2017 19:32:43 -0400
Content-Disposition: inline
In-Reply-To: <20170313233313.GA23580@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 13, 2017 at 04:33:13PM -0700, Christoph Hellwig wrote:
> >     mkfs.ext4 -O inline_data /dev/vdb
> >     mount /dev/vdb /mnt
> >     xfs_io -f /mnt/file \
> > 	-c 'pwrite 0 1' \
> > 	-c 'mmap -w 0 1m' \
> > 	-c 'mwrite 0 1' \
> > 	-c 'fsync'
> 
> Please add this test case to xfstests.

I'm working on this, and I discovered there's still a bug.  After the data is
written with mwrite, if the filesystem is then mount-cycled, the contents of the
file are the old contents rather than the new contents.

I believe this is caused by a bug in ext4_convert_inline_data().  Specifically,
the new block containing the evicted data is journalled using a buffer_head
associated with the block device.  This is wrong because it can overwrite data
that is later written through non-journalled writeback.

I'll look into this more when I have time, but in any case it appears this fix
isn't complete.

Eric
