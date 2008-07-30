From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4-patch-queue rebased to 2.6.26-rc1?
Date: Wed, 30 Jul 2008 15:04:12 -0400
Message-ID: <20080730190412.GC5347@mit.edu>
References: <3.0.6.32.20080730094639.01a69df8@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54680 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753464AbYG3TEc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2008 15:04:32 -0400
Content-Disposition: inline
In-Reply-To: <3.0.6.32.20080730094639.01a69df8@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 30, 2008 at 09:46:39AM +0000, Gary Hawco wrote:
> 
> The latest patch in the queue errors out with "patch already applied"
> error. I noticed that the patch from 073008/0301hrs GMT was rebased against
> 2.6.26-rc1, as opposed to what I think you meant, 2.6.27-rc1. I am sure
> this is why the newest patch from today @ 0339hrs fails to patch the
> 2.6.27-rc1 kernel source cleanly.

That was a typo in the series file, which I have since fixed and
pushed out, but I didn't need to change any of the patches; the
patches all applied to a clean 2.6.27-rc1 kernel, at least when I was
using the 2.6.27-rc1 from git and using "guilt push -a" to apply the
patches (which is how I normally do thigs.)  Do you know which patch
was giving the "patch already applied" error; how are you applying the
patches?

There was a problem in the patch queue that wasn't fixed until "Add
missing patch, ext4__update_documentation..." where the patch queue
was *missing* a patch due to me fumble fingering a git commit.  Maybe
that's what you ran into?  It's since been fixed....

> P.S. I have a minor, weird problem involving midnight commander in both
> Gentoo & Slackware that is also ext4-patch-queue related. The previous
> patch I was using from 071508/2315hrs was fine. I didn't want to use the
> git kernel, so I didn't update until the 072808/0005hrs GMT snapshot (Add
> documentation re: mke2fs.conf label). This snapshot (and presumably all
> newer ones add a continous row of symbols that resemble a nine (9) with a
> longer tail to the border, top & bottom, left & right to mc in both Gentoo
> & Slackware. This is while running in init3. It doesn't do it while running
> in kde and opening a console and then starting mc.

Does that occur with 2.6.27-rc1 without the ext4 patch queue?  That
sounds like terminfo problem or maybe some kind of console font issue.

What happens if you are running with X, and switching to the VC
console via cotrol-alt-f1, and then logging into the VC console?  I'm
not seeing it when I run mc from a vt console on my Ubuntu system,
which I assume is the same as what you are seeing when are using mc
under init 3 on Slackware.

					- Ted
