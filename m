From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC] Ext4 snapshots design challenges
Date: Tue, 26 Oct 2010 20:13:34 -0400
Message-ID: <AANLkTinRrB1q7CSLs2POU36fygxe8CU5z8zNre6z9a3c@mail.gmail.com>
References: <AANLkTim=4-uyczhhLOA79gsj7oHh=7O8f7ZiLMj3q3sB@mail.gmail.com>
 <AANLkTikGK8X-Tupdo0oqNe60DTyHRUB5svvBBiWwkytj@mail.gmail.com> <AANLkTikO8Mi+pfkb0U6WkCEOPd0ar4m+1auVdsf9uUhD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	next3-devel@lists.sourceforge.net
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35027 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0J0AN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Oct 2010 20:13:56 -0400
Received: by iwn10 with SMTP id 10so94907iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 26 Oct 2010 17:13:56 -0700 (PDT)
In-Reply-To: <AANLkTikO8Mi+pfkb0U6WkCEOPd0ar4m+1auVdsf9uUhD@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 25, 2010 at 12:05 PM, Amir G.
<amir73il@users.sourceforge.net> wrote:
> On Mon, Oct 25, 2010 at 5:24 PM, Greg Freemyer <greg.freemyer@gmail.c=
om> wrote:
>> Amir,
>>
>> I recently saw an announcement for X-Ways Forensics
>> (http://www.x-ways.net/) that they now support next3 as a filesystem
>> to analyze. =A0See Oct. 10 msg under topic "Announcements: X-Ways
>> Forensics 15.8" at http://www.winhex.net/ =A0(I think that is a publ=
ic
>> posting board.)
>>
>> I was surprised to see that, but assuming it was indeed your project
>> they added support for, I congratulate you on the above.
>>
>
> Thanks! I guess :-)
> I am pretty clueless with regards to the big players in the storage m=
arket.
> I do not know X-Ways, but it looks like they are a big player.


X-Ways is a computer forensic tool.  It is used to find evidence on
computers.  (You might want to check my sig below.)  X-Ways is one of
the 3 biggest forensic suite vendors and their forensic app sells for
about $1K.  (My company has 3 licenses.)

A perfect situation for analysis of a next3 based filesystem would be
if a contract had been fraudulently updated after it was signed and
X-Ways was able to pull up older versions of the contract and prove
the fraud.

The fact that they took the time to recover documents out of a next3
filesystem implies they thought next3 was deployed widely enough to be
worth the effort.

I know they also add features for specific large customers, so it
could simply be that a large client of their's asked them to add next3
support for some internal reason.

>> I'm curious what level of support they offer. =A0In particular, they
>> only offer limited support for NTFS shadow copies, so I'm curious if
>> the next3 support is similarly limited.
>>
>> Or since next3 is GPL they may have been able to do a more
>> comprehensive job with it than with ntfs shadow copies.
>>
>> Any info you have would be appreciated.
>> Greg
>>
>
> As you can figure out, I was not involved or notified about this move=
=2E
> Judging from their release notes, I would say that the added support =
is
> mostly adding some information tags and verifying the correctness of =
the
> exclude bitmap:
>
> * Support for the Linux file system next3. The exclude bitmap inode
> will be evaluated,
> =A0and snapshot files are marked with (SF) in the Attribute column.
> =A0Specialist license or higher required.

But the ability to pull out snapshot files in an orderly fashion is
the core functionality they could add from their perspective.  So
while you may think this is basic, it means they took the time to
decode your filesystem structure and pull out snapshot files.  Since
they don't actually use any of the GPL code (or at least I hope they
don't, that means they had to develop the fs analyser just for next3.
Not something I suspect can be done with limited effort.

They do the same for NTFS shadow volumes, but even now the
functionality is not complete enough they call it supported.

> You shouldn't be too surprised to learn that the only file system
> integrity test that
> I have added in my e2fsprogs patches is verifying the correctness of
> the exclude bitmap ;-)
>
> Thanks for the info and sorry if your post was rejected from next3-de=
vel.
> I fixed the permissions for out of list posts.

No problem

> Amir.
>

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
=A0=A0 http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-=
gets-retrieved/

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
