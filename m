From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: Correctly handle EOFBLOCKS flag in
 ext4_ext_punch_hole
Date: Wed, 21 Mar 2012 22:13:05 -0400
Message-ID: <20120322021305.GE11157@thunk.org>
References: <1332314639-22875-1-git-send-email-lczerner@redhat.com>
 <1332314639-22875-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33096 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab2CVCNI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 22:13:08 -0400
Content-Disposition: inline
In-Reply-To: <1332314639-22875-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 21, 2012 at 08:23:55AM +0100, Lukas Czerner wrote:
> +	/*
> +	 * This is fugly, but even though we're going to get rid of the
> +	 * EOFBLOCKS_LF in the future, we have to handle it correctly now
> +	 * because there are still versions of e2fsck out there which
> +	 * would scream otherwise. Once the new e2fsck code ignoring
> +	 * this flag is common enough this can be removed entirely.
> +	 */
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)) {
> +		struct ext4_ext_path *path;
> +		ext4_lblk_t last_block;
> +
> +		mutex_lock(&inode->i_mutex);
> +		down_read(&EXT4_I(inode)->i_data_sem);

I was looking at this patch, and I was wondering why we weren't taking
i_mutex earlier in ext4_ext_punch_hole().  The primary use of i_mutex
is to protect writes racing with each other and with truncate.  Given
that punch essentially works like truncate, and all of ext4_truncate()
is run with i_mutex down, and currently ext4_ext_punch_hole() (before
applying this patch) doesn't isn't taking i_mutex at all, I'm
wondering if we can run into problems where punch is racing against a
write --- if the pages are already in mapped, then the write might not
even need to take i_data_sem.

Lukas, Allison --- am I missing something here?

						- Ted
