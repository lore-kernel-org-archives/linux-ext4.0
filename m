From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 13/30] ext4: snapshot file - increase maximum file
 size limit to 16TB
Date: Fri, 3 Jun 2011 07:45:34 +0300
Message-ID: <BANLkTimW=mfWvByCdV-d4-DShPwcMEC+kw@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<1304959308-11122-14-git-send-email-amir73il@users.sourceforge.net>
	<BANLkTi=uHU-LH0QwCvn=5su3ZaVK_7YgnQ@mail.gmail.com>
	<20110603004837.GF16306@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43327 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1FCEph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jun 2011 00:45:37 -0400
Received: by wya21 with SMTP id 21so1119666wya.19
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jun 2011 21:45:36 -0700 (PDT)
In-Reply-To: <20110603004837.GF16306@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 3, 2011 at 3:48 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Jun 02, 2011 at 02:47:19PM +0300, Amir G. wrote:
>> Let it not be said that my patches don't get reviewed ;-)
>
> Between the merge window work, and the fact that I'm in Yokohama this
> week attending the Linux Con Japan conference, and in two weeks I wil=
l
> be in Portland for Usenix, it's unlikely I will have any time to look
> at your snapshot patches until the end of the month. =A0Sorry, but
> things have just been crazy as of late.
>
> I had been hoping that other people would have had time to look at
> your patches, but I suspect this has been a busy time for other folks
> as well.
>
> I'm certainly willing to try using the github workflow, although the
> fact that it requires an on-line network connection is a little
> inconvenient when one is on airplanes as much as I have been as of
> late. =A0But it may be that the upsides more than compensate for this
> one disadvantage.
>
> Please do send a pointer to the patches to be reviewed on github to
> the ext4 list, so that hopefully others on this list will be able to
> look at your patches.
>
> Thanks,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>

Hi All,

Please see my patches online at:
https://github.com/amir73il/ext4-snapshots/commits/for-ext4/

You'd be surprised how easy (and addictive) it is to review patches thi=
s way.
just click on one of the commits, scroll down and click a line to
insert a comment
(which I get by email and can reply by email and our thread shows up em=
bedded
in the commit on the website).

=46eel free to just leave "XXX was here" so everyone can see how it wor=
ks.

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
