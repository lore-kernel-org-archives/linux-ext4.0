From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 7 Jun 2011 21:22:02 +0300
Message-ID: <BANLkTinaDyPyZn+GEnNcPrGA=HaTbiMvxw@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<4DEE4333.9@redhat.com>
	<BANLkTik74BM_TZin7rSXDRo1YftBsT-yYw@mail.gmail.com>
	<4DEE57C8.9090502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39303 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab1FGSWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 14:22:04 -0400
Received: by wwa36 with SMTP id 36so5225360wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 11:22:02 -0700 (PDT)
In-Reply-To: <4DEE57C8.9090502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 7, 2011 at 7:54 PM, Josef Bacik <josef@redhat.com> wrote:
> On 06/07/2011 12:46 PM, Amir G. wrote:
>> On Tue, Jun 7, 2011 at 6:26 PM, Josef Bacik <josef@redhat.com> wrote=
:
>>>
>>> I probably should have brought this up before, but why put all this
>>> effort into shoehorning in such a big an invasive feature to ext4 w=
hen
>>> btrfs does this all already? =A0Why not put your efforts into helpi=
ng
>>> btrfs become stable and ready and then use that, instead of having =
to
>>> come up with a bunch of hacks to get around the myriad of weird fea=
ture
>>> combinations you can get with ext4?
>>
>> Hi Josef,
>>
>> I understand the bitterness in btrfs community regarding ext4 snapsh=
ot
>> feature. You might say the same things about ext4 64bit feature.
>> I think it is not up to us to decide how it rolls. it's the users
>> and companies involved that dictate where the development happens.
>>
>
> Oh don't misunderstand me, I'm not bitter. =A0It just seems like this=
 is a
> lot of work for something you get for free with btrfs. =A0A lot of wo=
rk
> which I don't really think is justified when it comes to ext4.
>

Bitterness was a poor choice of expression.
Let me rephrase myself: I understand the wish of the btrfs community
that ext4 development would be focused on stabilization only
and that more developers would invest their time on stabilizing and
enhancing btrfs.

But there's the perfect world where everyone has migrated to btrfs
and there's real life, where sys admins are still hanging onto
ext3...

>> I like the answer that Ted once replied to the old btrfs vs. ext4 qu=
estion:
>> competition is good because it makes us modest.
>>
>> I believe there is room in the future for both fs's, even with
>> similar features in both.
>>
>>
>>
>>>
>>> The wonderful thing about ext4 is its a nice basic fs. =A0If we're =
going
>>> to start doing lots of crazy things, why not do them to the fs that
>>> isn't yet in wide use and can afford to have crazy things done to i=
t
>>> without screwing a bunch of users who already depend on ext4's
>>> stability? =A0Thanks,
>>>
>>
>> As I see it, stability is the *only* advantage of ext4 snapshots ove=
r btrfs
>> even though the snapshot feature is new and not stable, you still
>> have the good olf e2fsprogs tools that can get you out of any mess.
>> specifically, fsck -x will discard all snapshot files and make your =
ext4
>> fs clean and stable again.
>>
>> The repair tool is one thing that btrfs is still lacking, so I back =
CTERA's
>> decision to progress to ext4 with snapshots and not to btrfs on a
>> production system.
>>
>
> Sure, if you had spent time on a fsck tool for btrfs you would be don=
e
> by now ;).

Touche ;-)

However, one cannot fast forward 20(?) years of stabilization
of the extended fs on-disk format checking tools.
More over, I think there is a reason, beyond not finding one
developer, why btrfs repair tools have not been written yet.
The degrees of freedom in the rigid extended fs format allows fsck
to be very effective in rescuing most of the fs.
Btrfs, being a much bigger hammer that it is, with everything is a tree
and all, has more degrees of freedom, which makes it hard for
any repair tool (or sysadmin) to make the right decision.
And the fact that ext4 snapshots (almost) doesn't change the extended
on-disk format, because snapshot files are posing as regular sparse
files, is it's strongest (well only) advantage over btrfs at the
moment.

> I feel that ext4 is becoming a dumping ground for every ones
> pet project which is resulting in this weird frankenstien like fs tha=
t
> is growing organically, rather than a great, stable and all around
> useful file system. =A0Rather than cramming more crap into it, maybe =
we
> should evaluate whether the work is useful in the first place with
> things like btrfs or the dm snapshotting stuff exist. =A0Thanks,
>

And how exactly will we be making this evaluation?
There is no clear value for 'stable' that we can be used to compare
the alternatives.

Cheers,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
