From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] mke2fs: clarify inline data inode size error message
Date: Wed, 1 Oct 2014 16:36:17 -0400
Message-ID: <20141001203616.GA2860@wallace>
References: <20140927155515.GA2322@wallace>
 <20140929055350.GL10150@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:48543 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaJAUgV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Oct 2014 16:36:21 -0400
Received: by mail-qa0-f52.google.com with SMTP id dc16so866883qab.25
        for <linux-ext4@vger.kernel.org>; Wed, 01 Oct 2014 13:36:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140929055350.GL10150@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Darrick J. Wong <darrick.wong@oracle.com>:
> On Sat, Sep 27, 2014 at 11:55:15AM -0400, Eric Whitney wrote:
> > The existing error message can be made more helpful by more clearly
> > implying the attempt to make a file system with undersized inodes is
> > failing and suggesting a corrective action.
> > 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > ---
> >  misc/mke2fs.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index 2bc435b..00bb00d 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -2358,7 +2358,8 @@ profile_error:
> >  	     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
> >  	    fs_param.s_inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
> >  		com_err(program_name, 0,
> > -			_("inode size is %d, inline data is useless"),
> > +			_("%d byte inodes are too small for inline data; "
> > +			  "specify larger size"),
> 
> How much larger?  The next larger inode size is 256 bytes, so we ought to tell
> the user that.  ("specify a size at least 256 bytes"?)
> 
> --D

I'd be fine with that as well.  My only concern is that noting the minimum
might lead to users taking that as the default when that might not best
suit their needs.  I thought that the reworked message I suggested might
send them off to the mke2fs man page, where it's at least clear the legal
sizes are powers of 2 greater than 128 bytes.  However, we don't seem to
have published any useful guidelines regarding inode size selection when
building a file system supporting inline data.  Your inline data notes on
the wiki are about as good as we've got, unless I've missed something, and
I think we'd want a little more addressing inode size tradeoffs.

I wonder if Zheng has anything relevant we can use to improve the manpages?

Again, if an error message specifying the minimum or say, a range from minimum
to maximum suggested is preferred, I'd be happy to post another patch.

Thanks,
Eric



> 
> >  			fs_param.s_inode_size);
> >  		exit(1);
> >  	}
> > -- 
> > 1.9.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
