From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext4: Prevent race while walking extent tree
Date: Wed, 21 Nov 2012 11:35:15 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211211134340.23054@dhcp-1-104.brq.redhat.com>
References: <1353423460-12178-1-git-send-email-lczerner@redhat.com> <1353423460-12178-2-git-send-email-lczerner@redhat.com> <20121121065542.GA14704@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, dmonakhov@openvz.org, bergwolf@gmail.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab2KUKfj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Nov 2012 05:35:39 -0500
In-Reply-To: <20121121065542.GA14704@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 21 Nov 2012, Zheng Liu wrote:

> Date: Wed, 21 Nov 2012 14:55:42 +0800
> From: Zheng Liu <gnehzuil.liu@gmail.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dmonakhov@openvz.org,
>     bergwolf@gmail.com
> Subject: Re: [PATCH 1/2] ext4: Prevent race while walking extent tree
> 
> On Tue, Nov 20, 2012 at 03:57:39PM +0100, Lukas Czerner wrote:
> [cut]
> > +
> >  int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> >  		__u64 start, __u64 len)
> >  {
> > @@ -4802,8 +4811,8 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
> >  		 * Walk the extent tree gathering extent information.
> >  		 * ext4_ext_fiemap_cb will push extents back to user.
> >  		 */
> 
> This comment needs to be updated because ext4_ext_fiemap_cb has been
> renamed.
> 
> Regards,
>                                                 - Zheng

Good catch, I'll resend it.

Thanks!
-Lukas

> 
> > -		error = ext4_ext_walk_space(inode, start_blk, len_blks,
> > -					  ext4_ext_fiemap_cb, fieinfo);
> > +		error = ext4_fill_fiemap_extents(inode, start_blk,
> > +						 len_blks, fieinfo);
> >  	}
> >  
> >  	return error;
> > -- 
> > 1.7.7.6
> > 
> 
