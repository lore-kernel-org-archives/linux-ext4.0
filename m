From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] mke2fs: use binary units in the man page
Date: Sun, 6 Feb 2011 20:01:36 -0500
Message-ID: <20110207010136.GD10402@thunk.org>
References: <1296643439-13908-1-git-send-email-lczerner@redhat.com>
 <1296643439-13908-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50381 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab1BGBBt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Feb 2011 20:01:49 -0500
Content-Disposition: inline
In-Reply-To: <1296643439-13908-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 02, 2011 at 11:43:59AM +0100, Lukas Czerner wrote:
> Decimal units (kilobyte 10^3, megabyte 10^6 etc...) were used in
> mke2fs manual page, however they was really meant to be binary units
> (kibibyte 2^10, mebibyte 2^20 etc...), so change the man pages to
> reflect that fact, even if it sounds weird.

Ugh.  Even Don Knuth agrees that the names sound stupid.  (Of course,
his proposal of MMB and GGB haven't really gained much traction,
either.)

I guess I'm willing to tolerate MiB and GiB, but since most people
will ignore the 'i' and pronounce them as "Megabyte" in everyday
speech.  I really don't want to see "mebibyte or tibibytes" spelled
out explicitly anywhere, though.  :-(

And I think KiB is just wierd; I'm much rather see "1024 byte blocks"
than see "1 KiB blocks".

Personally I think the names are doomed.  Even the editors for IEEE
and ANSI journals aren't enforcing this in style guidelines; memory
manufacturers are ignoring the IEC names entirely, and certain most
humans never use those names in every day speech.

       	     	       	     	      	  - Ted
