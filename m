From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/7] ext4: ext4_inode_info diet
Date: Thu, 13 Sep 2012 15:15:40 +0400
Message-ID: <871ui65g2r.fsf@openvz.org>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org> <1347211634-11509-2-git-send-email-dmonakhov@openvz.org> <20120913105022.GE11330@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45041 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530Ab2IMLPm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 07:15:42 -0400
Received: by lbbgj3 with SMTP id gj3so1860225lbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 04:15:41 -0700 (PDT)
In-Reply-To: <20120913105022.GE11330@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 13 Sep 2012 18:50:22 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Sun, Sep 09, 2012 at 09:27:08PM +0400, Dmitry Monakhov wrote:
> > Generic inode has unused i_private pointer which may be used as cur_aio_dio
> > storage.
> > 
> > TODO: If cur_aio_dio will be passed as an argument to get_block_t this allow
> >       to have concurent AIO_DIO requests.
> 
> Out of curiosity, could you please describe your idea about concurrent
> AIO_DIO requests in get_block_t?  Thanks!
Current buffer.c API layering looks sub-optimal

->xxx_fs_routine: May create different contexts
   ->generic_buffer_methods(inode, bh..)
     ->xxx_fs_get_block(inode, bh,...): There is no efficient way to pass fscontext 
Both xxx_fs_routine and xxx_fs_get_block are fs specific, but
the only way to pass fscontext down to get_block is to pass it by
attaching it to inode, which make it implicit serialization point.

I just want to add fsprivate argument to get_block_t callback similar
write_begin/write_end and iocb->private, so filesystem will able to pass
it to it's get_block callback.
 
> 
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> Looks good to me.  You can add:
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> Regards,
> Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
