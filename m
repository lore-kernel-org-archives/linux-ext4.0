From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [RFC] Ext4 snapshots design challenges
Date: Wed, 27 Oct 2010 04:05:16 +0200
Message-ID: <AANLkTikWvrnBS-PVpOeOLz9WHFSAWq0B8KSTr5tYwLc9@mail.gmail.com>
References: <AANLkTim=4-uyczhhLOA79gsj7oHh=7O8f7ZiLMj3q3sB@mail.gmail.com>
	<AANLkTikGK8X-Tupdo0oqNe60DTyHRUB5svvBBiWwkytj@mail.gmail.com>
	<AANLkTikO8Mi+pfkb0U6WkCEOPd0ar4m+1auVdsf9uUhD@mail.gmail.com>
	<AANLkTinRrB1q7CSLs2POU36fygxe8CU5z8zNre6z9a3c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	next3-devel@lists.sourceforge.net
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34874 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab0J0CFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Oct 2010 22:05:16 -0400
Received: by qyk12 with SMTP id 12so3506566qyk.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Oct 2010 19:05:16 -0700 (PDT)
In-Reply-To: <AANLkTinRrB1q7CSLs2POU36fygxe8CU5z8zNre6z9a3c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 27, 2010 at 2:13 AM, Greg Freemyer <greg.freemyer@gmail.com=
> wrote:
> On Mon, Oct 25, 2010 at 12:05 PM, Amir G.
> <amir73il@users.sourceforge.net> wrote:
>> On Mon, Oct 25, 2010 at 5:24 PM, Greg Freemyer <greg.freemyer@gmail.=
com> wrote:
>>> Amir,
>>>
>>> I recently saw an announcement for X-Ways Forensics
>>> (http://www.x-ways.net/) that they now support next3 as a filesyste=
m
>>> to analyze. =A0See Oct. 10 msg under topic "Announcements: X-Ways
>>> Forensics 15.8" at http://www.winhex.net/ =A0(I think that is a pub=
lic
>>> posting board.)
>>>
>>> I was surprised to see that, but assuming it was indeed your projec=
t
>>> they added support for, I congratulate you on the above.
>>>
>>
>> Thanks! I guess :-)
>> I am pretty clueless with regards to the big players in the storage =
market.
>> I do not know X-Ways, but it looks like they are a big player.
>
>
> X-Ways is a computer forensic tool. =A0It is used to find evidence on
> computers. =A0(You might want to check my sig below.) =A0X-Ways is on=
e of
> the 3 biggest forensic suite vendors and their forensic app sells for
> about $1K. =A0(My company has 3 licenses.)
>
> A perfect situation for analysis of a next3 based filesystem would be
> if a contract had been fraudulently updated after it was signed and
> X-Ways was able to pull up older versions of the contract and prove
> the fraud.
>
> The fact that they took the time to recover documents out of a next3
> filesystem implies they thought next3 was deployed widely enough to b=
e
> worth the effort.
>
> I know they also add features for specific large customers, so it
> could simply be that a large client of their's asked them to add next=
3
> support for some internal reason.
>

That's very interesting. I sure hope that next3 (or better yet ext4 sna=
pshots)
will be widely deployed, but I am guessing that X-Ways are trying to
stay in sync
with latest libext2, so when Ted accepted the on-disk format changes to=
 libext2
a few months ago, they must have updated their library as well.

>>> I'm curious what level of support they offer. =A0In particular, the=
y
>>> only offer limited support for NTFS shadow copies, so I'm curious i=
f
>>> the next3 support is similarly limited.
>>>
>>> Or since next3 is GPL they may have been able to do a more
>>> comprehensive job with it than with ntfs shadow copies.
>>>
>>> Any info you have would be appreciated.
>>> Greg
>>>
>>
>> As you can figure out, I was not involved or notified about this mov=
e.
>> Judging from their release notes, I would say that the added support=
 is
>> mostly adding some information tags and verifying the correctness of=
 the
>> exclude bitmap:
>>
>> * Support for the Linux file system next3. The exclude bitmap inode
>> will be evaluated,
>> =A0and snapshot files are marked with (SF) in the Attribute column.
>> =A0Specialist license or higher required.
>
> But the ability to pull out snapshot files in an orderly fashion is
> the core functionality they could add from their perspective. =A0So
> while you may think this is basic, it means they took the time to
> decode your filesystem structure and pull out snapshot files. =A0Sinc=
e
> they don't actually use any of the GPL code (or at least I hope they
> don't, that means they had to develop the fs analyser just for next3.
> Not something I suspect can be done with limited effort.
>

The changes that next3 made to on-disk format of ext3 are minor:
http://sourceforge.net/apps/mediawiki/next3/index.php?title=3DOn-disk_f=
ormat
(and have already been pushed to mainline)

So if you have a code that decodes ext3 structures, be it GPL or not,
the effort required to decode next3 is very limited and it looks to me =
like
they have only invested that limited effort so far.

However, if any of you forensic developers out there hears me,
you should know that extracting a full snapshot image, or a snapshot
files report,
should be a trivial task if you have all the snapshot file structures d=
ecoded.

I was planning to implement something like e2image -r /dev/sda1@1,
but I am probably not going to get around to that in the near future.

> They do the same for NTFS shadow volumes, but even now the
> functionality is not complete enough they call it supported.
>
>> You shouldn't be too surprised to learn that the only file system
>> integrity test that
>> I have added in my e2fsprogs patches is verifying the correctness of
>> the exclude bitmap ;-)
>>
>> Thanks for the info and sorry if your post was rejected from next3-d=
evel.
>> I fixed the permissions for out of list posts.
>
> No problem
>
>> Amir.
>>
>
> Greg
> --
> Greg Freemyer
> Head of EDD Tape Extraction and Processing team
> Litigation Triage Solutions Specialist
> http://www.linkedin.com/in/gregfreemyer
> CNN/TruTV Aired Forensic Imaging Demo -
> =A0=A0 http://insession.blogs.cnn.com/2010/03/23/how-computer-evidenc=
e-gets-retrieved/
>
> The Norcross Group
> The Intersection of Evidence & Technology
> http://www.norcrossgroup.com
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
