From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: recursive mtime patches
Date: Thu, 14 Apr 2011 12:36:40 +0300
Message-ID: <BANLkTi==jFeJritNiwaA+vYgi6paqyQ_6g@mail.gmail.com>
References: <BANLkTim6NYYnr+m4mqawSD4-Mbbzj699hQ@mail.gmail.com>
	<20110412154830.GF5246@quack.suse.cz>
	<BANLkTinO7G1YxZCP1-PXG5Nvyas=QdAunQ@mail.gmail.com>
	<20110413213937.GB4648@quack.suse.cz>
	<BANLkTi=NDb0U0z1C4UEE2oHvE8fVBVDp=Q@mail.gmail.com>
	<20110414092117.GB5054@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46131 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab1DNJgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Apr 2011 05:36:41 -0400
Received: by ewy4 with SMTP id 4so397431ewy.19
        for <linux-ext4@vger.kernel.org>; Thu, 14 Apr 2011 02:36:40 -0700 (PDT)
In-Reply-To: <20110414092117.GB5054@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 14, 2011 at 12:21 PM, Jan Kara <jack@suse.cz> wrote:
> On Thu 14-04-11 10:12:26, Amir Goldstein wrote:
>> On Thu, Apr 14, 2011 at 12:39 AM, Jan Kara <jack@suse.cz> wrote:
>> > On Wed 13-04-11 21:16:40, Amir Goldstein wrote:
>> >> On Tue, Apr 12, 2011 at 5:48 PM, Jan Kara <jack@suse.cz> wrote:
>> >> > modification stamps have possibly larger race windows but I hav=
en't really
>> >> > tried how much (I just know that even mtime races are not that =
hard to
>> >> > trigger if you try). So it really depends on how big reliabilit=
y do you
>> >> > expect and I personally don't find much value in just rescannin=
g and
>> >> > checking for mtime after a crash. Reading all the data and doin=
g checksum
>> >> > certainly has more value but at a high cost.
>> >> >
>> >>
>> >> What do you thing about the approach to store recursively modifie=
d dir inodes in
>> >> a journal "modified inode descriptor block" and update the recurs=
ive mtime of
>> >> those dirs on journal recovery?
>> > =A0The trouble is you don't know the number of directories that ma=
y need
>> > to have timestamp updated - you find that out only as you travel u=
pwards.
>> > So it's hard to reserve any fixed space for this.
>> >
>>
>> True, but you can save *so* many inode numbers in just one descripto=
r
>> block and in case of an overflow, we can just pass a hint to the top
>> level application to do a full directory scan, so I hardly see that =
as a
>> big problem.
> =A0Well, about 1000 but you can still have about 8000 inodes modified=
 in a
> transaction for a standard 128 MB journal. You can notify the userspa=
ce
> when an overflow happens but the interface gets kind of ugly... Also =
it
> would be only specific to ext3/4 while I'd prefer to get a wider fs
> support.

Well, the persistent inode notification (by the way a feature provided =
by NTFS),
can be specific to ext4, but it can work together with a generic recurs=
ive mtime
code.
ext4 will simply touch directories during journal recovery.
other fs will only have the generic runtime recursive mtime.

>
>> >> I would also consider to use a mount option rec_mtime and then ju=
st
>> >> store recursive
>> >> mtime in the directory's inode mtime instead of an extended attri=
bute.
>> >> That doesn't break any contract with user space, it's just a re-i=
nterpretation
>> >> of the dir modification notion.
>> > =A0It breaks POSIX specification - POSIX pretty much specifies whe=
n mtime is
>> > supposed to be changed - so I'm not sure we really want to do that=
=2E..
>>
>> I disagree, POSIX doesn't forbid a user space daemon from touching d=
irectory
>> inodes and updating their mtime. The rec_mtime feature should be tre=
ated as
>> a little kernel "daemon" which propagates information to user space =
by touching
>> recursively modified directories.
> =A0OK, if you look at it this way it makes some sense. You loose the
> distinction whether something has been created / deleted in the direc=
tory
> or whether only something happened in its subdirectory or file but th=
at
> does not seem too important for any use case I can think of.

Personally, whenever I look at a dir mtime I would much rather I see
recursive mtime
(I would much rather see recursive size as well but that is too much to=
 ask).
rsync can be easily modified to skipped entire directories if their
(recursive) mtime
hasn't changed.
I would like to view dir (recursive) mtime using existing tools (from
ls to folder manager)
and not use specialized tools that look at extended attributes,
but hey, that's just me :-)


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
