From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Kernel 3.7.0: bad header/extent
Date: Sun, 16 Dec 2012 09:50:13 -0500
Message-ID: <20121216145013.GA5098@thunk.org>
References: <kainf9$btc$1@ger.gmane.org>
 <20121216022753.GD9016@thunk.org>
 <50cd394d.0153650a.3b8d.ffffb917@mx.google.com>
 <20121216035150.GA6104@thunk.org>
 <50cd5e9b.0839650a.221f.ffffc460@mx.google.com>
 <75A902DB-8A60-4CF5-982A-C32C5AB83C27@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38712 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab2LPOuS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Dec 2012 09:50:18 -0500
Content-Disposition: inline
In-Reply-To: <75A902DB-8A60-4CF5-982A-C32C5AB83C27@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 15, 2012 at 11:08:34PM -0700, Andreas Dilger wrote:
> > debugfs 1.41.12 (17-May-2010)
> > Level Entries       Logical              Physical Length Flags
> > 0/ 0   1/  1     0 - 4294967295  37333026 - 4332300321      0 
> 
> This is interesting. The one extent reports it is valid for 2^32-1
> blocks, but this isn't possible with the current on-disk extent
> format. It looks like the extent is actually storing "-1" blocks
> (which is also invalid) but is incorrectly sign extended to
> 0xffffffff.

Actuually, the number of blocks in the extent was set to 0.  The
number reported by e2fsprogs contains is the inclusive range (i.e.,
lblk, lblk+len-1).

A fix for this was added to e2fsprogs in v1.42.2 in March 2012, by
commit 26c09eb8145a1 ("e2fsck: check for zero length extent").  There
was a regression which this commit would sometimes trigger which was
fixed in v1.42.4 (commit 9c40d14841f0, "e2fsck: only check for
zero-length leaf extents").  So e2fsck 1.42.4 or newer is recommended
to repair this sort of file system corruption.

> >    Ok. The problem is that I'm trapped. I need to compile the most
> > recent version (1.42.6) but the needed file to
> > compile (/usr/include/dlfcn.h) isn't available (Input/output error)
> > because of this problem.

What I would suggest that you do is to zap the bad inode and then run
e2fsck to repair the resulting damage:

debugfs -w -R "clri <9311628>" /dev/sda2
e2fsck -fy /dev/sda2

Then reinstall the glibc package (libc6-dev if you are using a
Debian-derived distribution), which supplies dlfcn.h, and then
recompile e2fsprogs so you can install a 1.42.x version of e2fsprogs.

I'm not entirely sure how the inode had gotten corrupted in the first
place, but I would be surprised if it was due to upgrading the kernel
from 3.6 to 3.7.  If you do see this corruption again, please let us
know, and hopefully we can try to figure out what the root cause of
the issue might be.

Regards,

						- Ted
