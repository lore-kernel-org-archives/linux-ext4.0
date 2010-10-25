From: Ted Ts'o <tytso@mit.edu>
Subject: Re: How to remove a corrupted dir in an ext4 FS?
Date: Mon, 25 Oct 2010 10:29:37 -0400
Message-ID: <20101025142937.GB16981@thunk.org>
References: <201010241312.53784.melendro@terra.es>
 <062C162D-7D68-4C2A-A6E8-B51F771E88D3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jesus Sanchez Melendro <melendro@terra.es>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39048 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab0JYO3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 10:29:41 -0400
Content-Disposition: inline
In-Reply-To: <062C162D-7D68-4C2A-A6E8-B51F771E88D3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 25, 2010 at 10:16:55PM +0800, Andreas Dilger wrote:
> On 2010-10-24, at 19:12, Jesus Sanchez Melendro wrote:
> > After a corruption in an ext4 filesystem, I've checked and moved to the 
> > correct position all the files and dirs in lost+found, but one of the dirs is 
> > corrupted.
> > 
> > The "ls -l" command says:
> > d????????? ? ? ? ? ? /lost+found/#90116
> > 
> > If I try to remove it with "rmdir" or "rm -rf" or "mv" or "unlink", all 
> > commands say:
> > <command used>: failed to remove `#90116': Input/output error
> > 
> > Running "fsck" says that the filesystem is OK.
> > 
> > Is there a way to remove that corrupted dir?
> 
> You can probably check "lsattr /lost+found/#90116" to see if either
> the "i" (immutable) or "a" (append-only) attribute is set.  If yes,
> then running "chattr -i -a/lost+found/#90116" will remove those
> attributes, and it should be removable.

If it was an immutable or apppend-only attribute, it should have
resulted in a "Operation not permitted" error.  I suspect the problem
may be an underlying disk error.  You might want to check "dmesg", and
see if the hard drive is reporting I/O errors.  It may very well be
that you have problems a lot more serious than just a corrupted file
system.  If so, you might want to consider making an immediate backup
right away, and strongly consider replacing the hard drive if you find
I/O errors in your system logs.

					- Ted
