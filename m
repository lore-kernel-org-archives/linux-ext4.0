From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't save the error information if the block
 device is read-only
Date: Fri, 15 May 2015 19:36:17 -0400
Message-ID: <20150515233617.GA4599@thunk.org>
References: <1431643079-22882-1-git-send-email-tytso@mit.edu>
 <CAG_9a6cSd-1VDD8zkCt7zFPbBi01a78VeOTDyi0NJuvS26XApw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mohamad Ayyash <mkayyash@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39614 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992729AbbEOXgS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 May 2015 19:36:18 -0400
Content-Disposition: inline
In-Reply-To: <CAG_9a6cSd-1VDD8zkCt7zFPbBi01a78VeOTDyi0NJuvS26XApw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 15, 2015 at 09:34:18PM +0000, Mohamad Ayyash wrote:
> I wonder if there should be some similar protection at other callers of
> ext4_commit_super like ext4_mark_recovery_complete?

We do have protections already before we start replaying the journal,
and before we process the orphaned inode list.  See the
bdev_read_only() calls in ext4_orphan_cleanup() and ext4_load_journal().

So I think we have them all covered, but let me know if you find one
that we've missed.  Something that's probably worth doing is to
putting in a debugging patch that notices when thre are writes sent
down from the file systems when the block device is marked read-only,
and then running xfstests and seeing if it trips anywhere.

Cheers,

						- Ted
