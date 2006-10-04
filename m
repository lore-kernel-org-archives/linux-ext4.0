From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 compat flag assignments
Date: Wed, 4 Oct 2006 16:04:40 -0400
Message-ID: <20061004200440.GB1656@thunk.org>
References: <20060922091520.GC6335@schatzie.adilger.int> <20060928085515.GC27104@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:19161 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751017AbWJDUEp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Oct 2006 16:04:45 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060928085515.GC27104@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 28, 2006 at 10:55:15AM +0200, Alexandre Ratchov wrote:
> struct ext4_super_block
> {
> 	/* at offset 0xfe */
> 	__le32	s_desc_size;		/* Group descriptor size */
> 	/* at offset 0x150 */
> 	__le32	s_blocks_count_hi;	/* Blocks count */
> 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
> 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
> 	__le32	s_jnl_blocks_hi[17];	/* Backup of the journal inode */
> };

Why do we need to have the high blocks # of the journal inode.
s_jnl_blocks was just a backup of the i_blocks[] array.  But if we are
assuming that we will only support 64-bits using extents, we shouldn't
need s_jnl_blocks_hi[].  How specifically is this array being used in
the patches?


						- Ted

