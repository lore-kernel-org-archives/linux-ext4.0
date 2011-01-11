From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6/6] ext4: Dynamically allocate the jbd2_inode in
 ext4_inode_info as necessary
Date: Tue, 11 Jan 2011 16:50:43 -0500
Message-ID: <20110111215043.GG2917@thunk.org>
References: <1294189270-16733-1-git-send-email-tytso@mit.edu>
 <1294189270-16733-7-git-send-email-tytso@mit.edu>
 <A562E0CA-9CA6-4654-8FCB-9849F6EB09E7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45538 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1AKVur (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Jan 2011 16:50:47 -0500
Content-Disposition: inline
In-Reply-To: <A562E0CA-9CA6-4654-8FCB-9849F6EB09E7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 05, 2011 at 12:26:33PM -0700, Andreas Dilger wrote:
> 
> How does this change impact the majority of users that are running
> with a journal?  It is clearly a win for a small percentage of users
> with no-journal mode, but it may be a net increase in memory usage
> for the majority of the users (with journal)....
> 
> The main question is how many files are ever opened for write?  It
> isn't just the number of currently-open files for write, because the
> jinfo isn't released until the inode is cleared from memory.  While
> I suspect that most inodes in cache are never opened for write, it
> would be worthwhile to compare the ext4_inode_cache object count
> against the jbd2_inode object count, and see how the total memory
> compares to a before-patch system running different workloads (with
> journal).

So here's one unscientific data point, based on your humble kernel
developer who happens to read e-mail using mutt and a Maildir
directory (which has lots of read-only files, one per e-mail) and does
primarily source code editing, kernel builds, web browsing, e-mail,
and irc/IM:

Slabcache: ext4_inode_cache      Aliases:  0 Order :  3 Objects: 70820
Slabcache: jbd2_inode            Aliases:  5 Order :  0 Objects: 22126

Note that jbd2_inode is aliased, so not all 22,126 objects are
necessarily jbd2_inodes.  Some of them might also be ip_fib_alias,
ksm_mm_slot, anon_vma_chain, Acpi-Parse, and nsproxy objects.  But
still, the ratio of inodes that I've ever written to inodes that have
only been accessed read-only is over 3:1.

So for at least my laptop/desktop workload, using a separate
jbd2_inode structure is clearly a win, and in fact separating out more
of the ext4_inode_cache structure to create a separate data structure
for fieldsonly needed when the file is opened for writing would likely
be a win.  I can probably peel off another 100 bytes or so from the
ext4_inode_info data structure.

						- Ted
