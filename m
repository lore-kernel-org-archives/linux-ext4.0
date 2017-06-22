From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/32] ext4: xattr-in-inode support
Date: Wed, 21 Jun 2017 21:16:08 -0400
Message-ID: <20170622011608.3uhx32zgl3t3n3t7@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <andreas.dilger@intel.com>,
        Kalpak Shah <kalpak.shah@sun.com>,
        James Simmons <uja.ornl@gmail.com>
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57302 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751126AbdFVBQW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Jun 2017 21:16:22 -0400
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 21, 2017 at 02:21:11PM -0700, Tahsin Erdogan wrote:
> From: Andreas Dilger <andreas.dilger@intel.com>
> 
> Large xattr support is implemented for EXT4_FEATURE_INCOMPAT_EA_INODE.
> 
> If the size of an xattr value is larger than will fit in a single
> external block, then the xattr value will be saved into the body
> of an external xattr inode.
> 
> The also helps support a larger number of xattr, since only the headers
> will be stored in the in-inode space or the single external block.
> 
> The inode is referenced from the xattr header via "e_value_inum",
> which was formerly "e_value_block", but that field was never used.
> The e_value_size still contains the xattr size so that listing
> xattrs does not need to look up the inode if the data is not accessed.
> 
> struct ext4_xattr_entry {
>         __u8    e_name_len;     /* length of name */
>         __u8    e_name_index;   /* attribute name index */
>         __le16  e_value_offs;   /* offset in disk block of value */
>         __le32  e_value_inum;   /* inode in which value is stored */
>         __le32  e_value_size;   /* size of attribute value */
>         __le32  e_hash;         /* hash value of name and value */
>         char    e_name[0];      /* attribute name */
> };
> 
> The xattr inode is marked with the EXT4_EA_INODE_FL flag and also
> holds a back-reference to the owning inode in its i_mtime field,
> allowing the ext4/e2fsck to verify the correct inode is accessed.
> 
> Lustre-Jira: https://jira.hpdd.intel.com/browse/LU-80
> Lustre-bugzilla: https://bugzilla.lustre.org/show_bug.cgi?id=4424
> Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
> Signed-off-by: James Simmons <uja.ornl@gmail.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Applied, thanks.

					- Ted
