From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: make ext4_add_dirent_to_inline function return 0
Date: Tue, 9 Jul 2013 20:15:02 +0800
Message-ID: <20130709121502.GA3946@gmail.com>
References: <1373328699-23037-1-git-send-email-wenqing.lz@taobao.com>
 <51DB6BA0.7000800@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51129 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3GIL4Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jul 2013 07:56:24 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so5416397pbc.21
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jul 2013 04:56:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <51DB6BA0.7000800@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 09, 2013 at 09:47:12AM +0800, Tao Ma wrote:
> On 07/09/2013 08:11 AM, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Currently ext4_add_dirent_to_inline() function returns 1 to indicate
> > that a new directory entry has been added.  But it sounds reasonable
> > to return 0 in this function.  Meanwhile we also can eliminate a if
> > statement in ext4_add_entry() function when a directory entry has added
> > correctly.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Cc: Tao Ma <tm@tao.ma>
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > ---
> >  fs/ext4/inline.c |    2 +-
> >  fs/ext4/namei.c  |    6 +-----
> >  2 files changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> > index b8a0746..5a27d32 100644
> > --- a/fs/ext4/inline.c
> > +++ b/fs/ext4/inline.c
> > @@ -1027,7 +1027,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
> >  	ext4_update_dx_flag(dir);
> >  	dir->i_version++;
> >  	ext4_mark_inode_dirty(handle, dir);
> > -	return 1;
> > +	return 0;
> >  }
> >  
> >  static void *ext4_get_inline_xattr_pos(struct inode *inode,
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index ab2f6dc..2a6a736 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -1901,12 +1901,8 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
> >  
> >  	if (ext4_has_inline_data(dir)) {
> >  		retval = ext4_try_add_inline_entry(handle, dentry, inode);
> > -		if (retval < 0)
> > +		if (retval <= 0)
> Sorry, I guess you misread the codes here. If we get 0 here, it means
> that ext4_try_add_inline_entry can't add this entry into the inline
> data, but there is no error, so please go on with the normal case. "1"
> means we have successfully done the work. So your change is wrong.

Ah, you are right.  Thanks for pointing it out.

                                                - Zheng
