From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [Ext4 Secure Delete 7/7v4] ext4/jbd2: Secure Delete: Secure
 delete journal blocks
Date: Mon, 10 Oct 2011 13:47:36 -0600
Message-ID: <20111010134736.5b721a22@bike.lwn.net>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
	<1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53215 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab1JJTrh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 15:47:37 -0400
In-Reply-To: <1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One quick question:

On Fri,  7 Oct 2011 00:11:05 -0700
Allison Henderson <achender@linux.vnet.ibm.com> wrote:

> +	/* Secure delete any blocks still in our range */
> +	if (jbd2_pblk_count > 0)
> +		err = ext4_secure_delete_pblks(journal->j_inode,
> +			jbd2_pblk_start, jbd2_pblk_count);
> +
> +out:
> +	spin_unlock(&journal->j_pair_lock);

ext4_secure_delete_pblks() appears to do its job synchronously - it has
calls to things like sync_dirty_buffer() and such.  How can you do that
while holding ->j_pair_lock?

Thanks,

jon
