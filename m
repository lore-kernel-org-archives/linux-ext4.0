From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] e2image: truncate raw image file to correct size
Date: Thu, 16 Feb 2012 18:30:31 -0500
Message-ID: <20120216233031.GD26473@thunk.org>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com>
 <20120216225810.GB26473@thunk.org>
 <4F3D8D01.5040604@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55434 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab2BPXae (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Feb 2012 18:30:34 -0500
Content-Disposition: inline
In-Reply-To: <4F3D8D01.5040604@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 16, 2012 at 06:10:57PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 02/16/2012 05:58 PM, Ted Ts'o wrote:
> > I don't see the bug here.  If there are no leftover sparse bytes,
> > there's no need to write the last zero byte.  The whole point was to
> > make sure i_size was set correctly, and if sparse==0, then i_size is
> > correct.
> 
> - From what I can see, when sparse == 0, the last write does a seek
> to move the file pointer, but doesn't write anything beyond the last
> hole, so i_size is not updated.  This resulted in an image file I
> took of a 20gb fs being 124 MiB too small.  I can only assume that
> this is to be expected, and is the reason for passing one byte of
> zero_buff to write_block instead of not giving it any bytes to
> write, and just asking it to do the seek the way the loop does.

Sorry, I'm still not understanding what you're concerned about.  The
last write should seek to the end of the file system, and write a
single byte --- which would be past the last hole.  The goal is to
make sure the file system is large enough that e2fsck doesn't
complain about the file system image being apparently too small.

And in fact, it's doing the right thing:

tytso.root@tytso-glaptop.cam.corp.google.com> {/home/tytso}  
2007# strace -o /tmp/foo /sbin/e2image -r /dev/funarg/library  /kbuild/test.img
e2image 1.42 (29-Nov-2011)
<tytso.root@tytso-glaptop.cam.corp.google.com> {/home/tytso}  
2008# tail /tmp/foo
lseek(5, 1048576, SEEK_CUR)             = 16102031360
lseek(5, 1048576, SEEK_CUR)             = 16103079936
lseek(5, 1048576, SEEK_CUR)             = 16104128512
lseek(5, 1048576, SEEK_CUR)             = 16105177088
lseek(5, 950271, SEEK_CUR)              = 16106127359
write(5, "\0", 1)                       = 1           <=====
munmap(0x7f7b6dace000, 495616)          = 0
close(4)                                = 0
close(3)                                = 0
exit_group(0)                           = ?

I don't understand why you're saying that it's not writing anything
beyond the last hole, and why you're saying i_size is not being
updated.  It's working for me; I can run e2fsck on the generated
image, and it's not complaining that the file system is too small.

       	   	    		     	 - Ted
