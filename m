From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Wed, 04 Nov 2009 15:57:22 +0100
Message-ID: <87zl728hil.fsf@basil.nowhere.org>
References: <1256647729-29834-1-git-send-email-jack@suse.cz>
	<1256647729-29834-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:33142 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513AbZKDO5T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Nov 2009 09:57:19 -0500
In-Reply-To: <1256647729-29834-5-git-send-email-jack@suse.cz> (Jan Kara's message of "Tue, 27 Oct 2009 13:48:49 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:
>  	ext4_io_end_t *cur_aio_dio;
> +
> +	/*
> +	 * Transactions that contain inode's metadata needed to complete
> +	 * fsync and fdatasync, respectively.
> +	 */
> +	atomic_t i_sync_tid;
> +	atomic_t i_datasync_tid;

This might be a stupid question, but the atomic implies you don't hold
any kind of reference to the transaction. So what prevents these IDs
from wrapping while in there? Given it would be probably take a long
time today, but might be not fully future proof to very fast future IO
devices.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
