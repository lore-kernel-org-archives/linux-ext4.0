From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] e2image: truncate raw image file to correct size
Date: Fri, 17 Feb 2012 11:04:22 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202171054320.6479@dhcp-27-109.brq.redhat.com>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com> <20120216225810.GB26473@thunk.org> <4F3D8D01.5040604@ubuntu.com> <20120216233031.GD26473@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phillip Susi <psusi@ubuntu.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab2BQKE2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 05:04:28 -0500
In-Reply-To: <20120216233031.GD26473@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 16 Feb 2012, Ted Ts'o wrote:

> On Thu, Feb 16, 2012 at 06:10:57PM -0500, Phillip Susi wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > On 02/16/2012 05:58 PM, Ted Ts'o wrote:
> > > I don't see the bug here.  If there are no leftover sparse bytes,
> > > there's no need to write the last zero byte.  The whole point was to
> > > make sure i_size was set correctly, and if sparse==0, then i_size is
> > > correct.
> > 
> > - From what I can see, when sparse == 0, the last write does a seek
> > to move the file pointer, but doesn't write anything beyond the last
> > hole, so i_size is not updated.  This resulted in an image file I
> > took of a 20gb fs being 124 MiB too small.  I can only assume that
> > this is to be expected, and is the reason for passing one byte of
> > zero_buff to write_block instead of not giving it any bytes to
> > write, and just asking it to do the seek the way the loop does.
> 
> Sorry, I'm still not understanding what you're concerned about.  The
> last write should seek to the end of the file system, and write a
> single byte --- which would be past the last hole.  The goal is to
> make sure the file system is large enough that e2fsck doesn't
> complain about the file system image being apparently too small.
> 
> And in fact, it's doing the right thing:
> 
> tytso.root@tytso-glaptop.cam.corp.google.com> {/home/tytso}  
> 2007# strace -o /tmp/foo /sbin/e2image -r /dev/funarg/library  /kbuild/test.img
> e2image 1.42 (29-Nov-2011)
> <tytso.root@tytso-glaptop.cam.corp.google.com> {/home/tytso}  
> 2008# tail /tmp/foo
> lseek(5, 1048576, SEEK_CUR)             = 16102031360
> lseek(5, 1048576, SEEK_CUR)             = 16103079936
> lseek(5, 1048576, SEEK_CUR)             = 16104128512
> lseek(5, 1048576, SEEK_CUR)             = 16105177088
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^
So if blocks count ends right here^^, then the last write would not
happen, because sparse == 0. The reason is that we will seek when the
sparse >= 1024*1024 and then set sparse = 0

if (sparse >= 1024*1024) {
	write_block(fd, 0, sparse, 0, 0);
	sparse = 0;
}

if the file system ends right after that point, then we will not write
that one last byte.

We can easily fix that by doing this instead:

if (sparse > 1024*1024) {
	write_block(fd, 0, 1024*1024, 0, 0);
	sparse -= 1024*1024;
}

Thanks!
-Lukas

> lseek(5, 950271, SEEK_CUR)              = 16106127359
> write(5, "\0", 1)                       = 1           <=====
> munmap(0x7f7b6dace000, 495616)          = 0
> close(4)                                = 0
> close(3)                                = 0
> exit_group(0)                           = ?
> 
> I don't understand why you're saying that it's not writing anything
> beyond the last hole, and why you're saying i_size is not being
> updated.  It's working for me; I can run e2fsck on the generated
> image, and it's not complaining that the file system is too small.
> 
>        	   	    		     	 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
