From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Wed, 24 Oct 2012 17:08:19 -0400
Message-ID: <20121024210819.GA5484@thunk.org>
References: <20121023013343.GB6370@fieldses.org>
 <87mwzdnuww.fsf@spindle.srvr.nix>
 <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508740B2.2030401@redhat.com>
 <87txtkld4h.fsf@spindle.srvr.nix>
 <50876E1D.3040501@redhat.com>
 <20121024052351.GB21714@thunk.org>
 <878vavveee.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
To: Nix <nix@esperi.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <878vavveee.fsf@spindle.srvr.nix>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 24, 2012 at 09:45:47PM +0100, Nix wrote:
> 
> It occurs to me that it is possible that this bug hits only those
> filesystems for which a umount has started but been unable to complete.
> If so, this is a relatively rare and unimportant bug which probably hits
> only me and users of slow removable filesystems in the whole world...

Can you verify this?  Does the bug show up if you just hit the power
switch while the system is booted?

How about changing the "sleep 2" to "sleep 0.5"?  (Feel free to
unmount your other partitions, and just leave a test file system
mounted to minimize the chances that you lose partitions that require
hours and hours to restore...)

If you can get a very reliable repro, we might have to ask you to try
the following experiments:

0) Make sure the reliable repro does _not_ work with 3.6.1 booted

1) Try a 3.6.2 kernel

2) (If the problem shows up above) try a 3.6.2 kernel with 14b4ed2 reverted

3) (If the problem shows up above) try a 3.6.2 kernel with all of ext4
   related patches reverted:
92b7722 ext4: fix mtime update in nodelalloc mode
34414b2 ext4: fix fdatasync() for files with only i_size changes
12ebdf0 ext4: always set i_op in ext4_mknod()
22a5672 ext4: online defrag is not supported for journaled files
ba57d9e ext4: move_extent code cleanup
2fdb112 ext4: fix crash when accessing /proc/mounts concurrently
1638f1f ext4: fix potential deadlock in ext4_nonda_switch()
5018ddd ext4: avoid duplicate writes of the backup bg descriptor blocks
256ae46 ext4: don't copy non-existent gdt blocks when resizing
416a688 ext4: ignore last group w/o enough space when resizing instead of BUG'ing
14b4ed2 jbd2: don't write superblock when if its empty

4) (If the problem still shows up) then we may need to do a full
   bisect to figure out what is going on....

   	     	     	    	     	- Ted
