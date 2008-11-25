From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RESEND][PATCH 0/3 BUG,RFC] release block-device-mapping
	buffer_heads which have the filesystem private data for avoiding
	oom-killer
Date: Tue, 25 Nov 2008 02:32:24 -0500
Message-ID: <20081125073224.GI20928@mit.edu>
References: <20081120092711.231c69bf.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, sct@redhat.com,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081120092711.231c69bf.toshi.okajima@jp.fujitsu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Okajima-san,

I've added your patches to the ext4 patch queue for testing.  I did
make some changes to the commit descriptions for clarity's sake

-------------------------
vfs: add releasepages hooks to block devices which can be used by file systems

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

Implement blkdev_releasepage() to release the buffer_heads and page
after we release private data which belongs to a client of the block
device, such as a filesystem.

blkdev_releasepage() call the client's releasepage() which is
registered by blkdev_register_client_releasepage() to release its
private data.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
-------------------------
ext3: provide function to release journal heads under memory pressure

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

Pages in the page cache belonging to ext3 data files are released via
the ext3_releasepage() function specified in the ext3 inode's
address_space_ops.  However, metadata blocks (such as indirect blocks,
directory blocks, etc) are managed via the block device
address_space_ops, and they can not be released by
try_to_free_buffers() if they have a journal head attached to them.

To address this, we supply a release_metadata function which is called
by the block device's blkdev_releasepage() function, which calls
journal_try_to_free_buffers() function to free the metadata.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
-------------------------
ext4: implement release_metadata to release private data under memory pressure

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

Pages in the page cache belonging to ext4 data files are released via
the ext4_releasepage() function specified in the ext4 inode's
address_space_ops.  However, metadata blocks (such as indirect blocks,
directory blocks, etc) are managed via the block device
address_space_ops, and they can not be released by
try_to_free_buffers() if they have a journal head attached to them.

To address this, we supply a release_metadata function which is called
by the block device's blkdev_releasepage() function, which calls
journal_try_to_free_buffers() function to free the metadata.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
----------------------

Also, in the 2nd and 3rd patches, I made change to the comment
describing ext[34]_release_metadata.  It now reads:

/*
 * Try to release metadata pages (indirect blocks, directories) which are
 * mapped via the block device.  Since these pages could have journal heads
 * which would prevent try_to_free_buffers() from freeing them, we must use
 * jbd[2] layer's try_to_free_buffers() function to release them.
 */

I hope you agree these changes are more descriptive of what is going
on in the patch.

Best regards,

					- Ted
