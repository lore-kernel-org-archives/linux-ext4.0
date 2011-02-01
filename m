From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsprogs: Fix how we treat user-spcified filesystem
 size
Date: Tue, 1 Feb 2011 22:08:08 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102012202460.3559@dhcp-lab-213.englab.brq.redhat.com>
References: <1296587912-16756-1-git-send-email-lczerner@redhat.com> <140BFB14-31E6-4E76-B1DA-5CD8F54FDD5B@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@MIT.EDU
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab1BAVIO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Feb 2011 16:08:14 -0500
In-Reply-To: <140BFB14-31E6-4E76-B1DA-5CD8F54FDD5B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 1 Feb 2011, Andreas Dilger wrote:

> On 2011-02-01, at 12:18, Lukas Czerner wrote:
> > +Optionally, the
> > +.I filesystem-size
> > +parameter may be suffixed by one of the following the units
> > +designators: 'b', 's', 'K', 'M', or 'G',
> > +for blocks count, 512 byte sectors, kilobytes, megabytes, or gigabytes,
> > +respectively.
> 
> My reading of parse_num_blocks() shows that 'T' is also accepted as a suffix for terabytes, which I was otherwise going to suggest be added, since this is the normal size for filesystems today.  It might be worthwhile _briefly_ mentioning here that these are binary/power-of-two values and not decimal values, instead of the rant further below.

The rant below was ripped of resize2fs man page, but I agree.

> 
> Minor technical nit - the proper metric value is lower-case 'k' for kilo, though the upper-case 'M', 'G', and 'T' are correct for mega-, giga-, and terabytes.

You're right, I completely missed 'T', will fix that. Regarding the
minor technical nit, I know that, but I have just ripped that from
resize2fs man page without really paying attention. Anyway thanks for
corrections I'll fix it as well.
> 
> > diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
> > --- a/resize/resize2fs.8.in
> > +++ b/resize/resize2fs.8.in
> > @@ -38,13 +38,13 @@ The
> > +designators: 'b', 's', 'K', 'M', or 'G',
> > +for blocks count, 512 byte sectors, kilobytes, megabytes, or gigabytes,
> > +respectively. The
> 
> Similarly, this also supports 'T' for terabytes, since it uses the same parse_num_blocks() function.
> 
> Cheers, Andreas
> 

Thanks!
-Lukas
