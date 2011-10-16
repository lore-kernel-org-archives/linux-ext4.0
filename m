From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] resize: Do not fail if EXT4_IOC_RESIZE_FS ioctl doesn't
 exist
Date: Sun, 16 Oct 2011 12:39:50 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110161233130.19533@dhcp-27-109.brq.redhat.com>
References: <1318607374-17246-1-git-send-email-lczerner@redhat.com> <CAOQ4uxj1cz4Kp24orbskngqnn2TwV88s=HSDRa-AcapFGHaNEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1192053958-1318761594=:19533"
Cc: Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, xiaoqiangnk@gmail.com
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1JPKj4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Oct 2011 06:39:56 -0400
In-Reply-To: <CAOQ4uxj1cz4Kp24orbskngqnn2TwV88s=HSDRa-AcapFGHaNEA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1192053958-1318761594=:19533
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 16 Oct 2011, Amir Goldstein wrote:

> On Fri, Oct 14, 2011 at 5:49 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > Commit 9f6ba888f027ba4daf57ac61a11a6dce98e42347 added support for new
> > online resize ioctl EXT4_IOC_RESIZE_FS. It is also trying to avoid
> > failure when this ioctl() is not supported by the kernel however
> > it is checking wrong error code (EINVAL).
> >
> > When the ioctl does not exist, errno is set to ENOTTY, so we should
> > check for that, rather than EINVAL which means that ioctl arguments
> > are not valid. So change the code to check for ENOTTY and allow
> > resize2fs to try to use the old approach. Also add some comments.
> >
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >
> > Btw I can not find the new kernel code anywhere. It is not in Linus tree,
> > it also is not in the github ext4 master, nor dev tree. Where it is then ?
> 
> AFAIK, the latest version of the patches is here:
> https://github.com/YANGYongqiang/ext4-patch-queue
> 
> and I suppose Ted should have it in patchworks as well.
> 
> Ted,
> 
> Are you planning to merge new online resize for 3.2?

Thanks Amir,

also it would be nice if the kernel functionality was merged before the
corresponding user-space tools as I thought it is the right course of
action.

Also Ted, could you merge this patch ASAP, since the online resize2fs is
unusable in the current state.

Thanks!
-Lukas

> 
> Thanks,
> Amir.
> 
> 
> 
> > The problem is that the recent released e2fsprogs are broken for all
> > kernels. To be more specific, resize2fs is broken for all kernels.
> >
> >
> >  resize/online.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> >
> > diff --git a/resize/online.c b/resize/online.c
> > index 77290c2..1a77839 100644
> > --- a/resize/online.c
> > +++ b/resize/online.c
> > @@ -72,7 +72,12 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
> >        }
> >
> >        if (ioctl(fd, EXT4_IOC_RESIZE_FS, new_size)) {
> > -               if (errno != EINVAL) {
> > +               /*
> > +                * If kernel does not support EXT4_IOC_RESIZE_FS, use the
> > +                * old online resize. Note that the old approach does not
> > +                * handle >32 bit file systems
> > +                */
> > +               if (errno != ENOTTY) {
> >                        if (errno == EPERM)
> >                                com_err(program_name, 0,
> >                                _("Permission denied to resize filesystem"));
> > --
> > 1.7.4.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 

-- 
--8323328-1192053958-1318761594=:19533--
