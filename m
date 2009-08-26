From: Jan Kara <jack@suse.cz>
Subject: Re: Problem with ext4_sync_file in no-journal mode.
Date: Wed, 26 Aug 2009 18:27:37 +0200
Message-ID: <20090826162737.GB28867@atrey.karlin.mff.cuni.cz>
References: <1251222245.20219.25.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38670 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZHZQ1g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 12:27:36 -0400
Content-Disposition: inline
In-Reply-To: <1251222245.20219.25.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Our powerfail testing turned up an odd regression when using fsync() in
> no-journal mode to force data to the device.  We saw loss rates (both
> file and data) that were much higher than the same test using ext2 (60+%
> loss versus <10%).  We've done some investigation and one thing that
> stood out was that in the no-journal case, ext4_sync_file() was just
> calling sync_inode() (and nothing else), while ext2_sync_file(), for
> comparison, was also calling sync_mapping_buffers() to actually push the
> data out.
> 
> I therefore hacked ext4_sync_file() to call sync_mapping_buffers() in
> the no-journal case; when we reran the test we saw that the loss rate
> dropped from 60+% to around 50%.  While it's clear that we have more
> work to do in this area, this is a significant improvement.  It appears
> that this was just missed when we did the no-journal work.  Do you guys
> concur?
  Well, I'm surprised sync_mapping_buffers() did anything - I believe
it's rather an error in testing. The thing is: sync_mapping_buffers()
writes buffers on private_list of mapping. In ext2, it contains all the
buffers used for indirect blocks. In ext4, there are no buffers there -
you have to call mark_buffer_dirty_inode() to put a buffer to this list
and ext4 does not do that with any buffer. So to make fsync work, you
have to call mark_buffer_dirty_inode() in __ext4_handle_dirty_metadata
if an inode is provided. Then sync_mapping_buffers() will actually do
something.
  BTW: the syncing code in ext4_handle_dirty_metadata() looks
suboptimal. Why do you sync each an every metadata buffer? It might be
the easiest way for directories but for regular files this is really
superfluous. There you should need anything since VFS does the syncing
for you.

> The other interesting bit of this is that ext4 no-journal without using
> fsync() has, apparently, basically the same loss rate as ext2 with
> fsync().
  Isn't this the other way around? I suppose ext4 without fsync isn't
better than ext4 with fsync ;).

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
