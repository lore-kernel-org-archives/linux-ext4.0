From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] resize: Do not fail if EXT4_IOC_RESIZE_FS ioctl doesn't
 exist
Date: Mon, 17 Oct 2011 08:56:27 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110170855010.3115@dhcp-27-109.brq.redhat.com>
References: <1318607374-17246-1-git-send-email-lczerner@redhat.com> <CAGBYx2ac38XzfwUONx+cKwW+fwV4msAFxBE3q6EE+97aeoHUSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-624458157-1318834591=:3115"
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab1JQG4d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Oct 2011 02:56:33 -0400
In-Reply-To: <CAGBYx2ac38XzfwUONx+cKwW+fwV4msAFxBE3q6EE+97aeoHUSg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-624458157-1318834591=:3115
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 17 Oct 2011, Yongqiang Yang wrote:

> On Fri, Oct 14, 2011 at 11:49 PM, Lukas Czerner <lczerner@redhat.com> wrote:
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
> Great comment !
> > +               if (errno != ENOTTY) {
> In my working tree, it has been ENOTTY but there is no comment.  And I
> found EINVAL was introduced in commit
> 200569608fc6e33f6546(https://github.com/tytso/e2fsprogs/commit/200569608fc6e33f6546c17999f14fb5dbb0b9b5)
> to fix some bugs and reason is listed.

Oh, I am sorry. I have missed the line in git blame. You're right it was
originally ENOTTY, thanks!

-Lukas

> 
> 
> Yongqiang.
> >                        if (errno == EPERM)
> >                                com_err(program_name, 0,
> >                                _("Permission denied to resize filesystem"));
> > --
> > 1.7.4.4
> >
> >
> 
> 
> 
> 

-- 
--8323328-624458157-1318834591=:3115--
