From: Dave Chinner <david@fromorbit.com>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Wed, 17 Aug 2011 09:59:01 +1000
Message-ID: <20110816235901.GL26978@dastard>
References: <1313251371-3672-1-git-send-email-tm@tao.ma>
 <4E4836A8.3080709@msgid.tls.msk.ru>
 <4E48390E.9050102@msgid.tls.msk.ru>
 <4E488625.609@tao.ma>
 <4E48D231.5060807@msgid.tls.msk.ru>
 <4E48DF31.4050603@msgid.tls.msk.ru>
 <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
 <20110816135325.GD23416@quack.suse.cz>
 <4E4A86D0.2070300@tao.ma>
 <CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, Jan Kara <jack@suse.cz>,
	Michael Tokarev <mjt@tls.msk.ru>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:29309 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824Ab1HPX7P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Aug 2011 19:59:15 -0400
Content-Disposition: inline
In-Reply-To: <CAFgt=MCQttE5Vv_4W=hFWU_L_FvELnY6bnFQ3uSOu07VkDm6rA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 16, 2011 at 02:32:12PM -0700, Jiaying Zhang wrote:
> On Tue, Aug 16, 2011 at 8:03 AM, Tao Ma <tm@tao.ma> wrote:
> > On 08/16/2011 09:53 PM, Jan Kara wrote:
> I wonder whether the following patch will solve the problem:
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 6c27111..ca90d73 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -800,12 +800,17 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>         }
> 
>  retry:
> -       if (rw == READ && ext4_should_dioread_nolock(inode))
> +       if (rw == READ && ext4_should_dioread_nolock(inode)) {
> +               if (unlikely(!list_empty(&ei->i_completed_io_list))) {
> +                       mutex_lock(&inode->i_mutex);
> +                       ext4_flush_completed_IO(inode);
> +                       mutex_unlock(&inode->i_mutex);
> +               }
>                 ret = __blockdev_direct_IO(rw, iocb, inode,
>                                  inode->i_sb->s_bdev, iov,
>                                  offset, nr_segs,
>                                  ext4_get_block, NULL, NULL, 0);
> -       else {
> +       } else {
>                 ret = blockdev_direct_IO(rw, iocb, inode,
>                                  inode->i_sb->s_bdev, iov,
>                                  offset, nr_segs,
> 
> I tested the patch a little bit and it seems to resolve the race
> on dioread_nolock in my case. Michael, I would very appreciate
> if you can try this patch with your test case and see whether it works.

Just my 2c worth here: this is a data corruption bug so the root
cause neeeds to be fixed. The above patch does not address the root
cause.

> > You are absolutely right. The really problem is that ext4_direct_IO
> > begins to work *after* we clear the page writeback flag and *before* we
> > convert unwritten extent to a valid state. Some of my trace does show
> > that. I am working on it now.

And that's the root cause - think about what that means for a
minute.  It means that extent conversion can race with anything that
requires IO to complete first. e.g. truncate or fsync.  It can then
race with other subsequent operations, which can have even nastier
effects. IOWs, there is a data-corruption landmine just sitting
there waiting for the next person to trip over it.

Fix the root cause, don't put band-aids over the symptoms.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
