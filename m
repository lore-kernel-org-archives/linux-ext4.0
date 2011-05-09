From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 1/5] ext4: move ext4_add_groupblocks() to mballoc.c
Date: Mon, 9 May 2011 10:54:53 -0400
Message-ID: <20110509145453.GB19811@thunk.org>
References: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
 <1300985893-4371-2-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: amir73il@users.sourceforge.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40870 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab1EIOy4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 10:54:56 -0400
Content-Disposition: inline
In-Reply-To: <1300985893-4371-2-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 24, 2011 at 06:58:09PM +0200, amir73il@users.sourceforge.net wrote:
> From: Amir Goldstein <amir73il@users.sf.net>
> 
> In preparation for the next patch, the function ext4_add_groupblocks()
> is moved to mballoc.c, where it could use some static functions.
> 
> I also fixed a checkpatch warning and replaced obsolete get_undo_access
> for bitmap with get_write_access.
> 
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

Please don't move code and make changes in one patch.  #1, it's hard
to review changes that happened in the middle of code movement.  #2,
if there has been any changes in the source function caused by other
patches, I can't regenerate a patch by simply redoing the function
move --- I have to reverse engineer the change that happened under the
cover of code movement, regnerate the patch, and then redo the change.

I've split this into two patches, one which is just a simple code
movement (note that I also moved the function declaration in ext4.h so
it function is listed under the correct .c file), and the second which
changed the use of ext4_journal_get_undo_access to
ext4_journal_get_write_access.  Since this was also the last use of
ext4_journal_get_undo_access(), I also removed the now-unneeded code
in ext4_jbd2.[ch].

						- Ted
