From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs- fix ext2fs_swap_inode_full attr test on BE
	boxes
Date: Fri, 14 Mar 2008 10:40:21 -0400
Message-ID: <20080314144021.GE7412@mit.edu>
References: <47C882CD.3090204@redhat.com> <n7x63vph2q5.fsf@sor.suse.de> <20080314133241.GD7412@mit.edu> <47DA87EF.6040405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthias Koenig <mkoenig@suse.de>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54757 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbYCNOlR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2008 10:41:17 -0400
Content-Disposition: inline
In-Reply-To: <47DA87EF.6040405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 14, 2008 at 09:13:03AM -0500, Eric Sandeen wrote:
> Yep, there were 2 problems.
> 
> One was that inode_scan_and_fix() wasn't moving all of large inodes.
> 
> The other was that ext2fs_swap_inode_full was doing bad things for
> in-inode attrs on big endian boxes, that was the patch in this thread
> which isn't in the repo yet, but is in fact needed.
> 
> I suppose that the iterative nature of my fix for this problem didn't
> help Ted keep things straight, sorry.

I actually *prefer* multiple patches, actually, but what works best
when there is a series of patches is to resend the whole patch stack
using git-format-patch or git-send-email --- or set up your own git
repository on the network (or use repo.or.cz) and send me a pull
request.  But that requires much more use of git.  :-)

In any case, I'll pull in the last change, and this time I promise
I'll be careful about remembering to use --author.  That *is*
something I should be doing, but I certainly appreciate people using
git's facilities to make my life easier, thanks.

      		    	    	 	 - Ted
