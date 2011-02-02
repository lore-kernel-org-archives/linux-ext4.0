From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsprogs: Fix how we treat user-spcified filesystem
 size
Date: Wed, 2 Feb 2011 11:12:44 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102021048230.3559@dhcp-lab-213.englab.brq.redhat.com>
References: <1296587912-16756-1-git-send-email-lczerner@redhat.com> <140BFB14-31E6-4E76-B1DA-5CD8F54FDD5B@dilger.ca> <AANLkTimRMnceeWpTy6A3h_pEYLq_meAwjOHNOojmhuJR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571140353-1313899754-1296641568=:3559"
Cc: Andreas Dilger <adilger@dilger.ca>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab1BBKMw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Feb 2011 05:12:52 -0500
In-Reply-To: <AANLkTimRMnceeWpTy6A3h_pEYLq_meAwjOHNOojmhuJR@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571140353-1313899754-1296641568=:3559
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 1 Feb 2011, Greg Freemyer wrote:

> On Tue, Feb 1, 2011 at 3:37 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> > On 2011-02-01, at 12:18, Lukas Czerner wrote:
> >> +Optionally, the
> >> +.I filesystem-size
> >> +parameter may be suffixed by one of the following the units
> >> +designators: 'b', 's', 'K', 'M', or 'G',
> >> +for blocks count, 512 byte sectors, kilobytes, megabytes, or gigabytes,
> >> +respectively.
> >
> > My reading of parse_num_blocks() shows that 'T' is also accepted as a suffix for terabytes, which I was otherwise going to suggest be added, since this is the normal size for filesystems today.  It might be worthwhile _briefly_ mentioning here that these are binary/power-of-two values and not decimal values, instead of the rant further below.
> >
> > Minor technical nit - the proper metric value is lower-case 'k' for kilo, though the upper-case 'M', 'G', and 'T' are correct for mega-, giga-, and terabytes.
> 
> <pedantic>
> If they are powers of 2, they are: kibibytes, mebibytes, gibibytes,
> and tebibytes.
> 
> See the chart on the right of: http://en.wikipedia.org/wiki/Kibibyte
> 
> Many linux tools have already moved to these names and abbreviations.
> (TiB not TB, etc.)
> <\pedantic>
> 
> Greg
> 

Right, that's why there is the "rant" about it being called kilobytes,
but still treated as binary, not decimal unit. But Andreas is right
that it is not necessary to have one paragraph grumbling about the
stupid-sounding kibibytes and so on.

So, what I am going to do is to cope with the standard and use those
stupid-sounding binary prefixes (kibi- etc.), remove the "rant" and add
one line note for people to be really sure that it is meant to be a
binary unit.

Thanks!
-Lukas
--571140353-1313899754-1296641568=:3559--
