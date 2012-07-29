From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How should e2fsck clear s_errno/j_errno on an ro mount?
Date: Sat, 28 Jul 2012 23:51:18 -0400
Message-ID: <20120729035118.GA17210@thunk.org>
References: <5009E62E.3020608@redhat.com>
 <20120721003953.GA9399@thunk.org>
 <500D7BCB.2060806@redhat.com>
 <20120723191410.GB783@thunk.org>
 <500DB259.8070901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41876 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2G2Dv0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Jul 2012 23:51:26 -0400
Content-Disposition: inline
In-Reply-To: <500DB259.8070901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 23, 2012 at 03:21:45PM -0500, Eric Sandeen wrote:
> 
> If make the first test above a little later:
> 
> ...
> 
> 
> it clears it up for me but TBH I'm not totally clear on what all is going
> on here.

Your patch effectively reverts commit 47c1b8e1666: e2fsck: Skip journal
checks if the fs is mounted and doesn't need recovery

The reason why this patch was added was that it slightly speeded up
the HDD boots.  I've looked at this closely, and it's really not that
big of a speed up.  It only saves a single seek and read (to read the
journal superblock).  I've measured what it would be on a 1TB laptop
drive, and the difference is 60ms (70ms versus 10ms).

So I'm going to revert that commit, which should fix the problem that
we're seeing.  But it also turns out that the kernel is not quite
doing the right thing.  It should have never left the journal
superblock with a non-zero s_error indicator after it transfered the
error indicator to the superblock.  The problem was that we weren't
actually flushing the cleared errno field out to the disk for the
journal superblock.

							- Ted

