From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: add EXT4_IOC_ALLOC_DA_BLKS ioctl
Date: Tue, 24 Feb 2009 08:16:49 -0500
Message-ID: <20090224131649.GB1362@mit.edu>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu> <1235451952-2726-2-git-send-email-tytso@mit.edu> <1235451952-2726-3-git-send-email-tytso@mit.edu> <1235451952-2726-4-git-send-email-tytso@mit.edu> <1235451952-2726-5-git-send-email-tytso@mit.edu> <20090224101105.GM3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44791 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZBXNQ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 08:16:58 -0500
Content-Disposition: inline
In-Reply-To: <20090224101105.GM3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 03:11:05AM -0700, Andreas Dilger wrote:
> On Feb 24, 2009  00:05 -0500, Theodore Ts'o wrote:
> > +#define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 10)
> >   /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
> 
> Please don't use ioctl number 10 - it was used by an early
> version of the FIEMAP ioctl that we still have in use in Lustre
> filesystems.  Not that there is much chance of a collision, but
> it is also easily enough avoided.

Ok, I'll also add a note that ioctl number 10 should be reserved.

    	      	    	      	    	   - Ted
