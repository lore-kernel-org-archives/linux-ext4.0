Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:36204 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbeK3D5N (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Nov 2018 22:57:13 -0500
Received: by mail-it1-f195.google.com with SMTP id c9so4699961itj.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Nov 2018 08:51:12 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2] ext2fs: don't read group descriptors during e2label
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
In-Reply-To: <20181129041014.GJ31885@thunk.org>
Date: Thu, 29 Nov 2018 19:51:07 +0300
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CBF8337C-12EF-4F8D-A407-E49AFE0659B9@gmail.com>
References: <20181128204840.4544-1-artem.blagodarenko@gmail.com>
 <20181129041014.GJ31885@thunk.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Andreas, Darric, Ted,

Thanks for review.=20

> Might want to remove this ^^^^^ commented out line too=E2=80=A6

The answer is bellow in this letter.

> On 29 Nov 2018, at 07:10, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>=20
> On Wed, Nov 28, 2018 at 11:48:40PM +0300, Artem Blagodarenko wrote:
>> tune2fs is used to make e2label duties.  ext2fs_open2() reads group
>> descriptors which are not used during disk label obtaining, but
>> takes a lot of time on large partitions.
>=20
> Are you trying to speed up using e2label to *read* the label, or
> e2label to *write* the label?  How often do you need to write the
> label, and do you need to write the label with a dirty journal?
>=20
> I really don't like this patch because it makes the
> EXT2_FLAG_JOURNAL_ONLY flag an **extremely** hazardous flag to use.
> If the application uses it wrong, it could lead to extremely serious,
> disastrous data loss.
>=20
> In fact, I'm going to guess that you only care about reading the
> label, and you didn't even test using "tune2fs -L new_label
> /dev/large_file_system_with_precious_data".  Because if you did, the
> tune2fs -L would call ext2fs_mark_super_dirty(), and then
> ext2fs_close() would call ext2fs_flushfs(), which would write out all
> of the block groups, writing uninitialized trash into all of the block
> group descriptor blocks beyond the first one, and your large
> production file system would be very sad.
>=20
> So, ah, NACK.  :-)

 I am care about reading and writing. It is quite common operations =
during cluster setup, start and operation.
 Tune2fs reads superblock, journal block, fix or return label and =
terminates.

The only thing I am worry  is a journaling. Journal can be replied. That =
can lead to flushing uninitialised data.
To solve this problem I added string Darric asked for.

> +		/* don't want metadata to be flushed at close */
> +		//open_flag &=3D ~EXT2_FLAG_RW;

This fixes flushing uninitialised data problem on label reading =
codepath, but
brakes t_replay_and_set test.

-Recovering journal.
 fsck the whole mess
+test_filesys: recovering journal

Also, I just noticed it brakes label applying.

Now I understand that patch is completely bad. I would drop it and write =
it other way.

> If what you care about is "print label" case, what I would suggest is
> a new interface which simply reads the superblock into a struct
> ext2_super_block and calls ext2fs_swap_super() on it.  This will speed
> up the e2label read case.
>=20
> If you want to speed up the e2label write case when the file system is
> cleanly unmounted, we could have a new interface that writes out the
> superblock, and tune2fs would use it if the file system does not need
> to have a journal replay.  But if the journal does need to be
> replayed, we would need to do a full ext2fs_open2() call.

Thanks. This is good idea for new patch.

>=20
> When designing library interfaces, it's always important to imagine
> how an well-meaning programmer calling them might misuse them.
> Leaving land-mines for programmers to trip over --- especially when
> you trip over them yourself in the same patch which introduces the
> interfaces --- is just not a nice thing to do.  For your amusement,
> I'll leave you with:
>=20
> Rusty Rusell's writeup, "How Do I Make This Hard to Misuse":
>=20
>   https://ozlabs.org/~rusty/index.cgi/tech/2008-03-30.html
>=20
> And the flip side, his "What If I Don't Actually Like My Users?"
>=20
>   https://ozlabs.org/~rusty/index.cgi/tech/2008-04-01.html

Thanks for links. I have read it. Very useful.=20
Now I know that e2label -> tune2fs link brakes "The obvious use is =
(probably) the correct one=E2=80=9D rule.=20
I didn=E2=80=99t expect that e2label is not really utility in my system =
(despite there are sources in tree), but link to tune2fs, then faced =
with long label acquiring first time.
But probably I have wrong expectations.

>=20
> 						- Ted

Best regards,
Artem Blagodarenko.
=09=
