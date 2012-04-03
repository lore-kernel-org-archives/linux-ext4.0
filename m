From: Ted Ts'o <tytso@mit.edu>
Subject: Re: backup of the last group'descriptor when it is the 1st group
 of a meta_bg
Date: Tue, 3 Apr 2012 11:39:51 -0700
Message-ID: <20120403183951.GA24502@thunk.org>
References: <CAGBYx2bbucN5MN0MfRXK3=x74mY3-+foGuQc2Gd4oQzJAzPVKg@mail.gmail.com>
 <BD0B2BAC-D0BF-44D6-AE26-988095078D3D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43657 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab2DCSjx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Apr 2012 14:39:53 -0400
Content-Disposition: inline
In-Reply-To: <BD0B2BAC-D0BF-44D6-AE26-988095078D3D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 28, 2012 at 10:08:39AM -0600, Andreas Dilger wrote:
> On 2012-03-27, at 8:47 AM, Yongqiang Yang wrote:
> > Hi Ted, Andreas and List,
> >=20
> > As Andreas pointed out last year, if the last group is the 1st grou=
p
> > in a meta bg, then its group desc has no backup.
> > With meta_bg resizing inode is useless,  I had a thought that we st=
ore
> > a backup group descriptor of the last group in the resizing inode=EF=
=BC=9F
> > What's your opinions?

It's an issue, however, when I originally thought about a number of
years ago, it wasn't something I was terribly worried about, since by
definition the percentage of the file system that we could lose is a
small percentage overall.  If we really were worried we could simply
strongly bias the inode allocator against using the inods in that last
block group.  Alternatively, now that we have metadata checksums, it
becomes even easier to find the inode table via a brute force search
if we really needed to find it.

> Actually, if the backup is always stored in the last block of the 0th
> group (which is itself the last group in the filesystem), there isn't
> even a need to store this location in the superblock.

Something that might make sense is to put a backup of the block group
descriptor at block #s_num_blocks (i.e., one block past the end of the
file system as described in the superblock).  E2fsck would just simply
try to see if there's a valid block group descriptor block at one
block past the end of the file system if the primary looks bad and
there aren't any of the normal meta_bg backups --- and that way we
wouldn't need to make any file system format changes.

	      	      	       	      	     - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
