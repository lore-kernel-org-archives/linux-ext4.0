From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: recursive mtime patches
Date: Thu, 14 Apr 2011 13:06:04 +0300
Message-ID: <BANLkTikcqixQzvH1GAM8uYQ-9DNERyLgqA@mail.gmail.com>
References: <BANLkTim6NYYnr+m4mqawSD4-Mbbzj699hQ@mail.gmail.com>
	<20110412154830.GF5246@quack.suse.cz>
	<BANLkTinO7G1YxZCP1-PXG5Nvyas=QdAunQ@mail.gmail.com>
	<20110413213937.GB4648@quack.suse.cz>
	<BANLkTi=NDb0U0z1C4UEE2oHvE8fVBVDp=Q@mail.gmail.com>
	<20110414092117.GB5054@quack.suse.cz>
	<BANLkTi==jFeJritNiwaA+vYgi6paqyQ_6g@mail.gmail.com>
	<20110414094930.GF5054@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53515 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668Ab1DNKGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 06:06:06 -0400
Received: by eyx24 with SMTP id 24so402813eyx.19
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 03:06:05 -0700 (PDT)
In-Reply-To: <20110414094930.GF5054@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2011 at 12:49 PM, Jan Kara <jack@suse.cz> wrote:
> On Thu 14-04-11 12:36:40, Amir Goldstein wrote:
>> On Thu, Apr 14, 2011 at 12:21 PM, Jan Kara <jack@suse.cz> wrote:
>> > On Thu 14-04-11 10:12:26, Amir Goldstein wrote:
>> >> On Thu, Apr 14, 2011 at 12:39 AM, Jan Kara <jack@suse.cz> wrote:
>> >> > On Wed 13-04-11 21:16:40, Amir Goldstein wrote:
>> >> >> On Tue, Apr 12, 2011 at 5:48 PM, Jan Kara <jack@suse.cz> wrote=
:
>> >> >> > modification stamps have possibly larger race windows but I =
haven't really
>> >> >> > tried how much (I just know that even mtime races are not th=
at hard to
>> >> >> > trigger if you try). So it really depends on how big reliabi=
lity do you
>> >> >> > expect and I personally don't find much value in just rescan=
ning and
>> >> >> > checking for mtime after a crash. Reading all the data and d=
oing checksum
>> >> >> > certainly has more value but at a high cost.
>> >> >> >
>> >> >>
>> >> >> What do you thing about the approach to store recursively modi=
fied dir inodes in
>> >> >> a journal "modified inode descriptor block" and update the rec=
ursive mtime of
>> >> >> those dirs on journal recovery?
>> >> > =A0The trouble is you don't know the number of directories that=
 may need
>> >> > to have timestamp updated - you find that out only as you trave=
l upwards.
>> >> > So it's hard to reserve any fixed space for this.
>> >> >
>> >>
>> >> True, but you can save *so* many inode numbers in just one descri=
ptor
>> >> block and in case of an overflow, we can just pass a hint to the =
top
>> >> level application to do a full directory scan, so I hardly see th=
at as a
>> >> big problem.
>> > =A0Well, about 1000 but you can still have about 8000 inodes modif=
ied in a
>> > transaction for a standard 128 MB journal. You can notify the user=
space
>> > when an overflow happens but the interface gets kind of ugly... Al=
so it
>> > would be only specific to ext3/4 while I'd prefer to get a wider f=
s
>> > support.
>>
>> Well, the persistent inode notification (by the way a feature provid=
ed by NTFS),
>> can be specific to ext4, but it can work together with a generic rec=
ursive mtime
>> code.
>> ext4 will simply touch directories during journal recovery.
>> other fs will only have the generic runtime recursive mtime.
> =A0But then applications cannot rely on the behavior and cannot take =
much
> benefit from it. Well, they could still ignore the risks and ext4 wou=
ld be
> nicer to them. But I'm not really sure what are you aiming at...

I am just aiming at making mtime (or recursive mtime) more reliable.
it may already be more reliable in other fs, so every fs can try to mak=
e it
more reliable internally.

>
>> >> >> I would also consider to use a mount option rec_mtime and then=
 just
>> >> >> store recursive
>> >> >> mtime in the directory's inode mtime instead of an extended at=
tribute.
>> >> >> That doesn't break any contract with user space, it's just a r=
e-interpretation
>> >> >> of the dir modification notion.
>> >> > =A0It breaks POSIX specification - POSIX pretty much specifies =
when mtime is
>> >> > supposed to be changed - so I'm not sure we really want to do t=
hat...
>> >>
>> >> I disagree, POSIX doesn't forbid a user space daemon from touchin=
g directory
>> >> inodes and updating their mtime. The rec_mtime feature should be =
treated as
>> >> a little kernel "daemon" which propagates information to user spa=
ce by touching
>> >> recursively modified directories.
>> > =A0OK, if you look at it this way it makes some sense. You loose t=
he
>> > distinction whether something has been created / deleted in the di=
rectory
>> > or whether only something happened in its subdirectory or file but=
 that
>> > does not seem too important for any use case I can think of.
>>
>> Personally, whenever I look at a dir mtime I would much rather I see
>> recursive mtime (I would much rather see recursive size as well but =
that
>> is too much to ask). =A0rsync can be easily modified to skipped enti=
re
>> directories if their (recursive) mtime hasn't changed. =A0I would li=
ke to
>> view dir (recursive) mtime using existing tools (from ls to folder
>> manager) and not use specialized tools that look at extended attribu=
tes,
>> but hey, that's just me :-)
> =A0That would be neat but note that even my patches don't provide com=
plete
> recursive mtime behavior. They just update the time stamp once and th=
en
> stop updating it until you ask about the update again. This makes the=
 whole
> framework really efficient for often modified directories but less us=
eful
> for cases like "I want to see time when something has changed in this
> subtree".
>
> But still I kind of like your idea of hijacking directory mtime/ctime=
 for
> these purposes because it would make several things simpler.

I have actually written a design that hijacks the dir atime for recursi=
ve
mtime, before you told me about your patches (my design deos not have
the one time modification trick).

The advantage of hijacking atime, it that few (if any) application rely=
 on it,
since it is not reliable with noatime.
But the greater advantage of hijacking mtime, is that it is persistent
in file systems where atime isn't (i.e. vfat).


>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
