From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Use bitops to read/modify i_flags part2
Date: Mon, 31 May 2010 23:06:08 -0400
Message-ID: <20100601030608.GA4426@thunk.org>
References: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org>
 <1274734174-28830-1-git-send-email-tytso@mit.edu>
 <87ocfwsb3m.fsf_-_@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59093 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab0FADGP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 23:06:15 -0400
Content-Disposition: inline
In-Reply-To: <87ocfwsb3m.fsf_-_@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 31, 2010 at 12:56:45PM +0400, Dmitry Monakhov wrote:
> Bad news. Bug still exist because you've missed several important chunks 
> (ext4_set_inode_flags, ext4_inode_blocks) while porting original patch.
> And I've missed this too on review cycle.
> Please add following patch to patch-queue.

What I should have insisted on (if I had time to review this sort of
patch earlier) is to split it up into that which could be implemented
via a perl script (i.e.):

#!/usr/bin/perl -i.bak

while (<>) {
    s/EXT4_I\(([^ ]*)\)->i_flags & EXT4_([^ ]*)_FL/ext4_test_inode_flag(\1, EXT4_INODE_\2)/;
    s/EXT4_I\(([^ ]*)\)->i_flags \|= EXT4_([^ ]*)_FL/ext4_set_inode_flag(\1, EXT4_INODE_\2)/;
    s/EXT4_I\(([^ ]*)\)->i_flags \&= ~EXT4_([^ ]*)_FL/ext4_clear_inode_flag(\1, EXT4_INODE_\2)/;
    print;
}

with a piece before and after it for the more complicated bits.  This
is why really large patches, really, *really* need to be split apart.
(Or needs to have enough description of what was being done where so
that I could split apart into more easily manageable --- and easily
backported to stable kernel -- pieces.)

But no worries, we'll treat this as the follow-on part of the patch,
and then add these to the additional stable series patches.  These
sorts of things happen, especially with these gigantic patches....

      	 			   	      - Ted
