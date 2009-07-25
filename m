From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2freefrag utility
Date: Fri, 24 Jul 2009 20:18:23 -0400
Message-ID: <20090725001823.GD6832@mit.edu>
References: <20090721001750.GD4231@webber.adilger.int> <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com> <20090723170759.GB4231@webber.adilger.int> <20090724223201.GA6832@mit.edu> <20090724231425.GK4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57761 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZGYAT3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jul 2009 20:19:29 -0400
Content-Disposition: inline
In-Reply-To: <20090724231425.GK4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 24, 2009 at 05:14:25PM -0600, Andreas Dilger wrote:
> 
> Well, it was important for the hardware RAID setups, to see how many
> stripe-aligned free chunks are available in the filesystem.  Since
> mballoc will also try to allocate/align on "chunk" boundaries this
> is useful to know.  If this chunksize depended on the superblock
> s_raid_stripe_width then it would be more useful for the general public.

Yeah, I think what we should try to do is to display the chunk
information if s_raid_stripe_width if it is set, and otherwise only
print it if a chunk size is explicitly specified.  Sounds like a plan?

      	      	    	    	       - Ted
