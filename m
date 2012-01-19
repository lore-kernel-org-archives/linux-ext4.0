From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: ignore EXT4_INODE_JOURNAL_DATA flag with
 delalloc
Date: Thu, 19 Jan 2012 11:50:07 -0500
Message-ID: <20120119165007.GA32029@thunk.org>
References: <1326266607-15211-1-git-send-email-lczerner@redhat.com>
 <1326366224-22885-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41827 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283Ab2ASQuQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jan 2012 11:50:16 -0500
Content-Disposition: inline
In-Reply-To: <1326366224-22885-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 12, 2012 at 12:03:44PM +0100, Lukas Czerner wrote:
> +	/* We do not support data journalling with delayed allocation */
> +	if (!S_ISREG(inode->i_mode) ||
> +	   (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) ||
> +	   (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
> +	   !test_opt(inode->i_sb, DELALLOC)))
> +		return EXT4_INODE_JOURNAL_DATA_MODE;	/* journal data */

It's probably clearer to make avoid the complex boolean expression:

	if (!S_ISREG(inode->i_mode))
		return EXT4_INODE_JOURNAL_DATA_MODE;
	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA))
		return EXT4_INODE_JOURNAL_DATA_MODE;
	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
	    !test_opt(inode->i_sb, DELALLOC)))
		return EXT4_INODE_JOURNAL_DATA_MODE;

You could combine the first two condiionals:

	if (!S_ISREG(inode->i_mode) ||
	    test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
		return EXT4_INODE_JOURNAL_DATA_MODE;
	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
	    !test_opt(inode->i_sb, DELALLOC)))
		return EXT4_INODE_JOURNAL_DATA_MODE;

... but combining || and && where someone has to squint and count
parenthesis can be error-prone.  I can look at either of the above two
and understand quickly what's going on.  With what you had (especially
since the identation of !test_opt(...) wasn't quite right, I had to
squint and think for a bit before I convince dmyself it was correct.

Otherwise, looks good!

					- Ted
