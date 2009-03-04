From: Theodore Tso <tytso@mit.edu>
Subject: Re: mkfs.ext4: high default -i value undocumented
Date: Tue, 3 Mar 2009 21:49:04 -0500
Message-ID: <20090304024904.GK32284@mit.edu>
References: <alpine.LSU.2.00.0903040007470.12969@fbirervta.pbzchgretzou.qr> <49ADBB03.9070303@redhat.com> <alpine.LSU.2.00.0903040125410.12894@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	kzak@redhat.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53865 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZCDCtJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Mar 2009 21:49:09 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0903040125410.12894@fbirervta.pbzchgretzou.qr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 04, 2009 at 01:36:44AM +0100, Jan Engelhardt wrote:
> >> 
> >> Creating an ext4 filesystem on a 4 GB image file (to be loop-mounted 
> >> later) gives me 256K inodes. Choosing -i 4096 instead gives 1M, which 
> >> would mean the default for -i is 16384. 
> >
> >Which part of a 16384-data-bytes-to-inode-count ratio do you find
> >unreasonable?  Do you find it unreasonably high, or unreasonably low?
> 
> I think it's a bit too high, causing the amount of usable inodes
> to be a bit too low.

So out of curiosity, what are you storing on the filesystem such that
you're worried about running out of inodes?  The assumption was that
on most filesystems the average file size would indeed be bigger than
4k these days, although obviously things will vary depending on what
you plan to store.  Even if you're using maildir stores, or squid
caches, it seemed like 16k was a good default.

> >> does not mention this 16384 default.
> >> Hope this can be addressed.
> >
> >You could send a patch :)

The problem is the default isn't as simple as 16384.  See the
description under the -T option:

      -T usage-type[,...]
              Specify how the filesystem is going to be used, so  that  mke2fs
              can  choose  optimal  filesystem  parameters  for that use.  The
              usage types that are supported are defined in the  configuration
              file  /etc/mke2fs.conf(5).   The  user  may  specify one or more
              usage types using a comma separated list.

              If this option is is not specified, mke2fs will  pick  a  single
              default  usage  type  based  on the size of the filesystem to be
              created.  If the filesystem size is less  than  or  equal  to  3
              megabytes,  mke2fs  will use the filesystem type floppy.  If the
              filesystem size is greater than 3 but less than or equal to  512
              megabytes,  mke2fs(8) will use the filesystem small.  Otherwise,
              mke2fs(8) will use the default filesystem type default.


So for example, if you say "-T news" the default mke2fs.conf file will
cause the default inode ratio to be 4096.  (As I said, that's probably
not right, since the average size for Usenet spools is probably way
over 8k these days; the fact that -T news uses a default inode ratio
of 4096 is historic, and dates back to before p0rn sites dropped huge
numbers of uuencoded image files in the alt.* hierarchy.  :-)

As another example, if the file is smaller that 512 megabytes, the
"small" type will be used, and that causes the default inode ratio to
be 4096, the inode size to be 128, and the block size to be 1024.

   	     	   	      	   - Ted
