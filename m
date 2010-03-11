From: tytso@mit.edu
Subject: Re: [PATCH 3/5] ext4: Implement project ID support for ext4
 filesystem
Date: Thu, 11 Mar 2010 17:01:33 -0500
Message-ID: <20100311220133.GL1497@thunk.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
 <1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
 <1267727677-11956-3-git-send-email-dmonakhov@openvz.org>
 <1267727677-11956-4-git-send-email-dmonakhov@openvz.org>
 <20100311120623.GC4706@infradead.org>
 <877hpjj88k.fsf@openvz.org>
 <B4AAD310-8A75-43C8-989E-616CFACFB7A9@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42624 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330Ab0CKWBh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 17:01:37 -0500
Content-Disposition: inline
In-Reply-To: <B4AAD310-8A75-43C8-989E-616CFACFB7A9@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 11, 2010 at 12:54:46PM -0700, Andreas Dilger wrote:
> A second possibility (if there is really no desire to have more than
> a single project ID per inode) is to add a field to the "large"
> inode for ext4, though that doesn't help filesystems that were not
> formatted that way, and it also consumes space in all inodes even if
> this feature is not used.

The big question that I'm still uncertain about is how often are
people going to be using this feature, and how many project ID's do we
really need?  I know Dimitry believes this is going to be the greatest
thing since sliced bread, but even for people running virtualization,
I'm not sure how many folks really will consider it critical.

I'd be a bit more willing to give the last 16-bit field for the
project ID, but otherwise, I think using a 32-bit field in the large
inode might be the better compromise if we don't like the xattr
approach.

Of course, I'm willing to be convinced otherwise with some sound
technical arguments.  (Or beer; beer is good too.  :-)

    	     	      	    	   	- Ted
