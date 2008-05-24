From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [Take2 PATCH 00/10][e2fsprogs] Initial blk64_t capable API
	calls.
Date: Sat, 24 May 2008 19:28:36 -0400
Message-ID: <20080524232835.GB5970@mit.edu>
References: <20080521175325.18810.25160.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56612 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108AbYEXX3d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 May 2008 19:29:33 -0400
Content-Disposition: inline
In-Reply-To: <20080521175325.18810.25160.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 21, 2008 at 12:53:25PM -0500, Jose R. Santos wrote:
> 
> The following series of patches implement API call needed to handle
> 64-bit block numbers.  Im concentrating mainly in providing the API
> call first and if the interfaces are sane, we can go ahead and start
> using them in the rest of libext2fs and the user space programs.
> 
> I've run checkpatch and make check on each individual patch in the
> series so they should be ready to add to the main repository if the
> interfaces are acceptable.

Jose, running "make check" with these configure options resulted in a
failure:

'--enable-elf-shlibs' '--enable-blkid-debug' '--enable-testio-debug' '--enable-maintainer-mode' '--enable-blkid-devmapper' '--enable-jbd-debug'

Part of the problem was the test_io manager didn't have 64-bit
support.  I fixed that, and rebased your patch series, but it still
died with a seg fault in the test u_undoe2fs_mke2fs.  

Checking out the undo_io manager, it's obvious why; it doesn't yet
have 64-bit support.  I'm not sure how you missed this, if you were
running "make check" after each patch.  What version of e2fsprogs was
your patches based off of?

          					- Ted


% more u_undoe2fs_mke2fs.log 
mke2fs -q -F -o Linux -b 1024 test.img
mke2fs 1.41-WIP (27-Apr-2008)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
64 inodes, 512 blocks
25 blocks (4.88%) reserved for the super user
First data block=1
Maximum filesystem blocks=524288
1 block group
8192 blocks per group, 8192 fragments per group
64 inodes per group

Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done

md5sum before mke2fs 4a393ac4351a41501aca1ad2917430b9
using mke2fs to test undoe2fs
Overwriting existing filesystem; this can be undone using the command:
    e2undo .//mke2fs-test.img.e2undo ./test.img

md5sum after mke2fs a34e9c16307770eb318a6afa39e127f6
check_filesystem: Unknown code ext2 104 Failed tdb_fetch Record does not exist

md5sum after undoe2fs a34e9c16307770eb318a6afa39e127f6
