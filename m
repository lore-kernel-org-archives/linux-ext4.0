From: Haibo <haiboliu6@gmail.com>
Subject: Re:[PATCH] change a comment on fs/ext4/extents.c
Date: Fri, 22 Jun 2012 02:14:41 +0800
Message-ID: <1340302481-7785-1-git-send-email-HaiboLiu6@gmail.com>
References: <4fe09c5f.4ad3440a.5cc5.7bac@mx.google.com>
Cc: haiboliu6@gmail.com
To: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666Ab2FUSOr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2012 14:14:47 -0400
Received: by pbbrp8 with SMTP id rp8so2440258pbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2012 11:14:47 -0700 (PDT)
In-Reply-To: <4fe09c5f.4ad3440a.5cc5.7bac@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> Hi Haibo,
> 
> If your patch only relates to ext4, please change the patch's subject
> like this:
> [PATCH] ext4: change a comment on fs/ext4/extents.c
> 
> On Tue, Jun 19, 2012 at 11:35:47PM +0800, haiboliu6@gmail.com wrote:
> > From: HaiboLiu <HaiboLiu6@gmail.com>
> > 
> > May be it's better.
> 
> Maybe the following commit log is better:
> In this patch (197217a5), ext4_ext_try_to_merge has been changed to
> merge an extent both left and right.  So we need to update the comment
> in here.
> 
> Regards,
> Zheng
> 
> > 
> > Signed-off-by: HaiboLiu <HaiboLiu6@gmail.com>
> > ---
> >  fs/ext4/extents.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 74f23c2..db671b9 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -1807,11 +1807,10 @@ has_space:
> >  	nearex->ee_len = newext->ee_len;
> >  
> >  merge:
> > -	/* try to merge extents to the right */
> > +	/* try to merge extents */
> >  	if (!(flag & EXT4_GET_BLOCKS_PRE_IO))
> >  		ext4_ext_try_to_merge(inode, path, nearex);
> >  
> > -	/* try to merge extents to the left */
> >  
> >  	/* time to correct all indexes above */
> >  	err = ext4_ext_correct_indexes(handle, inode, path);
> > -- 
> > 1.7.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks for your suggestion. I update the patch subject and the patch comment and resend it.

Regards,
Haibo Liu
