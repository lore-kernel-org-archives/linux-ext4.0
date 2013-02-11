From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 00/12] jbd2 optimization and bug fixes
Date: Mon, 11 Feb 2013 16:52:59 +0100
Message-ID: <20130211155259.GF5318@quack.suse.cz>
References: <1360446832-12724-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757722Ab3BKPxB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 10:53:01 -0500
Content-Disposition: inline
In-Reply-To: <1360446832-12724-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 09-02-13 16:53:40, Ted Tso wrote:
> I've been recently looking at journalling code in ext4, and it's clear
> that no one has really been through this code in a while.  It's easy to
> find some easy optimization.
> 
> Some general rules of thumb that developers should keep in mind when
> making changes to ext4:
> 
> 1) It's important to minimize the amount of time that a handle is held
> active, since a journal commit can't be closed until all handles have
> been stopped.  In the ideal world, disk reads and memory allocations
> should be done *before* calling ext4_journal_start().
>
> 2) It's important that number of credits needed for a particular handle
> be large enough; otherwise it's possible that we run out of space in the
> journal without being able to finish the handle.
>
> 3)  It's also important that we not overestimate then number of credits
> needed, since otherwise we might close a transaction too early --- and
> in particular, the process which starts the transaction commit process
> will tend to suffer the greatest amount of latency.
  True but it's not too bad - we give back the credits we didn't use once
the current handle is dropped. But if there are many handles open in
parallel or if the overestimate is really huge, it will have visible
effects. So I agree it's good to keep the estimate as close as resonably
possible to reality.

> Currently enabling quotas cause the number of credits required to
> balloon significantly.  Most of the time we need nowhere the number of
> credits which we reserve, so there's opportunity to optimize things.
> (For example, we could make sure create the quota record is created in a
> seprate transaction.)
  So write(2) and similar calls are already optimized. You are right that
create(2) or unlink(2) still overestimate needed credits only due to
remotely possible worst case.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
