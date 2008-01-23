From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 24/49] ext4: add block bitmap validation
Date: Wed, 23 Jan 2008 14:06:54 -0800
Message-ID: <20080123140654.fe8c658e.akpm@linux-foundation.org>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
	<1200970948-17903-9-git-send-email-tytso@mit.edu>
	<1200970948-17903-10-git-send-email-tytso@mit.edu>
	<1200970948-17903-11-git-send-email-tytso@mit.edu>
	<1200970948-17903-12-git-send-email-tytso@mit.edu>
	<1200970948-17903-13-git-send-email-tytso@mit.edu>
	<1200970948-17903-14-git-send-email-tytso@mit.edu>
	<1200970948-17903-15-git-send-email-tytso@mit.edu>
	<1200970948-17903-16-git-send-email-tytso@mit.edu>
	<1200970948-17903-17-git-send-email-tytso@mit.edu>
	<1200970948-17903-18-git-send-email-tytso@mit.edu>
	<1200970948-17903-19-git-send-email-tytso@mit.edu>
	<1200970948-17903-20-git-send-email-tytso@mit.edu>
	<1200970948-17903-21-git-send-email-tytso@mit.edu>
	<1200970948-17903-22-git-send-email-tytso@mit.edu>
	<1200970948-17903-23-git-send-email-tytso@mit.edu>
	<1200970948-17903-24-git-send-email-tytso@mit.edu>
	<1200970948-17903-25-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59831 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205AbYAWWH3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 17:07:29 -0500
In-Reply-To: <1200970948-17903-25-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, 21 Jan 2008 22:02:03 -0500 "Theodore Ts'o" <tytso@MIT.EDU> wrote:
> +	if (bh_submit_read(bh) < 0) {
> +		brelse(bh);
> +		ext4_error(sb, __FUNCTION__,
>  			    "Cannot read block bitmap - "
> -			    "block_group = %lu, block_bitmap = %llu",
> -			    block_group, bitmap_blk);
> +			    "block_group = %d, block_bitmap = %llu",
> +			    (int)block_group, (unsigned long long)bitmap_blk);
> +		return NULL;
> +	}
> +	if (!ext4_valid_block_bitmap(sb, desc, block_group, bh)) {
> +		brelse(bh);
> +		return NULL;
> +	}

brelse() should only be used when the bh might be NULL - put_bh()
can be used here.

Please review all ext4/jbd2 code for this trivial speedup.
