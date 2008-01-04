From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h}
	from checkpatch.pl
Date: Fri, 4 Jan 2008 14:01:37 -0500
Message-ID: <20080104190137.GJ17436@mit.edu>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <20080104134458.GE17436@mit.edu> <p73hcht8sfr.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44126 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753337AbYADTBq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2008 14:01:46 -0500
Content-Disposition: inline
In-Reply-To: <p73hcht8sfr.fsf@bingen.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 04, 2008 at 05:30:00PM +0100, Andi Kleen wrote:
> 
> Exactly. And looking at the patch the old code was already perfectly
> readable anyways. Benefit about zero.

File this under the "checkpatch.pl" considered harmful category....
The problem is not with the tool, but that at least *some* people seem
to think that making checkpatch.pl be completely silent is somehow
this holy grail that will make kernel code bug-free(tm).  (And of
course, people who want to encode nazi-like coding conventions and to
force all of the kernel to use a single coding convention as if that
somehow would improve the kernel's quality.  Some of that is OK, but
as long as the code is readable, do we really care about whether or
not the code is using exactly the same coding conventions everyplace?
Or, pressuring maintainers not to ignore cleanup patches lest they be
viewed as "bad" maintainers?)

Personally I find it annoying, but I'm willing to live with the
cleanup patches.  I don't think they add anything, though.  Maybe I
should be more cranky about such patches....

> The recent flurry of cleanup code patches on l-k causes far more
> problems than it solves. I'm not even sure why people do this? Just
> because it is en vogue recently? 

I don't know, because people want to be able to say that they've
contributed fixes to the Linux kernel?

I will say that in past kernel summit program commitees, the
perception that someone _only_ submitted trivial patches (i.e.,
whitespace-only, spelling fixes in comments, etc.) has sometimes been
perceived a negative factor towards whether the program committee
might consider that person to be useful contributor to discussions at
the kernel summit....  So people should be warned (I would have hoped
that it would be obvious), that submitting vast number of trivial
cleanup patches without contributing anything else will very likely
not work, and possibly backfire if that is your goal.

							- Ted
