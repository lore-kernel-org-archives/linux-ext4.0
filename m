From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4 ENOSPC Bug
Date: Mon, 16 Feb 2009 14:00:01 -0500
Message-ID: <20090216190001.GB11788@mini-me.lan>
References: <20090216162028.3032666a@lithium.local.net> <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan> <499985C7.8010302@anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Jonathan Bastien-Filiatrault <joe@x2a.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andres Freund <andres@anarazel.de>,
	Alex Buell <alex.buell@munted.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47527 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbZBPTAc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Feb 2009 14:00:32 -0500
Content-Disposition: inline
In-Reply-To: <20090216162028.3032666a@lithium.local.net> <499985C7.8010302@anarazel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 16, 2009 at 04:27:03PM +0100, Andres Freund wrote:
>
> So, yes, seems to be an inode allocation problem.
>

Andres, Alex, others,

I'm pretty sure the ENOSPC problem which you both found is an inode
allocation problem.  Some of you seem to have an easier time
reproducing it than others; could you try this patch, and periodically
scan your system logs for the message "ext4: find_group_flex failed,
fallback succeeded"?  If the problem goes away for you, and you find
the occasional aforemention message in your system log, that will
confirm what I suspect, which is the bug is in fs/ext4/inode.c's
find_group_flex() function.  (If I'm wrong, the fallback code will
activate only when the filesystem is genuinely out of inodes, which
should be very rare.)

More comments are in the patch header.  My current long-term plan for
dealing with this is to enhance find_group_orlov() to and
find_group_other() to understand about flex_bg's.

							- Ted

commit 1012e25b371b203164e4766a98f1e696df68b56d
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Feb 16 13:51:16 2009 -0500

    ext4: Add fallback for find_group_flex
    
    This is a workaround for find_group_flex() which badly needs to be
    replaced.  One of its problems (besides ignoring the Orlov algorithm)
    is that it is a bit hyperactive about returning failure under
    suspicious circumstances.  This can lead to spurious ENOSPC failures.
    Work around this for now by retrying the search using
    find_group_other() if find_group_flex() returns -1.  If
    find_group_other() succeeds when find_group_flex(), log a warning
    message.  I can't quite find the motivation to spend effort working on
    fixing find_group_flex() given that I want to replace it all anyway
    (and in fact work on the replacement code is underway), so we may
    leave the workaround for as long as find_group_flex() stays in the
    kernel...
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a200059..21080ab 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -715,6 +715,13 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode)
 
 	if (sbi->s_log_groups_per_flex) {
 		ret2 = find_group_flex(sb, dir, &group);
+		if (ret2 == -1) {
+			ret2 = find_group_other(sb, dir, &group);
+			if (ret2 == 0)
+				printk(KERN_NOTICE "ext4: find_group_flex "
+				       "failed, fallback succeeded dir %lu\n",
+				       dir->i_ino);
+		}
 		goto got_group;
 	}
 
