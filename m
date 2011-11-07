From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bug In ext4 in kernels > 2.6.39 - Not mounting with
 arguments/options I specify in fstab on root remount
Date: Mon, 7 Nov 2011 10:47:59 -0500
Message-ID: <20111107154759.GB24234@thunk.org>
References: <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com>
 <4E6F6D89.5040905@redhat.com>
 <CABeR260PEDEF1cyX5JPs3VC0hpThmKNtDAhDd-sPDZ2grtL+=g@mail.gmail.com>
 <20111009234433.GU7948@thunk.org>
 <4EA0E72D.8020305@gmail.com>
 <20111022050031.GC4196@thunk.org>
 <4EA27607.20407@gmail.com>
 <20111022093218.GF4196@thunk.org>
 <4EB7416A.7080006@gmail.com>
 <4EB76C21.5060104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Matt Parnell <mparnell@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52743 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab1KGPsD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Nov 2011 10:48:03 -0500
Content-Disposition: inline
In-Reply-To: <4EB76C21.5060104@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 06, 2011 at 09:26:57PM -0800, Matt Parnell wrote:
> I figured it out. data=writeback isn't needed and is done by default
> if there's no journal, as per commit
> 373cd5c53d5ea6622c319ecd84e29e2737d488bd http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=373cd5c53d5ea6622c319ecd84e29e2737d488bd
> 
> ...sorry about throwing you guys through loops over this, although
> I'm guessing there's still a bug in that the kernel should just warn
> the user about the option when it's used and otherwise ignore it
> instead of breaking if there's no journal.

Ah, OK.  It wasn't clear to me that you were running without a year.
You're right, we shouldn't complain in that case, since we ignore the
messages when mounting the file system.  Actually, we parse the
options when we are mounting the file system, but then we zero them
out when we discover that there's no journal; but in any case, we
should similarly ignore the pointless data=* mount options (for a file
system w/o a journal) on the remount operation as well.

     	     	      	     	     	       	  - Ted

commit eb513689c97e3e73bb9b4459d490a8e894b4a546
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Nov 7 10:47:42 2011 -0500

    ext4: ignore journalled data options on remount if fs has no journal
    
    This avoids a confusing failure in the init scripts when the
    /etc/fstab has data=writeback or data=journal but the file system does
    not have a journal.  So check for this case explicitly, and warn the
    user that we are ignoring the (pointless, since they have no journal)
    data=* mount option.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9953d80..0435013 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1683,7 +1683,9 @@ static int parse_options(char *options, struct super_block *sb,
 			data_opt = EXT4_MOUNT_WRITEBACK_DATA;
 		datacheck:
 			if (is_remount) {
-				if (test_opt(sb, DATA_FLAGS) != data_opt) {
+				if (!sbi->s_journal)
+					ext4_msg(sb, KERN_WARNING, "Remounting file system with no journal so ignoring journalled data option");
+				else if (test_opt(sb, DATA_FLAGS) != data_opt) {
 					ext4_msg(sb, KERN_ERR,
 						"Cannot change data mode on remount");
 					return 0;
