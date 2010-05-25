From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: Fix compat EXT4_IOC_ADD_GROUP
Date: Tue, 25 May 2010 11:08:25 -0400
Message-ID: <20100525150824.GK5556@thunk.org>
References: <1274398223.2257.0.camel@localhost>
 <1274398462.2257.7.camel@localhost>
 <63042D4C-90AA-4A3D-A5DC-C0ADF4BF9DDE@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49697 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413Ab0EYPIh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 11:08:37 -0400
Content-Disposition: inline
In-Reply-To: <63042D4C-90AA-4A3D-A5DC-C0ADF4BF9DDE@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 20, 2010 at 10:41:20PM -0600, Andreas Dilger wrote:
> On 2010-05-20, at 17:34, Ben Hutchings wrote:
> > struct ext4_new_group_input needs to be converted because u64 has
> > only 32-bit alignment on some 32-bit architectures, notably i386.
> 
> Sigh, it would have been nice to catch this when ext4_new_group_input was first created.
> 
> I don't mind fixing the kernel, since this is clearly broken.
> However, we may as well go ahead and declare a new struct
> ext4_new_group_input that has the right alignment, rename and
> deprecate the old one (have resize2fs prefer the new one if
> available) and take the old one out in a few years.  I hate this
> business of keeping around old cruft like this forever.

Well, in the long run we need a new ioctl which is compatible with
flex_bg, which means doing multiple groups at once, and letting the
kernel do much more of the work of selecting the block and inode
numbers.  And of course to support 2**64 blocks we need to support the
meta_bg style of resizing.  So we need to do some thinking about how
to support resizing in the long-term anyway.

   	   	       	   	     - Ted
