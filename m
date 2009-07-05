From: Roland Dreier <roland@digitalvampire.org>
Subject: Re: ext4 lockdep report re possible reclaim deadlock on jbd2_handle
Date: Sun, 05 Jul 2009 12:10:00 -0700
Message-ID: <87ocrzndyv.fsf@shaolin.home.digitalvampire.org>
References: <87prcgp19p.fsf@shaolin.home.digitalvampire.org>
	<20090705124333.GA6757@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:58875 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbZGETKK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Jul 2009 15:10:10 -0400
In-Reply-To: <20090705124333.GA6757@mit.edu> (Theodore Tso's message of "Sun, 5 Jul 2009 08:43:33 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 > What seems to be happening here is the ecryptfs is holding the file
 > open, because of the upper dentry reference.  So that's not a normal
 > thing, and maybe that's why most people haven't noticed the problem;
 > they're not doing enough with ecryptfs to trigger things.

Makes sense -- yes, I should have mentioned that I am using the Ubuntu
"$HOME on ecryptfs" feature; and also I had to fix 3 lockdep warnings
with ecryptfs before I hit this one.  Still haven't caught the issue
with my own module code that I'm actually trying to debug :)

 > How easily can you reproduce the lockdep warning?  Does this patch
 > (not tested; sorry, am in the Berkshires for the July 4th holiday)
 > make it go away?

It's not very reproducible, I don't think; although I've just been
running with lockdep for about a week or so, and as I said I had to
work through 3 ecryptfs false positives before I got to this.  I think
I triggered this while building a new kernel, and I haven't done that
since, so it may be reproducible, but I'm not sure.

In any case, I'd be surprised if:

-	page = grab_cache_page(mapping, from >> PAGE_CACHE_SHIFT);
+	page = find_or_create_page(mapping, from >> PAGE_CACHE_SHIFT,
+				   mapping_gfp_mask(mapping) & ~__GFP_FS);

doesn't get rid of the warning, and it looks like a good fix, although
I wonder if for a real upstream patch we wouldn't want to add a new
grab_cache_page()-like wrapper that does the "& ~__GFP_FS" --
grab_cache_page_nowait() isn't quite what's wanted here I don't think,
but something like that.

Anyway, I'll add this patch to my kernel and let you know if anything
ext4-related pops up.

Thanks,
  Roland
-- 
Roland Dreier  <roland@digitalvampire.org>  GPG Key: 1024D/E0EEFAC0
Fingerprint:     A89F B5E9 C185 F34D BD50  4009 37E2 25CC E0EE FAC0

 Sending >500KB attachments is forbidden by the Geneva Convention.
        Your country may be at risk if you fail to comply.
