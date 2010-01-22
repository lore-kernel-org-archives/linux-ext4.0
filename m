From: tytso@mit.edu
Subject: Re: [PATCH] default max mount count to unused
Date: Fri, 22 Jan 2010 18:18:11 -0500
Message-ID: <20100122231811.GL21263@thunk.org>
References: <4B5785A5.2010505@redhat.com>
 <20100122012929.GA21263@thunk.org>
 <4B591D80.6010309@redhat.com>
 <4B7FFE9D-F110-408D-B432-7D20AEBD4689@sun.com>
 <4B59DA16.3060906@redhat.com>
 <2B15E63C-8EE9-4675-B659-5D1A302334C8@sun.com>
 <4B59F50C.20601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Bill Nottingham <notting@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42620 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab0AVXSS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2010 18:18:18 -0500
Content-Disposition: inline
In-Reply-To: <4B59F50C.20601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 22, 2010 at 01:57:16PM -0500, Ric Wheeler wrote:
> 
> I think that we have to move towards an assumption that our
> journalling code actually works - the goal should be that we can
> *always* mount after a crash or clean reboot. That should be the
> basic test case - pound on a file system, drop power to the storage
> (and or server) and then on reboot, try to remount. Verification
> would be in the QA test case to unmount and fsck to make sure our
> journal was robust.

The original reason for the periodic fsck was not a fear that the
journalling system worked --- it was a concern that the hardware was
reliable.  (Ted's law of PC class hardware: it's crap. :-) That was
the reason for the periodic fsck in the BSD days, and it's the same
now.

That being said, I agree that 20-40 reboots (it's actually randomized
by mke2fs these days; the setting in libext2fs isn't the whole story)
is a ver y rough metric.  I'd much rather do the checking periodically
via snapshots in cron, at which point the reboot counter becomes moot
(the snapshot check zero's the mount count and sets the last checked
time correctly).

							- Ted
