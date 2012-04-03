From: Ted Ts'o <tytso@mit.edu>
Subject: Re: backup of the last group'descriptor when it is the 1st group
 of a meta_bg
Date: Tue, 3 Apr 2012 14:26:54 -0700
Message-ID: <20120403212654.GB24502@thunk.org>
References: <CAGBYx2bbucN5MN0MfRXK3=x74mY3-+foGuQc2Gd4oQzJAzPVKg@mail.gmail.com>
 <BD0B2BAC-D0BF-44D6-AE26-988095078D3D@dilger.ca>
 <20120403183951.GA24502@thunk.org>
 <2E05166B-2C63-4DA0-BD80-7C91C9623BDF@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <aedilger@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54513 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab2DCV06 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Apr 2012 17:26:58 -0400
Content-Disposition: inline
In-Reply-To: <2E05166B-2C63-4DA0-BD80-7C91C9623BDF@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 03, 2012 at 01:28:14PM -0600, Andreas Dilger wrote:
> It would probably not even cause the backup group descriptor to be
> lost in the worst case (new mke2fs/e2fsck/resize2fs creates gd backup,
> old e2fsck "deletes" gd backup block, use filesystem for a long time,
> corrupt primary group descriptors, try to recover using new e2fsck).

Well, it can only be repaired if that block hasn't been allocated and
assigned to a file.  If it has, then you can't easily repair it and
you have to resign yourself to not having a backup of the bgd.  And
that means more complexity since e2fsck would have to deal with the
possibility that the last block might contain a backup bgd, or might
be allocated to a file.

And even if there is a "harmless" corruption, it will still
potentially alarm users who happen to format an ext4 file system with
this this change implemented, and then they boot a rescue CD which is
using an older e2fsprogs.

Ultimately I suspect the best approach might be to simply try to
reconstruct the last bgd by attempting to find the inode table in case
the last meta_bg bgd is destroyed.  Since this only comes up for file
systems with a single block group in a meta_bg, it's a relatively easy
thing to do.....

						- Ted
