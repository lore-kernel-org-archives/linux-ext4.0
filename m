From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 05/35 v3] libext2fs: add EXT4_INLINE_DATA_FL flag for
 inode
Date: Tue, 17 Jul 2012 10:20:53 +0800
Message-ID: <20120717022052.GA27204@gmail.com>
References: <1341150538-32047-1-git-send-email-wenqing.lz@taobao.com>
 <1341150538-32047-6-git-send-email-wenqing.lz@taobao.com>
 <20120716150144.GA3670@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Tao Ma <tm@tao.ma>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37167 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2GQCMR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jul 2012 22:12:17 -0400
Received: by pbbrp8 with SMTP id rp8so10975289pbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jul 2012 19:12:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120716150144.GA3670@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 16, 2012 at 11:01:44AM -0400, Theodore Ts'o wrote:
> On Sun, Jul 01, 2012 at 09:48:28PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Add EXT4_INLINE_DATA_FL flag.
> > 
> >  /* EXT4_EOFBLOCKS_FL 0x00400000 was here */
> > +#define EXT4_INLINE_DATA_FL		0x00800000 /* Inode has inline data */
> 
> Hi,
> 
> Unfortunately, we have a codepoint collision.  The BTRFS folks have
> already exposed FS_NOCOW_FL as 0x00800000; this is in mainline in the
> kernel, and in fact that latest version of e2fsprogs understands this
> since lsattr and chattr are used by multiple file systems (even though
> it was originally intended only for ext2/3/4).
> 
> I'd like to move this to:
> 
> #define EXT4_INLINE_DATA_FL	0x10000000 /* Inode has inline data */
> 
> However, if you already have this in production internally inside
> Taobao, this could potentially could be a problem for you.  (We've had
> to handle this before inside Google, when we used a different code
> point for EOFBLOCKS_FL than what ended up being used in mainline; it
> can be dealt with, but it's certainly annoying...)
> 
> Is this going to potentially be a problem for you?

Hi Ted,

I have discussed this issue with Tao, and it is not a problem for us.
So we could change it to '0x10000000'. :)

Regards,
Zheng
