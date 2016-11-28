From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 3/3] ext4: correctly detect when an xattr value has an
 invalid size
Date: Mon, 28 Nov 2016 15:50:35 -0800
Message-ID: <20161128235035.GC145516@google.com>
References: <1480228786-106775-1-git-send-email-ebiggers@google.com>
 <1480228786-106775-3-git-send-email-ebiggers@google.com>
 <ED9B2B5D-25DD-4D4A-9F1C-86656B154AA8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36481 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753647AbcK1Xui (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2016 18:50:38 -0500
Received: by mail-pf0-f174.google.com with SMTP id 189so27536542pfz.3
        for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2016 15:50:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <ED9B2B5D-25DD-4D4A-9F1C-86656B154AA8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 28, 2016 at 12:50:02PM -0700, Andreas Dilger wrote:
> On Nov 26, 2016, at 11:39 PM, Eric Biggers <ebiggers@google.com> wrote:
> > 
> > It was possible for an xattr value to have a very large size, which
> > would then pass validation on 32-bit architectures due to a pointer
> > wraparound.  Fix this by validating the size in a way which avoids
> > pointer wraparound.
> 
> It isn't actually possible for a valid xattr value to be very large.
> At most 65536 bytes even with large blocks, so it might be easier to
> directly check that e_value_size is not too large rather than trying
> to deal with values of 0xfffffffe bytes or similar?
> 

I suppose we could do something like

	EXT4_XATTR_SIZE(size) > end - value || size > EXT4_MAX_BLOCK_SIZE

instead of

	size > end - value || EXT4_XATTR_SIZE(size) > end - value

But I don't think it's really any better.

Eric
