From: tytso@mit.edu
Subject: Re: [PATCH] ext4: initialize multi-block allocator before checking
 block descriptors
Date: Sun, 16 Mar 2014 22:00:30 -0400
Message-ID: <20140317020029.GC14162@thunk.org>
References: <20140315214029.GA18873@thunk.org>
 <CAG5DWoj0pYD8O17qw_-MK+JX_hsFj04ReUPztShmKWzz45gRbQ@mail.gmail.com>
 <20140316023841.GA902@thunk.org>
 <CAG5DWog0BDHTh1edtQ+457SmJeL_0MacgZ1gYeNL4sY4yEqZWw@mail.gmail.com>
 <20140316161637.GA19885@azat>
 <20140316184634.GA14162@thunk.org>
 <20140316205659.GC19885@azat>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: a3at.mail@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42303 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbaCQCAe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Mar 2014 22:00:34 -0400
Content-Disposition: inline
In-Reply-To: <20140316205659.GC19885@azat>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 17, 2014 at 12:56:59AM +0400, a3at.mail@gmail.com wrote:
> After I tested ext4 dev branch (eb3e7abb161ad5), without any xfs-tests complaints,
> I understand what goes wrong, you have not last version of
> this patch, the latest is v3.
> (Actually you have description from last patch, but not the latest changes.)

What I did was to take your v3 version of the patch, and then since
that patch removed the label failed_mount5, I changed instances of
failed_mount4a to failed_mount5, just for aesthetic reasons.

So there is no substantive difference between what is in the ext4
patch queue and your v3 patch.   All I did was this:

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d73f1d9..01c5088 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4100,14 +4100,14 @@ no_journal:
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to reserve %llu clusters for "
 			 "reserved pool", ext4_calculate_resv_clusters(sb));
-		goto failed_mount4a;
+		goto failed_mount5;
 	}
 
 	err = ext4_setup_system_zone(sb);
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize system "
 			 "zone (%d)", err);
-		goto failed_mount4a;
+		goto failed_mount5;
 	}
 
 	err = ext4_register_li_request(sb, first_not_zeroed);
@@ -4184,7 +4184,7 @@ failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
 	ext4_release_system_zone(sb);
-failed_mount4a:
+failed_mount5:
 	dput(sb->s_root);
 	sb->s_root = NULL;
 failed_mount4:


Did you actually test your v3 patch on top of the dev branch?  Or did
you just note that the patch in the ext4 patch queue was different,
and assumed it was the v2 version of your patch?

Regards,

						- Ted
