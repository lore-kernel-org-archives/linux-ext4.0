From: Theodore Tso <tytso@mit.edu>
Subject: Re: [e2fsprogs] Bug in salvage_directory
Date: Mon, 9 Jul 2007 14:29:23 -0400
Message-ID: <20070709182923.GB2343@thunk.org>
References: <1183973522.3889.10.camel@garfield.linsyssoft.com> <20070709165016.GA21922@thunk.org> <1184003549.4347.6.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53232 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbXGIS30 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2007 14:29:26 -0400
Content-Disposition: inline
In-Reply-To: <1184003549.4347.6.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 09, 2007 at 11:22:05PM +0530, Kalpak Shah wrote:
> On Mon, 2007-07-09 at 12:50 -0400, Theodore Tso wrote:
> > On Mon, Jul 09, 2007 at 03:02:02PM +0530, Kalpak Shah wrote:
> > > Hi Ted,
> > > 
> > > Recently, one of our customers found this message in pass2 of e2fsck while doing some regression testing:
> > > "Entry '4, 0x695a, 0x81ff, 0x0040, 0x8320, 0xa192, 0x0021' in ??? (136554) has
> > > rec_len of 14200, should be 26908."
> > > 
> > > Both the displayed rec_len and the "should be" value are bogus. The
> > > reason is that salvage_directory sets a offset beyond blocksize
> > > leading to bogus messages.
> > 
> > Do you have a test case where this happens?  I don't think your patch
> > is right, because if dirent->rec_len is too big, this yes, your patch
> > will make sure offset doesn't get set beyond fs->blocksize, but it
> > ends up leaving prev->rec_len also pointing beyond fs->blocksize ---
> > which means a 2nd e2fsck should result in a complaint about that.
> 
> Yes even prev->rec_len cannot be beyond fs->blocksize. 

Really?  Even after this:

               prev->rec_len += dirent->rec_len;
                             ^^^^^^^^^^^^^^^^^^^

... when *offset + dirent->rec_len > fs->blocksize?  If the else part
of your conditional triggers, then dirent->rec_len is too big; it
could potentially be huge.  So just blindly adding that invalid value
to prev->rec_len can't be right.

> I do have the corrupt filesystem image but it is a large one. 

Can you use debugfs's "dump" command to dump out the contents of the
directory in question?  i.e.:

<tytso.root@candygram> {/usr/projects/ext4-patch-queue}, level 2  [master]
504# debugfs /dev/sda2
debugfs 1.40.1 (08-Jul-2007)
debugfs:  dump /home/tytso/isync/mit/new /tmp/new-dir.img
debugfs:  q
<tytso.root@candygram> {/usr/projects/ext4-patch-queue}, level 2  [master]
505# ls -l /tmp/new-dir.img
408 -rw-r--r-- 1 root root 409600 2007-07-09 14:28 /tmp/new-dir.img

    	       	      	   	  	     - Ted
