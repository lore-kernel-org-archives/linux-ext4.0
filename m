From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH][7/28] e2fsprogs-extents.patch
Date: Mon, 18 Feb 2008 12:12:44 -0600
Message-ID: <47B9CA9C.3010408@redhat.com>
References: <20080202075943.GB23836@webber.adilger.int> <20080202082559.GG31694@webber.adilger.int> <20080202082701.GH31694@webber.adilger.int> <47B9C6E5.2010304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbYBRSNJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2008 13:13:09 -0500
In-Reply-To: <47B9C6E5.2010304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> So this trips up on things like sockets, fifos, and block & char nodes.

Just to demonstrate; doing this on ext4:

mknod mnt/block b 1 1
mknod mnt/char c 1 1
mknod mnt/fifo p
mksock mnt/sock

mkdir -p
mnt/verylongdir12345678901234567890/verylongdir12345678901234567890/verylongdir12345678901234567890
ln -s
mnt/verylongdir12345678901234567890/verylongdir12345678901234567890/verylongdir12345678901234567890
mnt/longlink

yields an unhappy fsck w/ e2fsprogs-interim:

e2fsck 1.40.6 (09-Feb-2008)
Pass 1: Checking inodes, blocks, and sizes
Inode 12 has EXTENT_FL set, but is not in extents format
Fix? no

Inode 13 has EXTENT_FL set, but is not in extents format
Fix? no

Inode 14 has EXTENT_FL set, but is not in extents format
Fix? no

Inode 15 has EXTENT_FL set, but is not in extents format
Fix? no

Inode 17 has EXTENT_FL set, but is not in extents format
Fix? no

Pass 2: Checking directory structure
Inode 12 (/block) is an illegal block device.
Clear? no

Inode 13 (/char) is an illegal character device.
Clear? no

Inode 14 (/fifo) is an illegal FIFO.
Clear? no

Inode 15 (/sock) is an illegal socket.
Clear? no

Symlink /longlink (inode #17) is invalid.
Clear? no

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

-Eric
