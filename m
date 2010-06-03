From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Use bitops to read/modify i_flags part2
Date: Wed, 2 Jun 2010 22:55:59 -0400
Message-ID: <20100603025559.GG24062@thunk.org>
References: <1271687537-15655-1-git-send-email-dmonakhov@openvz.org>
 <1274734174-28830-1-git-send-email-tytso@mit.edu>
 <87ocfwsb3m.fsf_-_@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34587 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933641Ab0FCC4D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jun 2010 22:56:03 -0400
Content-Disposition: inline
In-Reply-To: <87ocfwsb3m.fsf_-_@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 31, 2010 at 12:56:45PM +0400, Dmitry Monakhov wrote:
> "Theodore Ts'o" <tytso@mit.edu> writes:
> 
> > From: "Theodore Ts'o" <tytso@mit.edu>
> >
> > From: Dmitry Monakhov <dmonakhov@openvz.org>
> Bad news. Bug still exist because you've missed several important chunks 
> (ext4_set_inode_flags, ext4_inode_blocks) while porting original patch.
> And I've missed this too on review cycle.
> Please add following patch to patch-queue.

Added to the ext4 patch queue (with minor updates to the commit
description).

					- Ted
