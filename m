From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] e2fsprogs: Fix how we treat user-spcified filesystem size
Date: Wed, 2 Feb 2011 12:56:21 -0500
Message-ID: <AANLkTi=5QWtEc+mRnveErm1AE4oLZAZwGOmLP69cx2dx@mail.gmail.com>
References: <1296587912-16756-1-git-send-email-lczerner@redhat.com>
 <140BFB14-31E6-4E76-B1DA-5CD8F54FDD5B@dilger.ca> <AANLkTimRMnceeWpTy6A3h_pEYLq_meAwjOHNOojmhuJR@mail.gmail.com>
 <alpine.LFD.2.00.1102021048230.3559@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65174 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab1BBR4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Feb 2011 12:56:42 -0500
Received: by iwn9 with SMTP id 9so214849iwn.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 Feb 2011 09:56:41 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1102021048230.3559@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 2, 2011 at 5:12 AM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> On Tue, 1 Feb 2011, Greg Freemyer wrote:
>
>> On Tue, Feb 1, 2011 at 3:37 PM, Andreas Dilger <adilger@dilger.ca> w=
rote:
>> > On 2011-02-01, at 12:18, Lukas Czerner wrote:
>> >> +Optionally, the
>> >> +.I filesystem-size
>> >> +parameter may be suffixed by one of the following the units
>> >> +designators: 'b', 's', 'K', 'M', or 'G',
>> >> +for blocks count, 512 byte sectors, kilobytes, megabytes, or gig=
abytes,
>> >> +respectively.
>> >
>> > My reading of parse_num_blocks() shows that 'T' is also accepted a=
s a suffix for terabytes, which I was otherwise going to suggest be add=
ed, since this is the normal size for filesystems today. =A0It might be=
 worthwhile _briefly_ mentioning here that these are binary/power-of-tw=
o values and not decimal values, instead of the rant further below.
>> >
>> > Minor technical nit - the proper metric value is lower-case 'k' fo=
r kilo, though the upper-case 'M', 'G', and 'T' are correct for mega-, =
giga-, and terabytes.
>>
>> <pedantic>
>> If they are powers of 2, they are: kibibytes, mebibytes, gibibytes,
>> and tebibytes.
>>
>> See the chart on the right of: http://en.wikipedia.org/wiki/Kibibyte
>>
>> Many linux tools have already moved to these names and abbreviations=
=2E
>> (TiB not TB, etc.)
>> <\pedantic>
>>
>> Greg
>>
>
> Right, that's why there is the "rant" about it being called kilobytes=
,
> but still treated as binary, not decimal unit. But Andreas is right
> that it is not necessary to have one paragraph grumbling about the
> stupid-sounding kibibytes and so on.
>
> So, what I am going to do is to cope with the standard and use those
> stupid-sounding binary prefixes (kibi- etc.), remove the "rant" and a=
dd
> one line note for people to be really sure that it is meant to be a
> binary unit.
>
> Thanks!
> -Lukas

Lukas,

I'm glad you did that.  I see too often:

=46disk is broken, I can only put a 150 gigabyte partition on my 160
gigabyte drive.

Hopefully people will realize the difference when they see its a 150
Gibibyte partition on a 160 Gigabyte drive.

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
