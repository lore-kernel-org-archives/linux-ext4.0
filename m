From: yargil@free.fr
Subject: Re: [PATCH v2] ext4: don't work without procfs
Date: Thu, 06 Oct 2011 14:48:54 +0200
Message-ID: <1317905334.4e8da3b62b99c@imp.free.fr>
References: <1317743049-4641-1-git-send-email-yargil@free.fr> <alpine.LFD.2.00.1110051456440.4423@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:44180 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255Ab1JFMtE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Oct 2011 08:49:04 -0400
In-Reply-To: <alpine.LFD.2.00.1110051456440.4423@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Selon Lukas Czerner <lczerner@redhat.com>:

Thanks for your review. But shame on me, i just found out that I did not follow
the procedure to submit the patch and it is not Signed-off-by. I will resubmit
you this patch by following the linux/Documentation/SubmittingPatches.

> On Tue, 4 Oct 2011, Yargil wrote:
>
> > Regression from commit dd68314ccf3fb918c1fb6471817edbc60ece4b52
> > The problem come from the test of the return value of proc_mkdir
> > that is always false without procfs and abort the init of ext4.
>
> Looks good. Thanks!
>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
>
> > ---
> >  fs/ext4/super.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 44d0c8d..9b51b17 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -4985,8 +4985,10 @@ static int __init ext4_init_fs(void)
> >  	if (!ext4_kset)
> >  		goto out6;
> >  	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
> > +#ifdef CONFIG_PROC_FS
> >  	if (!ext4_proc_root)
> >  		goto out5;
> > +#endif
> >
> >  	err = ext4_init_feat_adverts();
> >  	if (err)
> >
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


