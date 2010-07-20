From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCHES/RFC v1.0.12] e2fsprogs: Next3 patch series
Date: Tue, 20 Jul 2010 22:12:22 +0200
Message-ID: <AANLkTikIpmopbJvdvm9cafuLYbtQkBlHhhL7u0PACPZQ@mail.gmail.com>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
	<AANLkTinlL0YEiDGWw0qjyYYzR31D_DBKQxFczSu4UYt6@mail.gmail.com>
	<20100720163825.GC12998@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64779 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab0GTUMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 16:12:24 -0400
Received: by fxm14 with SMTP id 14so3134623fxm.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 13:12:23 -0700 (PDT)
In-Reply-To: <20100720163825.GC12998@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 20, 2010 at 6:38 PM, Jan Kara <jack@suse.cz> wrote:
>> In fact, the posted patches are only the small patches to e2fsprogs.
>> The more challenging job is the review of the Next3 snapshot patches=
,
>> which apply on top of ext3 (or rather a forked branch of ext3 called=
 next3).
>> They are available for download at
>> http://sourceforge.net/projects/next3/files/Latest%20patch%20series
>> but I can also post them to the list if you like (about 40 medium si=
ze patches).
> =A0Well, I can have a look at those patches. But I'd like to know wha=
t is
> exactly your motivation - is it that you have some customers running =
with
> this clone and want to upstream the fs, or is it that you'd like to
> contribute the cool feature you've developped, or something else?

contribute cool feature is the best match.

> Because on this depends where we should go from the current situation=
=2E..
> =A0To state my position: I'm not willing to merge the feature into ex=
t3
> because it's basically in a maintenance mode so we don't accept large=
r
> features to it anymore (for stability reasons).

of course.

> =A0You could, of course, copy ext3 code base and create a separate ne=
xt3
> filesystem. But such code duplication would be generally frowned upon=
 and I
> personally wouldn't like to take the burden of maintaining such code =
so
> you'd have to do it. Moreover you have to port all ext3 fixes to your=
 code
> and you have a problem that as time progresses, new features are adde=
d to
> ext4, not ext3, so I think it would be less and less attractive to ru=
n
> Next3 instead of ext4... So this doesn't seem like an ideal solution =
either.

you are not the first to tell me that the fork from ext3 is not a good =
idea.
I agree that in the long term, Next3 as a file system driver has no pla=
ce,
but for practical reasons, I needed to create a separate file system dr=
iver,
so people will be able to use the new feature without patching ext3 dur=
ing
the long time it will take me to merge the feature to ext4.


> =A0For future, the most promising to me would be to change the
> implementation to work with ext4 and merge it there. I understand the=
re are
> technical issues with this and I'm not sure how hard they would be to
> solve. But for me as a filesystem developper this would seem like a
> direction where it's worth to invest some time and energy and I can h=
elp
> with that (and I believe other ext4 developpers might lend a hand as =
well).
> =A0Just my thoughts...

and the first step towards getting the snapshot feature into ext4 is
for some ext3/4
developers to review the patches, so I will have someone (rather some t=
han one)
with whom I can discuss the merge issues.
I actually proposed the next3 merge as a topic for LSF, but that
didn't get much attention.

> Anyway, I've added to my todo an item to have a look
> at your patches so that I have better idea what we are discussing abo=
ut.

That would be great.
If you like, we can schedule a call after you've gone through some of
the patches/docs.
I have done this with Ted and I think it's a good way to get started.
if you haven't looked at http://sourceforge.net/apps/mediawiki/next3/
that would be a good place to start (also links to the snapshots design=
 paper)

Thanks for taking an interest,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
