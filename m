From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests: avoid ext4/306 failures caused by incompatible
 mount options
Date: Wed, 29 Jan 2014 16:38:38 -0500
Message-ID: <20140129213838.GF30419@thunk.org>
References: <20140129204502.GC2165@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, esandeen@redhat.com
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52588 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaA2Vit (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jan 2014 16:38:49 -0500
Content-Disposition: inline
In-Reply-To: <20140129204502.GC2165@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 29, 2014 at 03:45:02PM -0500, Eric Whitney wrote:
> ext4/306 will fail when mounting the ext3 file system it creates if an
> ext3-incompatible mount option is applied by _scratch_mount.  This can
> happen if EXT_MOUNT_OPTIONS is defined appropriately in the test
> environment.  For example, the block_validity option is commonly used
> to enhance ext4 testing, and it is not supported by ext3.  Fix this by
> not including any mount options defined by the test environment.

I'm not sure I understand why the test is insisting that the file
system be mounted using ext3.  If the file system is created without
the extents flag, all of the files will be created using indirect
blocks, and fundamentally what this test is getting at is that after
we grow the file system using resize2fs, the new blocks are available
to be allocated and attached to an indirect block file.

We can do this by using ext4; I'm not sure why this test is trying to
use ext3 to set up the test flie system.  It might be better to get
rid of the requirement to create the file system using ext3, since it
will make the test runnable even if the ext3 file system hasn't been
configured into the system and CONFIG_EXT23_AS_EXT4 is not enabled.

IIRC, Eric Sandeen wrote this test --- Eric, am I missing some reason
why it was necessary to use ext3 here?

					- Ted
