From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs- fix ext2fs_swap_inode_full attr test on BE
 boxes
Date: Fri, 14 Mar 2008 09:13:03 -0500
Message-ID: <47DA87EF.6040405@redhat.com>
References: <47C882CD.3090204@redhat.com> <n7x63vph2q5.fsf@sor.suse.de> <20080314133241.GD7412@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Matthias Koenig <mkoenig@suse.de>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYCNON2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2008 10:13:28 -0400
In-Reply-To: <20080314133241.GD7412@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> This patch is in the repo, which I thought superceded the one which
> Eric sent.  (The authorship is wrong; and that was my fault for not
> including '--author="Eric Sandeen <sandeen@redhat.com>"' on the commit
> command-line.  I've already apologized to Eric privately; now I'm
> apologizing publically.  :-)

And I've realized that I really should start using git to make it easier
on Ted.  :)

> But looking at it again, I believe I misunderstood, and the two
> patches are attacking quite separate problems.  OK, i'll get this one
> in as well in the next go-around.

Yep, there were 2 problems.

One was that inode_scan_and_fix() wasn't moving all of large inodes.

The other was that ext2fs_swap_inode_full was doing bad things for
in-inode attrs on big endian boxes, that was the patch in this thread
which isn't in the repo yet, but is in fact needed.

I suppose that the iterative nature of my fix for this problem didn't
help Ted keep things straight, sorry.

-Eric

