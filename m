From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 2/8] fs/buffer.c: make some functions non-static
Date: Tue, 16 Jan 2018 18:14:10 -0800
Message-ID: <20180117021410.GB4477@zzz.localdomain>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
 <20180112141129.27507-3-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pl0-f48.google.com ([209.85.160.48]:41878 "EHLO
        mail-pl0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeAQCON (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2018 21:14:13 -0500
Content-Disposition: inline
In-Reply-To: <20180112141129.27507-3-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Chandan,

On Fri, Jan 12, 2018 at 07:41:23PM +0530, Chandan Rajendra wrote:
> The functions end_buffer_async_read(), block_size_bits() and
> create_page_buffers() will be needed by ext4 to implement encryption for
> blocksize < pagesize scenario.
> 

These all need to have EXPORT_SYMBOL() added, otherwise they won't be usable
when ext4 is built as a module.

block_size_bits() isn't actually needed as you can just use ->i_blkbits.

For the remaining two functions being exposed you need to explain why they are
*really* needed -- to create a version of block_read_full_page() that decrypts
the data after reading it.  Which is very ugly, and involves copy-and-pasting
quite a bit of code.

It's true that we've already effectively copy+pasted mpage_readpages() into ext4
(fs/ext4/readpage.c) for essentially the same reason, so your approach isn't
really any worse.  But did you consider instead cleaning things up by making the
generic code support encryption?  We now have the IS_ENCRYPTED() macro which
allows generic code to efficiently tell whether the file is encrypted or not.  I
think the only problem is that the code in fs/crypto/ can be built as a module,
so currently it can't be called directly by core code.  So we could either
change that and start requiring that fscrypt be built-in, or we could have the
filesystem pass an (optional) decryption callback to the generic code.

Or at the very least we could put the "encryption-aware" versions of
mpages_readpages() and block_read_full_page() into fs/crypto/ rather than in
fs/ext4/, so that they could be used by other filesystems in the future
(although currently f2fs and ubifs won't need them).

Eric
