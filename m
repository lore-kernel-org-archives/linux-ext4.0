From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix a race between checkpointing code and
	journal_get_write_access()
Date: Mon, 13 Jul 2009 10:44:47 -0400
Message-ID: <20090713144447.GF12833@mit.edu>
References: <1245859360-5261-1-git-send-email-jack@suse.cz> <1245859360-5261-2-git-send-email-jack@suse.cz> <20090706025319.GG6706@mit.edu> <20090708223150.GB14005@mit.edu> <20090710100713.GB17524@duck.suse.cz> <20090713131901.GC12833@mit.edu> <20090713132958.GC12293@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60980 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053AbZGMOou (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 10:44:50 -0400
Content-Disposition: inline
In-Reply-To: <20090713132958.GC12293@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 13, 2009 at 03:29:58PM +0200, Jan Kara wrote:
>   I've been doing some more tests here and there's one more path which emits
> the warning when deleting symlinks (falsely this time). I'll send you the fix
> when I verify that I cannot trigger the warning anymore.

Ah, that would explain why I'm stil seeing the warning when fsstress
runs.  Was it doing it on long symlinks or short symlinks, out of
curiosity?

						- Ted


