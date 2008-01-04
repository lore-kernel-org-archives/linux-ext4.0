From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h} from checkpatch.pl
Date: Fri, 04 Jan 2008 17:30:00 +0100
Message-ID: <p73hcht8sfr.fsf@bingen.suse.de>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
	<20080104134458.GE17436@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbYADQaH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jan 2008 11:30:07 -0500
In-Reply-To: <20080104134458.GE17436@mit.edu> (Theodore Tso's message of "Fri\, 4 Jan 2008 08\:44\:58 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> Coding-style only changes tends to screw up our ability to merge
> pending patches, but I'll take care of it, thanks.

Exactly. And looking at the patch the old code was already perfectly
readable anyways. Benefit about zero.

I also don't see how you can take care of patch conflicts caused by
this for patches not yet in your tree but still in development somewhere
else.

IMHO any coding style cleanup should only done on code that changes
anyways, but not on other code.

The recent flurry of cleanup code patches on l-k causes far more
problems than it solves. I'm not even sure why people do this? Just
because it is en vogue recently? 

If they want to contribute in simple ways to the Linux kernel I'm sure
actually really useful things can be found that they can change.

-Andi
