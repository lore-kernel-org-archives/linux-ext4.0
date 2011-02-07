From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] mke2fs: use binary units in the man page
Date: Mon, 7 Feb 2011 12:10:01 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102071154360.3927@dhcp-27-109.brq.redhat.com>
References: <1296643439-13908-1-git-send-email-lczerner@redhat.com> <1296643439-13908-2-git-send-email-lczerner@redhat.com> <20110207010136.GD10402@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	adilger@dilger.ca
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1BGLKI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 06:10:08 -0500
In-Reply-To: <20110207010136.GD10402@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Sun, 6 Feb 2011, Ted Ts'o wrote:

> On Wed, Feb 02, 2011 at 11:43:59AM +0100, Lukas Czerner wrote:
> > Decimal units (kilobyte 10^3, megabyte 10^6 etc...) were used in
> > mke2fs manual page, however they was really meant to be binary units
> > (kibibyte 2^10, mebibyte 2^20 etc...), so change the man pages to
> > reflect that fact, even if it sounds weird.
> 
> Ugh.  Even Don Knuth agrees that the names sound stupid.  (Of course,
> his proposal of MMB and GGB haven't really gained much traction,
> either.)
> 
> I guess I'm willing to tolerate MiB and GiB, but since most people
> will ignore the 'i' and pronounce them as "Megabyte" in everyday
> speech.  I really don't want to see "mebibyte or tibibytes" spelled
> out explicitly anywhere, though.  :-(
> 
> And I think KiB is just wierd; I'm much rather see "1024 byte blocks"
> than see "1 KiB blocks".

Hi Ted,

Fail enough, I'll avoid spelling "mebibytes or tebibytes" and use the
abbreviations instead if you insist on it :)

> 
> Personally I think the names are doomed.  Even the editors for IEEE
> and ANSI journals aren't enforcing this in style guidelines; memory
> manufacturers are ignoring the IEC names entirely, and certain most
> humans never use those names in every day speech.
> 
>        	     	       	     	      	  - Ted

-Lukas
