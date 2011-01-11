From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix trimming starting with block 0 with small
 blocksize
Date: Tue, 11 Jan 2011 13:34:19 -0500
Message-ID: <20110111183419.GE2917@thunk.org>
References: <1294682433-6775-1-git-send-email-jack@suse.cz>
 <alpine.LFD.2.00.1101111138400.3095@dhcp-lab-213.englab.brq.redhat.com>
 <20110111175908.GB2917@thunk.org>
 <alpine.LFD.2.00.1101111904010.19238@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60838 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab1AKSeX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Jan 2011 13:34:23 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101111904010.19238@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 11, 2011 at 07:11:47PM +0100, Lukas Czerner wrote:
> I am sorry for causing you troubles. However I always send you patches
> using git format-patch and git send-email, but it this case I just
> replied to Jan's patch to let you know that my previous attempts to fix
> this was not right. Jan sent it to you and to the ext4 list, so you should
> have the original, no need to manually pick out this one.

Ah, I see.  For some reason Jan's first e-mail in the thread never
made it into my inbox.  I'm not sure why; spam filtering gone mad, or
maybe dueling IMAP clients got confused and nuked it.  Anyway, I found
it in patchwork, and will pull it down from there.

What I will do is revert your current patch in the tree and then apply
Jan's, since that will avoid needing to large part of the git patch
queue.

      	   	      	      	       	    - Ted

