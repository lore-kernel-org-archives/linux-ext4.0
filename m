From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Still about ext2/ext3 mount options while using ext4.ko driver
Date: Mon, 9 Dec 2013 19:13:53 -0500
Message-ID: <20131210001353.GA19933@thunk.org>
References: <20131209212531.GB4296@orion.maiolino.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38372 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3LJAN6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Dec 2013 19:13:58 -0500
Content-Disposition: inline
In-Reply-To: <20131209212531.GB4296@orion.maiolino.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 09, 2013 at 07:25:31PM -0200, Carlos Maiolino wrote:
> 
> But, there are still some mount options that IMHO needs a review of what should
> and shouldn't be allowed while using ext4 to mount ex2/3 filesystems.
> 
> max_batch_time=5 #I'm not sure ir this has any gain for ext2 and if it might
> 		  work well with ext3, any comments?
> min_batch_time=5 #same as above
> 
> journal_ioprio=5 #doesn't make sense for ext2, but might be useful for ext3 FS?!
> 
> journal=11 #doesn't make sense for ext2
> 
> barrier=1 #doesn't make sense for ext2
> 
> barrier #doesn't make sense for ext2
> 
> nobarrier #doesn't make sense for ext2
> 
> commit=5  #doesn't make sense for ext2
> 
> abort  #call ext4_abort(), devel usage only, and it fails to put ext2 FS on RO,
>        if this should be kept enabled, I can look why ext2 keep RW after its use
> 

These are all journal-related options, so they simply have no effect
for ext2 file systems.  (The abort mount option is a test facility
which was introduced in the ext3 days to test whether or not the
journal abort feature worked correctly.)  They don't make sense for
ext4 file systems that don't have a journal enabled, so maybe the
right thing to do is to either refuse the mount or print a warning
message indicating that the mount option is going to be ignored since
no journal is present.

> auto_da_alloc    #ext4 only
> 
> noauto_da_alloc  #same as above

In Ext2 and ext3 mode, nodelalloc is the default, but in theory a user
could explicitly request delayed allocation using the delalloc mount
option.  There's a bit of a philosophical question hiding here about
whether you want to prohibit users who might want to use ext2/ext3 but
still want to enable delalloc.


> discard		 #ex2 shouldn't be allowed to use it ?!
> 
> nodiscard	 #same as above

Meh; if you use discard, and you crash in the middle of the unlink you
could lose data.  But you use ext2 and you crash in the middle of
something, you're likely to lose data anyway.  This just amplifies it
a bit more.


> block_validity   #ext4 and debugging purposes only, should be off for ext2/3 too
> 
> noblock_validity #same as above

I don't see any harm in allowing block_validity; it's a debugging
feature that can be useful in ext2 and ext3 modes.

> 
> i_version  # I believe this is only valid for Ext4 

Well, you can have a file system with a larger (> 128 bytes) inode
with ext2 or ext3.  So in theory you could make i_version work.  I'm
not sure it matters a whole lot in either direction.

        	    	      	    - Ted
