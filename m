From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h}
 from checkpatch.pl
Date: Sat, 5 Jan 2008 22:24:53 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801052223270.14194@fbirervta.pbzchgretzou.qr>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
 <20080104134458.GE17436@mit.edu> <p73hcht8sfr.fsf@bingen.suse.de>
 <20080104190137.GJ17436@mit.edu> <20080104194129.GA16962@one.firstfloor.org>
 <4d8e3fd30801041203s2f017f20ld9fcbc82912468fe@mail.gmail.com>
 <20080104223328.GB19248@one.firstfloor.org>
 <4d8e3fd30801041612k2b4aaab1yee2be5eec03e9f07@mail.gmail.com>
 <20080105003951.GM17436@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34681 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975AbYAEVYz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2008 16:24:55 -0500
In-Reply-To: <20080105003951.GM17436@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jan 4 2008 19:39, Theodore Tso wrote:
>On Sat, Jan 05, 2008 at 01:12:44AM +0100, Paolo Ciarrocchi wrote:
>
>But because running some kind of mechanical script and fixing up the
>problems is relatively mindless, it doesn't *add* anything.  Only the
>maintainer knows when it is a reasonably convenient time to fix all of
>the problems, or when to fix portions of the code that is being
>reworked anyway --- and the maintainer can just run the script by
>himself, for himself.

I have to agree. Best use of checkpatch is right before submitting, uh,
a patch actually. The option that makes it work on non-patch files
should be, hm, hidden or removed.
