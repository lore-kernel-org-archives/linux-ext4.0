From: tytso@mit.edu
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Date: Thu, 24 Dec 2009 18:05:12 -0500
Message-ID: <20091224230512.GA32757@thunk.org>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756178AbZLXXFV@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 25, 2009 at 01:28:34AM +0300, Alexander Beregalov wrote:
> 
> Kernel is 2.6.33-rc1-00366-g2f99f5c
> Ext4 mounts ext3 filesystem
> 
> kernel BUG at fs/ext4/inode.c:1063!

OK, that's this BUG which is triggering:

	if (mdb_free) {
		/* Account for allocated meta_blocks */
		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
		BUG_ON(mdb_free < mdb_claim);  <------- BUG triggered
		mdb_free -= mdb_claim;

Can you replicate this?  If so, I'd like to ask you to replicate with
the following debugging patch applied:

--- fs/ext4/inode.c	2009-12-24 17:55:03.736366001 -0500
+++ fs/ext4/inode.c.new	2009-12-24 18:02:58.556366024 -0500
@@ -1060,6 +1060,10 @@
 	if (mdb_free) {
 		/* Account for allocated meta_blocks */
 		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
+		if (mdb_free < mdb_claim)
+			ext4_msg(inode->i_sb, KERN_ERR, "inode #%lu: "
+				 "mdb_free (%d) < mdb_claim (%d) BUG\n",
+				 inode->i_ino, mdb_free, mdb_claim);
 		BUG_ON(mdb_free < mdb_claim);
 		mdb_free -= mdb_claim;

Then once you get the inode number (suppose it's 12345), please send
the output of the following debugfs commands:

debugfs: stat <12345>
debugfs: ncheck 12345

Thanks!!

					- Ted
