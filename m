From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] ext4: require key for truncate(2) of encrypted file
Date: Tue, 13 Jun 2017 23:52:10 -0700
Message-ID: <20170614065210.GA10411@infradead.org>
References: <20170613234755.111167-1-ebiggers3@gmail.com>
 <20170613234755.111167-2-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49379 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbdFNGwL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Jun 2017 02:52:11 -0400
Content-Disposition: inline
In-Reply-To: <20170613234755.111167-2-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 13, 2017 at 04:47:53PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently, filesystems allow truncate(2) on an encrypted file without
> the encryption key.  However, it's impossible to correctly handle the
> case where the size being truncated to is not a multiple of the
> filesystem block size, because that would require decrypting the final
> block, zeroing the part beyond i_size, then encrypting the block.
> 
> As other modifications to encrypted file contents are prohibited without
> the key, just prohibit truncate(2) as well, making it fail with ENOKEY.

What about hole punches?  What about fallocate which just adds zeroes
but still changes the content.  What about insert or collapse range?
