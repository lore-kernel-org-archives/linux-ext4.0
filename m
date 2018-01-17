From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 0/8] Ext4 encryption support for blocksize < pagesize
Date: Tue, 16 Jan 2018 18:10:20 -0800
Message-ID: <20180117021020.GA4477@zzz.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37507 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbeAQCKX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2018 21:10:23 -0500
Content-Disposition: inline
In-Reply-To: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Chandan,

On Fri, Jan 12, 2018 at 07:41:21PM +0530, Chandan Rajendra wrote:
> This patchset implements code to support encryption of Ext4 filesystem
> instances that have blocksize less than pagesize. The patchset has
> been tested on both ppc64 and x86_64 machines.
> 
> This patchset changes the prototype of the function
> fscrypt_encrypt_page(). I will make the relevant changes to the rest
> of the filesystems (e.g. f2fs) and post them in the next version of
> the patchset.
> 
> Chandan Rajendra (8):
>   ext4: use EXT4_INODE_ENCRYPT flag to detect encrypted bio
>   fs/buffer.c: make some functions non-static
>   ext4: decrypt all contiguous blocks in a page
>   ext4: decrypt all boundary blocks when doing buffered write
>   ext4: decrypt the block that needs to be partially zeroed
>   ext4: encrypt blocks whose size is less than page size
>   ext4: decrypt blocks whose size is less than page size
>   ext4: enable encryption for blocksize less than page size
> 

Thanks for working on this!  We've wanted this for a while (both so that it
works on PowerPC with a 64K PAGE_SIZE, and so that people can't screw up their
1K blocksize filesystems by enabling the 'encrypt' flag), but no one ever got
around to it.  And it's not easy!

First, just a few notes that didn't fit into my comments for the individual
patches.

Updating fscrypt_zeroout_range() seems to have been missed.  Currently it
assumes block_size == PAGE_SIZE so it will need to be updated too.

The file Documentation/filesystems/fscrypt.rst will also need to be updated, at
least to remove the following sentence: "Currently, only the case where the
filesystem block size is equal to the system's page size (usually 4096 bytes) is
supported.".

Also, on future versions of this patchset can you please also Cc
linux-fscrypt@vger.kernel.org?

Thanks,

Eric
