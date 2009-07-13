From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Fix a race between checkpointing code and
	journal_get_write_access()
Date: Mon, 13 Jul 2009 17:29:36 +0200
Message-ID: <20090713152936.GD12293@duck.suse.cz>
References: <1245859360-5261-1-git-send-email-jack@suse.cz> <1245859360-5261-2-git-send-email-jack@suse.cz> <20090706025319.GG6706@mit.edu> <20090708223150.GB14005@mit.edu> <20090710100713.GB17524@duck.suse.cz> <20090713131901.GC12833@mit.edu> <20090713132958.GC12293@duck.suse.cz> <20090713144447.GF12833@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47746 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171AbZGMP3i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 11:29:38 -0400
Content-Disposition: inline
In-Reply-To: <20090713144447.GF12833@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 13-07-09 10:44:47, Theodore Tso wrote:
> On Mon, Jul 13, 2009 at 03:29:58PM +0200, Jan Kara wrote:
> >   I've been doing some more tests here and there's one more path which emits
> > the warning when deleting symlinks (falsely this time). I'll send you the fix
> > when I verify that I cannot trigger the warning anymore.
> 
> Ah, that would explain why I'm stil seeing the warning when fsstress
> runs.  Was it doing it on long symlinks or short symlinks, out of
> curiosity?
  Long symlinks - the problem was that __dispose_buffer() called from
ext4_invalidatepage() did __jbd2_journal_unfile_buffer() (jbddirty bit was
moved to dirty bit) and then __jbd2_journal_file_buffer() which complained.
As we cleared the jbddirty bit immediately afterwards it was quite
straightforward to fix.  I've audited all other occurences of
jbd2_journal_unfile_buffer() and we discard the buffer head after all other
calls...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
