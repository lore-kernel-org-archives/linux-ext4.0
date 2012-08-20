From: Antonio Huete Jimenez <ahuete.devel@gmail.com>
Subject: Fwd: [PATCH] Add support for DragonFly BSD operating system.
Date: Mon, 20 Aug 2012 14:28:51 +0200
Message-ID: <CACegU+vCHhbtVXrF9EP5ShqV3tcGODqLN79aNavQcekBFiBh0Q@mail.gmail.com>
References: <op.whcml3m4f7p71t@sixfeet.quantumachine.net>
	<20120713003026.GA30092@thunk.org>
	<op.whiji7pcf7p71t@sixfeet.quantumachine.net>
	<20120716020328.GA29544@thunk.org>
	<CACegU+tjX0_6zkADvL2F1GP1QOZpPYk8sK5ETCEvw3FqU3aXiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39725 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2HTM2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Aug 2012 08:28:52 -0400
Received: by vcbfk26 with SMTP id fk26so4836526vcb.19
        for <linux-ext4@vger.kernel.org>; Mon, 20 Aug 2012 05:28:52 -0700 (PDT)
In-Reply-To: <CACegU+tjX0_6zkADvL2F1GP1QOZpPYk8sK5ETCEvw3FqU3aXiA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/7/16 Theodore Ts'o <tytso@mit.edu>
>
> On Mon, Jul 16, 2012 at 02:26:57AM +0200, Antonio Huete Jim=E9nez wro=
te:
> > I've pasted both new patches in this email with the intention of
> > producing less traffic in the mailing list, but I'm unsure if this
> > is the correct thing to do, opposed to sending one mail per patch.
>
> It's better to send one mail per patch.  The reason for that is we
> have automated tools that do the right thing with patches sent one pe=
r
> e-mail.  This includes patchwork (which tracks patches sent to the
> mailing list; see
> http://patchwork.ozlabs.org/project/linux-ext4/list/) and "git am".
>
> Just use the git send-email tool; it will do the right thing.


I've used git send-email to send the patch that combines all BSDs into
a single tag.

>
>
> There are places where you are using #if defined(__DragonFly__) and
> there are other places where you are using #ifdef DIOCGPART.  Is ther=
e
> a reason for this?

I've used DIOCGPART because the rest of the code around uses
DIOCGMEDIASIZE, DIOCGDINFO in a kind of sorted order, so I just copied
the style.

>
>
> In general, it's better to avoid using explicit feature tests rather
> things like defined(__Dragonfly__) or defined(__solaris__).  What if
> an OS changes names or forks (i.e., like Open Solaris, Nextensa,
> Illumos, etc.).
>

Same could happen to the DIOCGDINFO #ifdefs, no?

>
> And the combination of an #ifdef based on HAVE_SYS_DISKLABEL_H,
> DIOCGPART, and defined(__DragonFly__) raises red flags that the
> combinatorics may be very brittle in the long run.
>

Right but in some parts it is necessary to skip the code even if
HAVE_SYS_DISKLABEL_H is defined. If you think there's a better way,
just let me know and I'll change it righaway.

>
> Regards,
>
>                                         - Ted


Cheers,
Antonio Huete
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
