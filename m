From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 36/49] ext4: Add EXT4_IOC_MIGRATE ioctl
Date: Fri, 25 Jan 2008 23:15:00 -0500
Message-ID: <20080126041500.GA28889@mit.edu>
References: <1200970948-17903-30-git-send-email-tytso@mit.edu> <1200970948-17903-31-git-send-email-tytso@mit.edu> <1200970948-17903-32-git-send-email-tytso@mit.edu> <1200970948-17903-33-git-send-email-tytso@mit.edu> <1200970948-17903-34-git-send-email-tytso@mit.edu> <1200970948-17903-35-git-send-email-tytso@mit.edu> <1200970948-17903-36-git-send-email-tytso@mit.edu> <1200970948-17903-37-git-send-email-tytso@mit.edu> <20080123140716.e6f5d14f.akpm@linux-foundation.org> <20080124055532.GC7902@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58387 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490AbYAZEPa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jan 2008 23:15:30 -0500
Content-Disposition: inline
In-Reply-To: <20080124055532.GC7902@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 24, 2008 at 11:25:32AM +0530, Aneesh Kumar K.V wrote:
> +static int free_ext_idx(handle_t *handle, struct inode *inode,
> +					struct ext4_extent_idx *ix)
> +{
> +	int i, retval = 0;
> +	ext4_fsblk_t block;
> +	struct buffer_head *bh;
> +	struct ext4_extent_header *eh;
> +
> +	block = idx_pblock(ix);
> +	bh = sb_bread(inode->i_sb, block);
> +	if (!bh)
> +		return -EIO;
> +
> +	eh = (struct ext4_extent_header *)bh->b_data;
> +	if (eh->eh_depth == 0) {
> +		brelse(bh);
> +		ext4_free_blocks(handle, inode, block, 1);
> +	} else {
> +		ix = EXT_FIRST_INDEX(eh);
> +		for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ix++) {
> +			retval = free_ext_idx(handle, inode, ix);
> +			if (retval)
> +				return retval;
> +		}
> +	}
> +	return retval;
> +}

Aneesh, looks like if eh->eh_depth is != 0, bh gets leaked.  This is
how I plan to fix it up:

+static int free_ext_idx(handle_t *handle, struct inode *inode,
+					struct ext4_extent_idx *ix)
+{
+	int i, retval = 0;
+	ext4_fsblk_t block;
+	struct buffer_head *bh;
+	struct ext4_extent_header *eh;
+
+	block = idx_pblock(ix);
+	bh = sb_bread(inode->i_sb, block);
+	if (!bh)
+		return -EIO;
+
+	eh = (struct ext4_extent_header *)bh->b_data;
+	if (eh->eh_depth == 0)
+		ext4_free_blocks(handle, inode, block, 1);
+	else {
+		ix = EXT_FIRST_INDEX(eh);
+		for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ix++) {
+			retval = free_ext_idx(handle, inode, ix);
+			if (retval)
+				break;
+		}
+	}
+	put_bh(bh);
+	return retval;
+}

						- Ted
