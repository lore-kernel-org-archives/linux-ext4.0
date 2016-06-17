From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2] ext4: optimize ext4_should_retry_alloc() to improve
 ENOSPC performance
Date: Fri, 17 Jun 2016 12:10:07 +0200
Message-ID: <20160617101007.GA26350@quack2.suse.cz>
References: <1465353418-12897-1-git-send-email-tytso@mit.edu>
 <1465354006-15091-1-git-send-email-tytso@mit.edu>
 <20160616192000.GE2106@quack2.suse.cz>
 <017458DB-A479-4462-BB81-30C321F593B4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbcFQKSL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jun 2016 06:18:11 -0400
Content-Disposition: inline
In-Reply-To: <017458DB-A479-4462-BB81-30C321F593B4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 16-06-16 14:11:28, Andreas Dilger wrote:
> On Jun 16, 2016, at 1:20 PM, Jan Kara <jack@suse.cz> wrote:
> > 
> > Well, since ext4_mb_free_metadata() is the only user of
> > ext4_journal_callback_add(), ext4_journal_callback_add() won't have any
> > user after your patch. Maybe we could just stop playing these abstraction
> > games nobody currently uses and just implement a helper function to add
> > freeing callback to the transaction list including increment of the pending
> > counter.
> 
> We use the journal callback for Lustre servers.  Please don't remove it.

I didn't really mean to rewrite the callback infrastructure. I just meant
to change the helper function to fit in-tree users. If Lustre needs to do
something else, it is free to have its own helper function which attaches
callbacks to the transaction's list.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
