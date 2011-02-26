From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] e2fsck: Add QCOW2 support
Date: Sat, 26 Feb 2011 11:44:42 -0500
Message-ID: <20110226164442.GD2924@thunk.org>
References: <1298638173-25050-1-git-send-email-lczerner@redhat.com>
 <1298638173-25050-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42167 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab1BZQop (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Feb 2011 11:44:45 -0500
Content-Disposition: inline
In-Reply-To: <1298638173-25050-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 25, 2011 at 01:49:33PM +0100, Lukas Czerner wrote:
> This commit adds QCOW2 support for e2fsck. In order to avoid creating
> real QCOW2 image support, which would require creating a lot of code, we
> simply bypass the problem by converting the QCOW2 image into raw image
> and than let e2fsck work with raw image. Conversion itself can be quite
> fast, so it should not be a serious slowdown.
> 
> Add '-Q' option to specify path for the raw image. It not specified the
> raw image will be saved in /tmp direcotry in format
> <qcow2_filename>.raw.XXXXXX, where X chosen randomly.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

If we're just going to convert the qcow2 image into a raw image, that
means that if someone sends us a N gigabyte QCOW2 image, it will lots
of time (I'm not sure I agree with the "quite fast part"), and consume
an extra N gigabytes of free space to create the raw image.

In that case, I'm not so sure we really want to have a -Q option to
e2fsck.  We might be better off simply forcing the use of e2image to
convert the image back.

Note that the other reason why it's a lot better to be able to allow
e2fsck to be able to work on the raw image directly is that if a
customer sends a qcow2's metadata-only image from their 3TB raid
array, we won't be able to expand that to a raw image because of
ext2/3/4's 2TB maximum file size limit.  The qcow2 image might be only
a few hundreds of megabytes, so being able to have e2fsck operate on
that image directly would be a huge win. 

Adding iomanager support would also allow debugfs to access the qcow2
image directly --- also a win.

Whether or not we add the io_manager support right away (eventually I
think it's a must have feature), I don't think having a "decompress a
qcow2 image to a sparse raw image" makes sense as an explicit e2fsck
option.  It just clutters up the e2fsck option space, and people might
be confused because now e2fsck could break because there wasn't enough
free space to decompress the raw image.  Also, e2fsck doesn't delete
the /tmp file afterwards, which is bad --- but if it takes a large
amount of time to create the raw image, deleting afterwards is a bit
of waste as well.  Probably better to force the user to manage the
converted raw file system image.

					- Ted
