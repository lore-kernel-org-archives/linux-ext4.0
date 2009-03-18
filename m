From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Add support for data=alloc_on_commit mode
Date: Wed, 18 Mar 2009 14:12:15 +0100
Message-ID: <20090318131215.GA11965@atrey.karlin.mff.cuni.cz>
References: <1237259998-12656-1-git-send-email-tytso@mit.edu> <20090317092859.GA30636@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46113 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbZCRNMR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Mar 2009 09:12:17 -0400
Content-Disposition: inline
In-Reply-To: <20090317092859.GA30636@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, Mar 16, 2009 at 11:19:58PM -0400, Theodore Ts'o wrote:
> > Add an ext3 bug-for-bug compatible analogue for data=ordered mode.  In
> > this mode, we force all delayed allocation blocks involved with the
> > to-be-commited transaction to be allocated, and then flushed out to
> > disk before the transaction is commited.
> > 
> 
> Wouldn't this cause a deadlock ? We want to commit a transaction because
> we don't have enough journal space (via journal_start) and now that would cause block
> allocation which would do another journal_start()
  Yes, that's exactly what I think. We cannot start a transaction while
committing another transaction. Also you must put the block allocation
into the transaction you're going to commit because of data consistency
guarantees.
  So if you want to do "alloc on commit" you have to reserve enough
credits to the running transaction at the "block reservation" time and
then use them for allocation at commit time. But this gets complex
because the number of needed credits is hard to estimate (we don't know how
many bitmaps / group descriptors we're going to modify). I'm not yet
sure how to solve this problem...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
