From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH RESEND] ext4: make sure O_(D)SYNC semantic in
 ext4_fallocate()
Date: Thu, 14 Jun 2012 10:43:22 +0800
Message-ID: <20120614024322.GA5759@gmail.com>
References: <1326703663-4801-1-git-send-email-wenqing.lz@taobao.com>
 <20120614001531.GB22646@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49712 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2FNCfa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2012 22:35:30 -0400
Received: by dady13 with SMTP id y13so1888735dad.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2012 19:35:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120614001531.GB22646@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 13, 2012 at 08:15:31PM -0400, Ted Ts'o wrote:
> Hi Zheng,
> 
> I finally got around to reviewing this patch and I had one comment
> 
> > Ext4 must make sure the transaction to be commited to the disk when
> > user opens a file with O_(D)SYNC flag and do a fallocate(2) call.
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 74f23c2..00e32d9 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4356,6 +4356,8 @@ retry:
> >  			ret = PTR_ERR(handle);
> >  			break;
> >  		}
> > +		if (file->f_flags & O_SYNC)
> > +			ext4_handle_sync(handle);
> >  		ret = ext4_map_blocks(handle, inode, &map, flags);
> >  		if (ret <= 0) {
> >  #ifdef EXT4FS_DEBUG
> 
> For a large fallocate(), it can require multiple calls to
> ext4_map_blocks(), and we should only sync after we've allocated the
> last segment.  We should also not force a sync if there is an error
> allocating blocks.  So it seems to me this patch would be better; what
> do you think?

Hi Ted,

Thank you for your review.  I agree with you that the following patch is
better.

Regards,
Zheng

> commit b790d70be9515dfaba59b0be0aff373e6867826d
> Author: Zheng Liu <gnehzuil.liu@gmail.com>
> Date:   Wed Jun 13 20:15:01 2012 -0400
> 
>     ext4: honor O_(D)SYNC semantic in ext4_fallocate()
>     
>     Ext4 must make sure the transaction to be commited to the disk when
>     user opens a file with O_(D)SYNC flag and do a fallocate(2) call.
>     
>     This problem had been reported by Christoph Hellwig in this thread:
>     http://www.spinics.net/lists/linux-btrfs/msg13621.html
>     
>     Reported-by: Christoph Hellwig <hch@infradead.org>
>     Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 91341ec..f1089cb 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4420,6 +4420,8 @@ retry:
>  		ext4_falloc_update_inode(inode, mode, new_size,
>  					 (map.m_flags & EXT4_MAP_NEW));
>  		ext4_mark_inode_dirty(handle, inode);
> +		if ((file->f_flags & O_SYNC) && ret >= max_blocks)
> +			ext4_handle_sync(handle);
>  		ret2 = ext4_journal_stop(handle);
>  		if (ret2)
>  			break;
