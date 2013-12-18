From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: Fix deadlock when writing in ENOSPC conditions
Date: Wed, 18 Dec 2013 00:45:59 -0500
Message-ID: <20131218054559.GC19434@thunk.org>
References: <1386670440-3158-1-git-send-email-jack@suse.cz>
 <1386670440-3158-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41192 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab3LRFqE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Dec 2013 00:46:04 -0500
Content-Disposition: inline
In-Reply-To: <1386670440-3158-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 11:14:00AM +0100, Jan Kara wrote:
> Akira-san has been reporting rare deadlocks of his machine when running
> xfstests test 269 on ext4 filesystem. The problem turned out to be in
> ext4_da_reserve_metadata() and ext4_da_reserve_space() which called
> ext4_should_retry_alloc() while holding i_data_sem. Since
> ext4_should_retry_alloc() can force a transaction commit, this is a
> lock ordering violation and leads to deadlocks.
> 
> Fix the problem by just removing the retry loops. These functions should
> just report ENOSPC to the caller (e.g. ext4_da_write_begin()) and that
> function must take care of retrying after dropping all necessary locks.
> 
> Reported-and-tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
