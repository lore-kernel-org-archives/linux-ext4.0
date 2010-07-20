From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCHES/RFC v1.0.12] e2fsprogs: Next3 patch series
Date: Tue, 20 Jul 2010 17:11:19 -0400
Message-ID: <AANLkTinbXP4klNS1LScsCQqyEALMYxq9iS5DwOwFJduf@mail.gmail.com>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
	<AANLkTinlL0YEiDGWw0qjyYYzR31D_DBKQxFczSu4UYt6@mail.gmail.com>
	<20100720163825.GC12998@quack.suse.cz>
	<AANLkTikIpmopbJvdvm9cafuLYbtQkBlHhhL7u0PACPZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65098 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758659Ab0GTVLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 17:11:21 -0400
Received: by iwn7 with SMTP id 7so6038044iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 14:11:19 -0700 (PDT)
In-Reply-To: <AANLkTikIpmopbJvdvm9cafuLYbtQkBlHhhL7u0PACPZQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 20, 2010 at 4:12 PM, Amir G. <amir73il@users.sourceforge.ne=
t> wrote:
> On Tue, Jul 20, 2010 at 6:38 PM, Jan Kara <jack@suse.cz> wrote:
>>> In fact, the posted patches are only the small patches to e2fsprogs=
=2E
>>> The more challenging job is the review of the Next3 snapshot patche=
s,
>>> which apply on top of ext3 (or rather a forked branch of ext3 calle=
d next3).
>>> They are available for download at
>>> http://sourceforge.net/projects/next3/files/Latest%20patch%20series
>>> but I can also post them to the list if you like (about 40 medium s=
ize patches).
>> =A0Well, I can have a look at those patches. But I'd like to know wh=
at is
>> exactly your motivation - is it that you have some customers running=
 with
>> this clone and want to upstream the fs, or is it that you'd like to
>> contribute the cool feature you've developped, or something else?
>
> contribute cool feature is the best match.
>
>> Because on this depends where we should go from the current situatio=
n...
>> =A0To state my position: I'm not willing to merge the feature into e=
xt3
>> because it's basically in a maintenance mode so we don't accept larg=
er
>> features to it anymore (for stability reasons).
>
> of course.
>
>> =A0You could, of course, copy ext3 code base and create a separate n=
ext3
>> filesystem. But such code duplication would be generally frowned upo=
n and I
>> personally wouldn't like to take the burden of maintaining such code=
 so
>> you'd have to do it. Moreover you have to port all ext3 fixes to you=
r code
>> and you have a problem that as time progresses, new features are add=
ed to
>> ext4, not ext3, so I think it would be less and less attractive to r=
un
>> Next3 instead of ext4... So this doesn't seem like an ideal solution=
 either.
>
> you are not the first to tell me that the fork from ext3 is not a goo=
d idea.
> I agree that in the long term, Next3 as a file system driver has no p=
lace,
> but for practical reasons, I needed to create a separate file system =
driver,
> so people will be able to use the new feature without patching ext3 d=
uring
> the long time it will take me to merge the feature to ext4.
>
>
>> =A0For future, the most promising to me would be to change the
>> implementation to work with ext4 and merge it there. I understand th=
ere are
>> technical issues with this and I'm not sure how hard they would be t=
o
>> solve. But for me as a filesystem developper this would seem like a
>> direction where it's worth to invest some time and energy and I can =
help
>> with that (and I believe other ext4 developpers might lend a hand as=
 well).
>> =A0Just my thoughts...
>
> and the first step towards getting the snapshot feature into ext4 is
> for some ext3/4
> developers to review the patches, so I will have someone (rather some=
 than one)
> with whom I can discuss the merge issues.
> I actually proposed the next3 merge as a topic for LSF, but that
> didn't get much attention.
>
>> Anyway, I've added to my todo an item to have a look
>> at your patches so that I have better idea what we are discussing ab=
out.
>
> That would be great.
> If you like, we can schedule a call after you've gone through some of
> the patches/docs.
> I have done this with Ted and I think it's a good way to get started.
> if you haven't looked at http://sourceforge.net/apps/mediawiki/next3/
> that would be a good place to start (also links to the snapshots desi=
gn paper)
>
> Thanks for taking an interest,
> Amir.

So are you just asking for comments right now, or are you asking that
the e2fsprogs patches get applied?

Maybe a separate e2fsprogs branch for next3 should be created like
there was for the 64-bit patches?  (That would be Ted/Jan's call, not
mine.)

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
