From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext4: media error but where?
Date: Sun, 6 Jul 2014 23:37:11 +0200
Message-ID: <20140706213710.GA19847@amd.pavel.ucw.cz>
References: <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
 <20140704172104.GA4877@xo-6d-61-c0.localdomain>
 <20140704185626.GB11103@thunk.org>
 <20140706133247.GB18204@amd.pavel.ucw.cz>
 <20140706134325.GA18955@amd.pavel.ucw.cz>
 <20140706182936.GB471@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57401 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaGFVhO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jul 2014 17:37:14 -0400
Content-Disposition: inline
In-Reply-To: <20140706182936.GB471@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> > > Now I'm running fsck.new -cf. I don't think this filesystem has any
> > > bad blocks. Still, it says "rootfs: Updating bad block inode."
> > > ... "FILE SYSTEM WAS MODIFIED", "REBOOT LINUX".
> > 
> > And here's patch to fix this uglyness. Unfortunately, it makes it read
> > the inode... but perhaps it is good idea as we are able to print
> > before/after bad block counts...?
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> Thanks, I'll take a look at these patches.  Honestly, I've been half
> tempted to remove the e2fsck -c option entirely.  99.9% of the time,
> with modern disks, which has bad block remapping, it doesn't do any
> good, and often, it's harmful.

Well, when I got report about hw problems, badblocks -c was my first
instinct. On the usb hdd, the most errors were due to 3.16-rc1 kernel
bug, not real problems.

> In general, e2fsck -c is not something I recommend people use.  If you
> want to use badblocks by itself to see if there are any blocks that
> are suffering read problems, that's fine, but if there is, in
> general

Actually, badblocks is really tricky to use, I'd not trust myself to
get parameters right.

> the safest thing to do is to mount the disk read-only, back it up, and
> then either (a) reformat and see if you can restore onto it with
> backups w/o any further errors, or (b) just trash the disk, and get a
> new one, since in general the contents are way more valuable than the
> disk itself.  Certainly after trying (a), you get any further errors,
> (b) is defintely the way to go.

Well, 500GB disk takes a while to back up, plus you need the space. a)
will take few hours... And sometimes, data are much less valuable then
the HDD. I do have 2 copies of data I care about, using unison to keep
it in sync, and I plan to add 3rd, encrypted copy to Seagate Momentus
5400.6 series that failed (a). It seems that Seagate just got their
firmware wrong, while in thinkpad, the drive worked very much ok, with
exception with few sectors that could not be remapped. Now, USB
envelope seems to be much harsher evnironment for a HDD, and it has
few more bad sectors now, but that's somehow expected. I was not
treating the hdd as if it had valuable data.

So... please keep fsck -c :-).

[Actually, badblocks documentation leaves something to be desired.
Is ^C safe w.r.t. badblocks -n? Is hard poweroff safe?]

Thanks,
								Pavel

(Actually it looks I forgot to free the badlist. Incremental patch:)

diff --git a/e2fsck/badblocks.c b/e2fsck/badblocks.c
index 32e08bf..7ae7a61 100644
--- a/e2fsck/badblocks.c
+++ b/e2fsck/badblocks.c
@@ -60,8 +60,10 @@ void read_bad_blocks_file(e2fsck_t ctx, const char *bad_blocks_file,
 	}
 	old_bb_count = ext2fs_u32_list_count(bb_list);
 	printf("%s: Currently %d bad blocks.\n", ctx->device_name, old_bb_count);
-	if (replace_bad_blocks)
+	if (replace_bad_blocks) {
+	  	ext2fs_badblocks_list_free(bb_list);
 		bb_list = 0;
+	}
 
 	/*
 	 * Now read in the bad blocks from the file; if



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
