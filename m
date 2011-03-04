From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH v2] Check for immutable flag in fallocate path
Date: Fri, 04 Mar 2011 09:17:00 +0100
Message-ID: <4D709FFC.6000107@gmail.com>
References: <4D6221B8.9040303@gmail.com> <4D6F5473.2070709@gmail.com> <20110303213903.GL15097@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, xfs@oss.sgi.com,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49773 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1CDIWL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Mar 2011 03:22:11 -0500
In-Reply-To: <20110303213903.GL15097@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dave,

Il 03/03/2011 22:39, Dave Chinner ha scritto:
> WTF?  Why does append mode have any effect on whether we can punch
> holes in a file or not? There's no justification for adding this in
> the commit message. Why is it even in a patch that is for checking
> immutable inodes? What is the point of adding it, when all that will
> happen is people will switch to XFS_IOC_UNRESVSP which has never had
> this limitation?

So according to you, it's legal to do an "unreserve" operation on an
append-only file. It's not the same for me, but if the community said
that this is the right behavior then ok.

> 
> And this asks bigger questions - why would you allow preallocate
> anywhere but at or beyond EOF on an append mode inode? You can only
> append to the file, so if you're going to add limitations based on
> the append flag, you need to think this through a bit more....
> 

I don't understand this point. The theory of operation was:

1) we don't allow any operation (reserve/unreserve) on a immutable file;
2) we don't allow *unreserve* operation on an append-only file (this
check makes sense only for fs that support the unreserve operation).

> 
> Also, like Christoph said, these checks belong in the generic code,
> not in every filesystem. The same checks have to be made for every
> filesystem, so they should be done before calling out the
> filesystems regardless of what functionality the filesystem actually
> supports.
> 

This was related to the first point, if we remove it then it's ok to
check in a common code. Even if I think we should do the check under the
inode lock to avoid race between fallocate and setattr, isn't it?

Marco
