From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: an issue of ext4
Date: Wed, 5 Mar 2014 07:51:05 -0500
Message-ID: <20140305125105.GA11600@thunk.org>
References: <CF3D3A3F.283D%hongchao.zhang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Zhang, Hongchao" <hongchao.zhang@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37321 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbaCEMvK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Mar 2014 07:51:10 -0500
Content-Disposition: inline
In-Reply-To: <CF3D3A3F.283D%hongchao.zhang@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 05, 2014 at 12:33:32PM +0000, Zhang, Hongchao wrote:
> 
> in ext4_fill_super, the variables related to statfs should be
> initialized after journal recovery is completed.  otherwise, if a
> large number of blocks were being allocated before the filesystem
> crashed, then the blocks and inode counters may become negative
> during use and report incorrect values to statfs call.

The ext4_statfs() doesn't use the free blocks and inodes count from
the superblock.  For scalability reasons, we no longer update the
journal values in the superblock while they are in use, but rather
compute them from the sum of the values from the blockgroup
descriptors, and then track them via percpu counters.

Hence, the problem you described isn't an issue in practice.  What we
are doing does mean that values in the superblock are not accurate
while the file system is mounted and if the system crashes before an
file system can be cleanly unmounted --- we do update these values
when the file system is unmounted.  However, using tools such as
dumpe2fs to determine the free blocks/inodes available while the file
system is mounted or after an unclean shutdown was not considered an
important use case, especially compared to the scalability concerns of
supporting high cpu core count systems.

Cheers,

						- Ted
