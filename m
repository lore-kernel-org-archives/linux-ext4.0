From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: problem in ext2fs_get_next_inode_full() ?
Date: Fri, 19 Feb 2016 09:24:31 -0500
Message-ID: <20160219142431.GA20458@thunk.org>
References: <D2EB8E48.12F559%andreas.dilger@intel.com>
 <E32557C0-B912-4F00-BF85-F0A1A2B23496@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56388 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947941AbcBSOYe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 09:24:34 -0500
Content-Disposition: inline
In-Reply-To: <E32557C0-B912-4F00-BF85-F0A1A2B23496@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 18, 2016 at 03:30:35PM -0700, Andreas Dilger wrote:
> > So if the inode is being swabbed then it handles the full inode size, but
> > if it is not being swabbed (the common case) it appears that it is only
> > copying the small inode into "*inode" using a struct assignment.  This
> > appears like it would be dropping the large inode data, but I'm not sure
> > if or when this "extra_bytes" case is hit.  The "else" clause appears to
> > copy the requested (full) inode size properly via "memcpy(..., bufsize)".
> > 
> > Should the struct assignment be changed similarly to use memcpy()?
> 
> To follow up on my own email - I also see struct ext2_inode_cache_ent is
> only caching the small inode, and not a large inode.  This would seem to
> potentially cause loss of the large inode data if the inode cache is
> used by tools like resize2fs or others that move around inodes?

Those are both bugs, and I'm guessing they were added when we added
metadata checksuming, as they aren't a problem in the maint branch.
The inode cache should *only* be used if we are reading the small
inode (which is the common case; we only need the full inode if we are
moving the inode around or if we need to access the xattrs).  And
indeed we do that in the maint branch:

	/* Check to see if it's in the inode cache */
	if (bufsize == sizeof(struct ext2_inode)) {
		/* only old good inode can be retrieved from the cache */
		for (i=0; i < fs->icache->cache_size; i++) {
			if (fs->icache->cache[i].ino == ino) {
				*inode = fs->icache->cache[i].inode;
				return 0;
			}
		}
	}

Unfortunately this check got removed in the next branch, and I missed
it in my code reviews.

We should probably have some unit tests to make sure we don't regress
here again, and probably make the comments a bit more explicit.

     	    		      	  	   - Ted
