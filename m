From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/22] ext4: Only call out to crc32c if necessary
Date: Mon, 5 Dec 2011 10:52:26 -0500
Message-ID: <20111205155226.GA32031@thunk.org>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
 <20111128232642.19194.80905.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48890 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab1LEPw2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 10:52:28 -0500
Content-Disposition: inline
In-Reply-To: <20111128232642.19194.80905.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 28, 2011 at 03:26:43PM -0800, Darrick J. Wong wrote:
> +	/* Load the checksum driver */
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> +		sbi->s_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
> +		if (IS_ERR(sbi->s_chksum_driver)) {
> +			ret = PTR_ERR(sbi->s_chksum_driver);
> +			sbi->s_chksum_driver = NULL;
> +			goto failed_mount;
> +		}
> +	}

Unless the crypto engine printk's a message if the crc32c algorithm is
not available (perhaps even if it does), it's probably going to be a
good idea to issue an ext4_msg() saying that we're failing because we
couldn't load the crc32c crypto module.  Otherwise the user will get a
mysterious failure (including a message from mount to check 'dmesg |
tail'), and then when they look at the kernel messages, they won't see
what might have gone wrong, and then they'll send a complaint to
ext3-users or linux-ext4....

						- Ted
