From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC PATCH] ext4: convert swap_inode_data() over to use swap()
 on most of the fields
Date: Wed, 04 Jan 2017 15:21:28 -0500
Message-ID: <1483561288.1826.1.camel@redhat.com>
References: <1482249341-21113-1-git-send-email-jlayton@redhat.com>
         <20170104154332.GA3607@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:33156 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032277AbdADUVf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2017 15:21:35 -0500
Received: by mail-qt0-f176.google.com with SMTP id v23so32871531qtb.0
        for <linux-ext4@vger.kernel.org>; Wed, 04 Jan 2017 12:21:35 -0800 (PST)
In-Reply-To: <20170104154332.GA3607@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2017-01-04 at 16:43 +0100, Jan Kara wrote:
> On Tue 20-12-16 10:55:41, Jeff Layton wrote:
> > 
> > For some odd reason, it forces a byte-by-byte copy of each field. A
> > plain old swap() on most of these fields would be more efficient. We
> > do need to retain one memswap however as that field is an array.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> Looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 

Thanks. Yeah, it's certainly nothing critical -- just something I
noticed while looking at the i_version rework. Seems like it might be
good to let soak in next for v4.11?

> > 
> > ---
> >  fs/ext4/ioctl.c | 18 ++++++++----------
> >  1 file changed, 8 insertions(+), 10 deletions(-)
> > 
> > diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> > index 49fd1371bfa2..fb844da4836f 100644
> > --- a/fs/ext4/ioctl.c
> > +++ b/fs/ext4/ioctl.c
> > @@ -60,18 +60,16 @@ static void swap_inode_data(struct inode *inode1, struct inode *inode2)
> >  	ei1 = EXT4_I(inode1);
> >  	ei2 = EXT4_I(inode2);
> >  
> > -	memswap(&inode1->i_flags, &inode2->i_flags, sizeof(inode1->i_flags));
> > -	memswap(&inode1->i_version, &inode2->i_version,
> > -		  sizeof(inode1->i_version));
> > -	memswap(&inode1->i_blocks, &inode2->i_blocks,
> > -		  sizeof(inode1->i_blocks));
> > -	memswap(&inode1->i_bytes, &inode2->i_bytes, sizeof(inode1->i_bytes));
> > -	memswap(&inode1->i_atime, &inode2->i_atime, sizeof(inode1->i_atime));
> > -	memswap(&inode1->i_mtime, &inode2->i_mtime, sizeof(inode1->i_mtime));
> > +	swap(inode1->i_flags, inode2->i_flags);
> > +	swap(inode1->i_version, inode2->i_version);
> > +	swap(inode1->i_blocks, inode2->i_blocks);
> > +	swap(inode1->i_bytes, inode2->i_bytes);
> > +	swap(inode1->i_atime, inode2->i_atime);
> > +	swap(inode1->i_mtime, inode2->i_mtime);
> >  
> >  	memswap(ei1->i_data, ei2->i_data, sizeof(ei1->i_data));
> > -	memswap(&ei1->i_flags, &ei2->i_flags, sizeof(ei1->i_flags));
> > -	memswap(&ei1->i_disksize, &ei2->i_disksize, sizeof(ei1->i_disksize));
> > +	swap(ei1->i_flags, ei2->i_flags);
> > +	swap(ei1->i_disksize, ei2->i_disksize);
> >  	ext4_es_remove_extent(inode1, 0, EXT_MAX_BLOCKS);
> >  	ext4_es_remove_extent(inode2, 0, EXT_MAX_BLOCKS);
> >  
> > -- 
> > 2.7.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jeff Layton <jlayton@redhat.com>
