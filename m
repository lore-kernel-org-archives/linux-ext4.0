From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] [RFC] jbd2: Add buffer triggers
Date: Fri, 3 Oct 2008 20:03:36 -0400
Message-ID: <20081004000336.GE11442@mit.edu>
References: <20080917232629.GB20752@mail.oracle.com> <20080929012527.GI8711@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joel Becker <Joel.Becker@oracle.com>
To: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54213 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753255AbYJDADj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Oct 2008 20:03:39 -0400
Content-Disposition: inline
In-Reply-To: <20080929012527.GI8711@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey Joel,

I'm not sure you saw this e-mail, since I think it got in a mailman
moderation queue.

I've been looking more closely at this, and I think actually using
this commit trigger gets very tricky.  Exactly how do you plan to use
the commit trigger?  The caller is only going to be able to easily
check the checksum on the frozen copy of the buffer; is that what you
intended?  When and how do you plan set the checksum for a filesystem
which is cleanly unmounted?  And are you planning on doing this for
just the superblock, or for other data structures?  

     	 	     	    	       - Ted

On Sun, Sep 28, 2008 at 09:25:27PM -0400, Theodore Tso wrote:
> On Wed, Sep 17, 2008 at 04:26:30PM -0700, Joel Becker wrote:
> > Filesystems often to do compute intensive operation on some
> > metadata.  If this operation is repeated many times, it can be very
> > expensive.  It would be much nicer if the operation could be performed
> > once before a buffer goes to disk.
> 
> Sorry for the delay in reviewing this patch, but I've got a question.
> Right now you are calling the commit trigger *after* doing the escape
> data copying.  This means that if the commit trigger is going to
> modify the buffer (in the case of the checksum being stored in-line in
> the block, which I gather is the case in OCFS2, right?), if you get
> unlucky and the block begins with the four bytes JBD2_MAGIC_NUMBER,
> then the checksum will be in the value which gets written out to the
> log, but *not* to the value in the buffer head that will ultimately
> get written to the final location on disk.  In the normal case where
> the journal wraps and then truncated, it means the checksum will never
> get written to the disk.  That seems bad.  :-)
> 
> I believe the correct location to fire the per-buffer commit trigger
> is right after the first kmap_atomic, right before the comment "Check
> for escaping".  This also fixes the bug where if the checksum is
> stored in the first four bytes of the block, in the case where you
> have bad luck and the checksum == JBD2_MAGIC_NUMBER, you won't end up
> with a corrupted journal.
> 
> Do you agree?  If so, please let me know and I can fix up the patch,
> or just submit to me an updated patch.
> 
> Thanks,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
