From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Formatted/repartitioned wrong disk, arrgh!
Date: Fri, 6 Nov 2009 10:02:10 -0500
Message-ID: <87f94c370911060702n2a853934l816a6be3cb716f4a@mail.gmail.com>
References: <4AF3F82D.50105@elector.dk>
	 <87a8dc10911060249i16b6da5t21e916811938e5b5@mail.gmail.com>
	 <4AF40D60.1080503@elector.dk>
	 <87a8dc10911060357r27131f36r3351497b38e18a39@mail.gmail.com>
	 <20091106140415.GA26342@mit.edu> <1257518636.19442.8.camel@zwerg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Alexey Salmin <alexey.salmin@gmail.com>,
	Jesper Jensen <linux-ext4_mailinglist@elector.dk>,
	linux-ext4@vger.kernel.org
To: Alexey Fisher <bug-track@fisher-privat.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:45066 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbZKFPCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 10:02:05 -0500
Received: by iwn10 with SMTP id 10so826513iwn.4
        for <linux-ext4@vger.kernel.org>; Fri, 06 Nov 2009 07:02:10 -0800 (PST)
In-Reply-To: <1257518636.19442.8.camel@zwerg>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 6, 2009 at 9:43 AM, Alexey Fisher
<bug-track@fisher-privat.net> wrote:
> Am Freitag, den 06.11.2009, 09:04 -0500 schrieb Theodore Tso:
>> On Fri, Nov 06, 2009 at 05:57:14PM +0600, Alexey Salmin wrote:
>> > I think the only thing I can recommend to you is to "grep for your
>> > files and hope for the best" (c)
>> > I don't know any automated way to restore files after complete
>> > destroying of fs, but there always is grep and hexdump :)
>>
>> Unfortunately, there isn't much else that can be done, since the ino=
de
>> table has been zero'ed out.
>
> Do _not_ever_ change the disk after crush or what ever you did with i=
t.
> Make an image of your partition (dd if=3D/dev/you_partition
> of=3Dbackup_of_partition) and try testdisk (photoreck) and/or sleuthk=
it.
>
> =A0 =A0 =A0 =A0Alexey

Totally agree with Alexey, but if the virtual drive was using a file
and not a partition or full drive, then you can just make a copy of
the virtual drive.  Then try to recover from the copy.  Make more
copies as you have problems, etc.

If the inodes are gone (and likely they are), then the only other
option you have left is "data carving".

Data carving depends on having your files useing contiguous blocks.
With ext4 and files less than 128MB (one extent), there is a reasonble
chance I believe that they will be contiguous.

I use a professional ($) tool to data carve, but I'm pretty sure there
are some opensource tools out there.

The way the work is to scan all the sectors on the drive (of virtual
drive) and look for file header signatures.  A lot of complex file
types have those.  And then they either find the file length somehow
from the internal file header, or they just grab x bytes of contiguous
data after the header.

=46iles over 128 MB will use 2 ext4 extents and I don't think there is
much chance of the extents being contiguous.  Possibly Ted or Eric can
comment on that?

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Pap=
er -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html=
>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
