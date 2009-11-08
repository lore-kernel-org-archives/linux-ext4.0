From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in
	ext4_statfs()
Date: Sun, 8 Nov 2009 16:48:04 -0500
Message-ID: <20091108214804.GC7592@mit.edu>
References: <4AF4A429.7090507@redhat.com> <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34019 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZKHVsH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Nov 2009 16:48:07 -0500
Content-Disposition: inline
In-Reply-To: <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 06, 2009 at 05:26:51PM -0700, Andreas Dilger wrote:
> If the choice is between adding a proper transaction here, or not
> doing this at all, I'd rather just not do it at all.  Of course, I'd
> like to work out some kind of compromise, like only updating the
> superblock when there is already a shadow BH that is being used to
> write to the journal, or similar.

In practice, the superblock is never going to modified in normal
operations, unless a resize happens to be happening.  Since we already
force the superblock summary counters to be correct during an unmount
or file system freeze, we really only need this so that it's correct
after a file system crash.

I don't think people generally end up calling statfs() all that
frequently, so it's not clear how much adding a 30 second throttle
would help.  Maybe we should just not bother trying to update the
superblock at all on a statfs()?

Hmm...

						- Ted
