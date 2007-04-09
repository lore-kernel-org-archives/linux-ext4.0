From: Theodore Tso <tytso@mit.edu>
Subject: Re: confused on different inode size
Date: Mon, 9 Apr 2007 11:26:30 -0400
Message-ID: <20070409152630.GA30658@thunk.org>
References: <1176014343.20429.6.camel@colyT43.site> <20070408175218.GB29180@thunk.org> <1176085993.4101.6.camel@colyT43.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: coly <colyli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38992 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbXDIP0a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Apr 2007 11:26:30 -0400
Content-Disposition: inline
In-Reply-To: <1176085993.4101.6.camel@colyT43.site>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 09, 2007 at 10:33:13AM +0800, coly wrote:
> Theodore:
> 
> Thanks for your replying. 
> 
> Can I understand this way:
> * Though sizeof(struct ext4_inode) is 152, the real inode size on disk
> still depends on mount options.

Not mount options, but how the filesystem is formatted.  So substitute
"mount" with "mke2fs", and that would be correct.

> * If use old inode size, the on disk inode will be 128 bytes.
> * If use new inode size(e.g. extent option in mount), the on disk inode
> will be 256, or more bytes.

s/mount/mke2fs/

And the on-disk inode size is 256, 512, or some greater power of two,
up to the filesystem blocksize.

> * If on disk inode size is 128 bytes, only first 128 bytes of struct
> ext4_inode take effects.

Well, there's no space to store the fields beyond the first 128, so
any features that require the extra inode fields can't be used.

						- Ted
