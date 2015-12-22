From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Subject: Re: [PATCH 1/6] mbcache2: Reimplement mbcache
Date: Tue, 22 Dec 2015 14:16:28 +0100
Message-ID: <CAHpGcMLibLH5g7nJ4624Dd-bgLx_dp3FOVzmufOqPGihYDsGRQ@mail.gmail.com>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
	<1449683858-28936-2-git-send-email-jack@suse.cz>
	<CAHpGcMJ_gWOTt89E9RnxSY4-yhdU_OQ14Jb5gJvETzQ_NXvXmA@mail.gmail.com>
	<20151215110809.GA1899@quack.suse.cz>
	<20151216155209.GD16918@quack.suse.cz>
	<CAHpGcMLWgiJ9-9onrYPowoMMgDHbsyLSyZ2wXp4RSRtmUeTgEw@mail.gmail.com>
	<20151222130752.GB7266@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38693 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbLVNQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Dec 2015 08:16:29 -0500
Received: by mail-wm0-f45.google.com with SMTP id l126so111188516wml.1
        for <linux-ext4@vger.kernel.org>; Tue, 22 Dec 2015 05:16:29 -0800 (PST)
In-Reply-To: <20151222130752.GB7266@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2015-12-22 14:07 GMT+01:00 Jan Kara <jack@suse.cz>:
> On Tue 22-12-15 13:20:58, Andreas Gr=C3=BCnbacher wrote:
>> 2015-12-16 16:52 GMT+01:00 Jan Kara <jack@suse.cz>:
>> > On Tue 15-12-15 12:08:09, Jan Kara wrote:
>> >> > > +/*
>> >> > > + * mb2_cache_entry_delete - delete entry from cache
>> >> > > + * @cache - cache where the entry is
>> >> > > + * @entry - entry to delete
>> >> > > + *
>> >> > > + * Delete entry from cache. The entry is unhashed and delete=
d from the lru list
>> >> > > + * so it cannot be found. We also drop the reference to @ent=
ry caller gave us.
>> >> > > + * However entry need not be freed if there's someone else s=
till holding a
>> >> > > + * reference to it. Freeing happens when the last reference =
is dropped.
>> >> > > + */
>> >> > > +void mb2_cache_entry_delete(struct mb2_cache *cache,
>> >> > > +                           struct mb2_cache_entry *entry)
>> >> >
>> >> > This function should become static; there are no external users=
=2E
>> >>
>> >> It's actually completely unused. But if we end up removing entrie=
s for
>> >> blocks where refcount hit maximum, then it will be used by the fs=
=2E Thinking
>> >> about removal of entries with max refcount, the slight complicati=
on is that
>> >> when refcount decreases again, we won't insert the entry in cache=
 unless
>> >> someone calls listattr or getattr for inode with that block. So w=
e'll
>> >> probably need some more complex logic to avoid this.
>> >>
>> >> I'll first gather some statistics on the lengths of hash chains a=
nd hash
>> >> chain scanning when there are few unique xattrs to see whether th=
e
>> >> complexity is worth it.
>> >
>> > So I did some experiments with observing length of hash chains wit=
h lots of
>> > same xattr blocks. Indeed hash chains get rather long in such case=
 as you
>> > expected - for F files having V different xattr blocks hash chain =
lenght is
>> > around F/V/1024 as expected.
>> >
>> > I've also implemented logic that removes entry from cache when the=
 refcount
>> > of xattr block reaches maximum and adds it back when refcount drop=
s. But
>> > this doesn't make hash chains significantly shorter because most o=
f xattr
>> > blocks end up close to max refcount but not quite at the maximum (=
as the
>> > benchmark ends up adding & removing references to blocks mostly
>> > randomly).
>> >
>> > That made me realize that any strategy based solely on xattr block=
 refcount
>> > isn't going to significantly improve the situation.
>>
>> That test scenario probably isn't very realistic: xattrs are mostly
>> initialized at or immediately after file create time; they rarely
>> removed. Hash chains should shrink significantly for that scenario.
>
> Well, the refcount gets dropped when the file itself is deleted. And =
that
> isn't that rare. So I agree my benchmark isn't completely realistic i=
n
> changing the xattr but dropping xattr block refcount due to deleted f=
ile
> will be relatively frequent so I don't thing refcount distribution ob=
tained
> by my benchmark is completely out.

Good point.

>> In addition, if the hash table is sized reasonably, long hash chains
>> won't hurt that much because we can stop searching them as soon as w=
e
>> find the first reusable block. This won't help when there are hash
>> conflicts, but those should be unlikely.
>
> Well, this is what happens currently as well...

Yes, except that many "unshareable" xattr blocks can remain in the
hash table where they can only be skipped over. Since you have already
written the code for fixing that and that fix won't make things worse,
I would like to see that go in.

Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
