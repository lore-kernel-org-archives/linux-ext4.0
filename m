From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Wed, 23 Apr 2014 10:36:42 -0400
Message-ID: <20140423143642.GA29925@thunk.org>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
 <20140423072311.GD10163@dot.freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sander Smeenk <ssmeenk@freshdot.net>,
	Nathaniel W Filardo <nwf@cs.jhu.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56472 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbaDWOgv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2014 10:36:51 -0400
Content-Disposition: inline
In-Reply-To: <20140423072311.GD10163@dot.freshdot.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK, with the two of you reporting this problem, can you do me the
following so we can try to seriously dig into this:

First, of all, can you go through your log files and find me as many
instances of these two pairs of ext4 error messges:

EXT4-fs (vdd): pa ffff88000dea9b90: logic 0, phys. 1934464544, len 32
EXT4-fs error (device vdd): ext4_mb_release_inode_pa:3729: group 59035, free 14, pa_free 12

I want to see if there's any pattern in the physical block number (in
the two samples I have, they are always fairly large numbers), and in
the difference between the free and pa_free numbers.  

Secondly, can you send me the output of dumpe2fs -h for the file
systems in question.

Finally, since the both of you are seeing these messages fairly
frequently, would you be willing to run with a patched kernel?
Specifically, can you add a WARN_ON(1) to fs/ext4/mballoc.c here:

	if (free != pa->pa_free) {
		ext4_msg(e4b->bd_sb, KERN_CRIT,
			 "pa %p: logic %lu, phys. %lu, len %lu",
			 pa, (unsigned long) pa->pa_lstart,
			 (unsigned long) pa->pa_pstart,
			 (unsigned long) pa->pa_len);
		ext4_grp_locked_error(sb, group, 0, 0, "free %u, pa_free %u",
					free, pa->pa_free);
		WARN_ON(1); <---------------- add this line			
		/*
		 * pa is already deleted so we use the value obtained
		 * from the bitmap and continue.
		 */
	}

Then when it triggers, can you send me the stack trace that will be
triggered by the WARN_ON.

The two really interesting commonalities which I've seen so far is:

1)  You are both using virtualization via qemu/kvm

2)  You are both using file systems > 8TB.

Yes?  And Sander, you're not using a remote block device, correct?
You're using a local disk to back the large fileystem on the host OS
side?

Cheers,

					- Ted
