From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext4 compat flag assignments
Date: Wed, 4 Oct 2006 18:19:06 -0600
Message-ID: <20061005001906.GN22010@schatzie.adilger.int>
References: <20060922091520.GC6335@schatzie.adilger.int> <20060928085515.GC27104@openx1.frec.bull.fr> <20061004200440.GB1656@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:24273 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1751243AbWJEATK
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Oct 2006 20:19:10 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061004200440.GB1656@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 04, 2006  16:04 -0400, Theodore Tso wrote:
> On Thu, Sep 28, 2006 at 10:55:15AM +0200, Alexandre Ratchov wrote:
> > struct ext4_super_block
> > {
> > 	/* at offset 0xfe */
> > 	__le32	s_desc_size;		/* Group descriptor size */
> > 	/* at offset 0x150 */
> > 	__le32	s_blocks_count_hi;	/* Blocks count */
> > 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
> > 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
> > 	__le32	s_jnl_blocks_hi[17];	/* Backup of the journal inode */
> > };
> 
> Why do we need to have the high blocks # of the journal inode.
> s_jnl_blocks was just a backup of the i_blocks[] array.  But if we are
> assuming that we will only support 64-bits using extents, we shouldn't
> need s_jnl_blocks_hi[].  How specifically is this array being used in
> the patches?

Good question, I don't know that it is.  Even if the journal was extent
mapped (possible, but would need support in e2fsprogs for this) the
data would be stored in the same sized i_blocks array.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

