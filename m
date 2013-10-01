From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: allocate inode table wholly within group
Date: Mon, 30 Sep 2013 21:57:46 -0400
Message-ID: <20131001015746.GF5845@thunk.org>
References: <51D3269B.5080608@redhat.com>
 <51DB2EB9.4010903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40452 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab3JAB5t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Sep 2013 21:57:49 -0400
Content-Disposition: inline
In-Reply-To: <51DB2EB9.4010903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 08, 2013 at 04:27:21PM -0500, Eric Sandeen wrote:
> 
> The actual problem seems to be that the test does successive "-M" minimal resizes, and eventually we resize into the middle of an inode table, leaving the end of the table beyond the fs.
> 
> Point "resize2fs -M" at the attached image once or twice w/ fscks in between and you should see it.

I've been going through my patch backlog, so I finally had a chance to
take a very close look at your test image.  I now understand why
things are failing.

1) The test image (which you said was generated on a ppc e2fsprogs?)
was doing something very weird as far as the location of the
allocation bitmaps and inode table:

Filesystem features:      ext_attr dir_index filetype sparse_super
Inode count:              512
Block count:              1247
   ...

Group 0: (Blocks 1-1024)
  Primary superblock at 1, Group descriptors at 2-2
  Block bitmap at 66 (+65), Inode bitmap at 67 (+66)
  Inode table at 68-99 (+67)

Group 1: (Blocks 1025-1246)
  Backup superblock at 1025, Group descriptors at 1026-1026
  Block bitmap at 1090 (+65), Inode bitmap at 1091 (+66)
  Inode table at 1092-1123 (+67)

Compare and contrast this with what x86 and Debian's ppc mke2fs creates:

Group 0: (Blocks 1-1024)
  Primary superblock at 1, Group descriptors at 2-2
  Block bitmap at 3 (+2), Inode bitmap at 4 (+3)
  Inode table at 5-14 (+4)

Group 1: (Blocks 1025-1246)
  Backup superblock at 1025, Group descriptors at 1026-1026
  Block bitmap at 1027 (+2), Inode bitmap at 1028 (+3)
  Inode table at 1029-1038 (+4)

So I'm not sure why Fedora's ppc mke2fs is creating file systems in
this way, but that's one of the causes of the bug.


2) The second cause of the bug is that
calculate_minimum_resize_size(), when we calculate the number of
blocks for the last group, the code has an implicit assumption that
the metadata blocks are located at the very beginning of the block
group.   That's an easy fix.

> It seems like the obvious fix would be to move the inode table if
> necessary, as with the following patch.

Your patch is a good one, but at least in the context of resize2fs -M,
we should be fixing calculate_minimum_resize_size() so we can avoid
needing to move the inode table (since even if it can succeed, it's
not worth the danger).

I'll send out some patches to address this.  Thanks for sending the
test image; and my apologies for not having time to get back to this
until now.

					- Ted
