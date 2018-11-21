Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728283AbeKVBEb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 20:04:31 -0500
Date: Wed, 21 Nov 2018 15:29:50 +0100
From: Jan Kara <jack@suse.cz>
To: cgxu519 <cgxu519@gmx.com>
Cc: Jan Kara <jack@suse.cz>, jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext2: compare old and new mode before setting
 update_mode flag
Message-ID: <20181121142950.GE28182@quack2.suse.cz>
References: <20181117090100.29063-1-cgxu519@gmx.com>
 <20181119100425.GD16427@quack2.suse.cz>
 <e9db0f67-fc05-9ec8-5953-8e3724c43cc8@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e9db0f67-fc05-9ec8-5953-8e3724c43cc8@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 21-11-18 18:55:28, cgxu519 wrote:
> On 11/19/18 6:04 PM, Jan Kara wrote:
> > On Sat 17-11-18 17:01:00, Chengguang Xu wrote:
> > > If new mode is the same as old mode we don't have to reset
> > > inode mode in the rest of the code, so compare old and new
> > > mode before setting update_mode flag.
> > > 
> > > Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> > I don't think this is quite correct. E.g. I would think that i_ctime should
> > be updated even if the effective mode resulting from acl did not change.
> 
> I think  __ext2_set_acl() will probably update i_ctime in this case, am I
> missing something?

Yeah, you're right. But I'd still prefer to keep the code simple as is.
There's no great reason to optimize this since saved time is going to be
minimal and the code is not performance critical.

								Honza


> > diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
> > index cf4c77f8dd08..f4dd728393c8 100644
> > --- a/fs/ext2/acl.c
> > +++ b/fs/ext2/acl.c
> > @@ -226,7 +226,8 @@ ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> >   		error = posix_acl_update_mode(inode, &mode, &acl);
> >   		if (error)
> >   			return error;
> > -		update_mode = 1;
> > +		if (mode != inode->i_mode)
> > +			update_mode = 1;
> >   	}
> >   	error = __ext2_set_acl(inode, acl, type);
> >   	if (!error && update_mode) {
> > -- 
> > 2.17.2
> > 
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
