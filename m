From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/54] libext2fs: Change ext4 on-disk layout to support
 metadata checksumming
Date: Fri, 9 Mar 2012 17:04:35 -0500
Message-ID: <20120309220435.GC5635@thunk.org>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
 <20120306235734.11945.46038.stgit@elm3b70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48637 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab2CIWEr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Mar 2012 17:04:47 -0500
Content-Disposition: inline
In-Reply-To: <20120306235734.11945.46038.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 06, 2012 at 03:57:34PM -0800, Darrick J. Wong wrote:
> Define flags and extend ext4 structure definitions to support metadata
> checksumming.  Ted T'so covered many of these fields in an earlier patch, but
> there are more required changes to the disk layout.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

> @@ -619,7 +630,7 @@ struct ext2_super_block {
>  	__u64   s_mmp_block;            /* Block for multi-mount protection */
>  	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
>  	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
> -	__u8    s_reserved_char_pad;
> +	__u8    s_checksum_type;	/* metadata checksum algorithm */
>  	__u16	s_reserved_pad;		/* Padding to next 32bits */
>  	__u64	s_kbytes_written;	/* nr of lifetime kilobytes written */
>  	__u32	s_snapshot_inum;	/* Inode number of active snapshot */

Note: when you change the superblock definition, you *must* also
update the test in lib/ext2fs/tst_super_size.c.

If you don't then running "make check" from the top-level of the build
tree will likely bomb out.  And you will also reveal to me that you
haven't run the full set of regression tests before submitting your
patch series.  :-)

					- Ted
