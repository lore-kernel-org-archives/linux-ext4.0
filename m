From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Make ext4_block_in_group() much more efficient
Date: Tue, 26 Mar 2013 23:05:55 -0400
Message-ID: <20130327030555.GB5861@thunk.org>
References: <1364207051-27037-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56180 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab3C0DF5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Mar 2013 23:05:57 -0400
Content-Disposition: inline
In-Reply-To: <1364207051-27037-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 25, 2013 at 11:24:10AM +0100, Lukas Czerner wrote:
> +	actual_group = (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
> +			block) >>
> +		       (EXT4_BLOCK_SIZE_BITS(sb) + EXT4_CLUSTER_BITS(sb) + 3);

The problem with this change is that you are assuming that the number
of blocks per group is equal to block_size * 8.  This is not always
the case; a nonstandard number of blocks per group can be set using
mke2fs's -g option.

						- Ted
