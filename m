From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsck shouln't consider superblock summaries as fatal
Date: Wed, 27 Aug 2008 01:32:42 -0600
Message-ID: <20080827073242.GU3392@webber.adilger.int>
References: <20080826104502.GH3392@webber.adilger.int>
 <20080826170420.GE8720@mit.edu> <20080826212743.GP3392@webber.adilger.int>
 <20080827002516.GC29936@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38127 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYH0Hcr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 03:32:47 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7R7Wl7A008948
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 00:32:47 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K69006010TYS200@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 27 Aug 2008 00:32:47 -0700 (PDT)
In-reply-to: <20080827002516.GC29936@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 26, 2008  20:25 -0400, Theodore Ts'o wrote:
> On Tue, Aug 26, 2008 at 03:27:43PM -0600, Andreas Dilger wrote:
> > I mean that this is for "e2fsck -fn".  In that case the filesystem isn't
> > changed, and is often completely clean except the superblock counters.
> > Until we have block-device freeze ioctl widely available (or convince
> > users to use LVM), the best we can do is quiesce Lustre IO without
> > unmounting the filesystem.
> 
> Ah, I see.  So the main thing that you are trying to achieve with the
> patch is avoid the non-zero exit from fsck, right?

Yes, the non-zero exit is the main issue.

> I guess I'm really not that happy with letting the filesystem getting
> marked as "valid" if the user refuses to fix the free blocks/inode
> count summary when the -n flag isn't getting set.  And technically, if
> the summary statistics are wrong, the filesystem is not actually
> valid, which is what an exit code of 4, right?

Sure, but the summary statistics are _always_ wrong these days.  I even
think there was even a hack somewhere to e2fsck that you wrote to fixes
up the summaries silently when e2fsck was always reporting errors after
we turned off the superblock updates...

> It seems like the much more "correct" solution, which would actually
> be more code, but would also be useful when a user wants to check a
> filesystem without actually changing *anything*, including running the
> journal, would be to create an I/O manager which reads in the journal
> into memory, and creates a "override map" data structure such that
> when e2fsck tries to read from a block which is in the journal, that
> the (read-only) I/O manager read the block in the journal instead of
> from the disk.  (Of course it will need to respect the revoke records,
> too!)

I don't think this is the issue at all.  It isn't that the journal has the
right summary values either, otherwise waiting 1 commit interval would
be enough.  The issue is that the kernel NEVER updates the summaries
by itself, so the effort to replay the journal in memory would be cool,
but wouldn't help at all.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

