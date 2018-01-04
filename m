From: Jan Kara <jack@suse.cz>
Subject: Re: [QUESTION] Locking for the transaction buffers
Date: Thu, 4 Jan 2018 17:21:08 +0100
Message-ID: <20180104162108.GD2170@quack2.suse.cz>
References: <8ced83bc-4afa-998e-8015-bab5e2441c49@tu-dortmund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
To: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52172 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753523AbeADQVL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 Jan 2018 11:21:11 -0500
Content-Disposition: inline
In-Reply-To: <8ced83bc-4afa-998e-8015-bab5e2441c49@tu-dortmund.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Mon 18-12-17 18:08:34, Alexander Lochmann wrote:
> I'm studying the locking in the JBD2 subsystem (v4.15-rc4). Doing so, I
> came across the jbd2_journal_commit_transaction function
> where severals lists, e.g., t_forget or t_buffers, are flushed in a
> while loop.
> According to the documentation in inlcude/linux/jbd2.h, the j_list_lock
> lock is the appropriate lock.
> However, it is only used in one out of three cases:
> In fs/jbd2/commit.c:903, the while loop is protected using the
> j_list_lock lock. Whereas it is not used at line 464 and 561.

We are in a situation where all updates to the transaction have finished
and we are starting to commit the transaction. In such situation nobody
should be touching transaction's t_reserved_list or t_buffers_list. OTOH
transaction's t_forget list can still be modified as buffers can be
attached to that list even while transaction is committing (usually those
are buffers that can be discarded once the transaction commits).

> In contrast to that, the insert and remove operations to any of these
> lists are protected by that lock.

Yes, they need to serialize against each other.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
