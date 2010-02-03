From: tytso@mit.edu
Subject: Re: mount ext2/3 as ext4 - no changes to ext2/3 fs structures?
Date: Wed, 3 Feb 2010 16:08:28 -0500
Message-ID: <20100203210828.GH16384@thunk.org>
References: <88FF0BDF-9F6F-4A2D-A236-C388BFFA145D@kupper.org>
 <532480951001312154g1c927b31xe0181cc301b5a28d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Kupper <thomas@kupper.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54107 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932Ab0BCVIl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Feb 2010 16:08:41 -0500
Content-Disposition: inline
In-Reply-To: <532480951001312154g1c927b31xe0181cc301b5a28d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 31, 2010 at 09:54:27PM -0800, Michael Rubin wrote:
> On Sun, Jan 31, 2010 at 2:31 PM, Thomas Kupper <thomas@kupper.org> wrote:
> > Consider the following scenario: Assume I have a partition
> > formated with ext2 on a computer with some 2.4.x kernel. Now I
> > mount this ext2 partition on another computer as ext4 using a
> > 2.6.29+ kernel. After that I take the disk back to the older
> > computer and mount the ext2 on the 2.4.x kernel with the ext2
> > driver.
> 
> I have seen this work as long as you don't add the "extents" or other
> ext4 specific mount options. Our kernels are not quite as up to date
> as 2.6.29 and we have not done extensive testing with that kernel. Not
> sure anyone has tested this case thoroughly.

Yep, it's a supported feature that mounting a file system previously
intended for ext2 or ext3 on ext4 shouldn't cause it to become
unmountable elsewhere.

Note however that the "extents" ext4 mount options has gone away; if
you want to enable extents on kernels, the supported way to do this
is:

tune2fs -O extents /dev/sda1

Once you do this (and you can do this on a live-mounted ext4
filesystem and it will take effect immediately), any new inodes that
are created will be extent-mapped.

We currently don't have a way of converting extent-mapped inodes back
to the legacy indirect block mapping scheme (a patch to do an off-line
conversion wouldn't be _that_ hard; patches gratefully accepted), so
this is currently a one-way conversion.

						- Ted
