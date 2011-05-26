From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] ext3: Convert ext3 to new truncate calling
 convention
Date: Thu, 26 May 2011 16:23:37 +0200
Message-ID: <20110526142337.GA5123@quack.suse.cz>
References: <1306320216-19368-1-git-send-email-jack@suse.cz>
 <20110525114822.GA6251@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450Ab1EZOXj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 May 2011 10:23:39 -0400
Content-Disposition: inline
In-Reply-To: <20110525114822.GA6251@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 25-05-11 07:48:23, Christoph Hellwig wrote:
> On Wed, May 25, 2011 at 12:43:36PM +0200, Jan Kara wrote:
> > Mostly trivial conversion. We fix a bug that IS_IMMUTABLE and IS_APPEND
> > files could not be truncated during failed writes as we change the code.
> > In fact we remove the test altogether because do_sys_[f]truncate() and
> > may_open() do necessary checks anyway.
> 
> This doesn't look quite correct me.  One of the major points of the
> new truncate sequence is to to *_truncate_page before updating i_size,
> so that we can properly handle an error there.  With your patch it's
> still called too late.
  OK, I missed this point (frankly, handling of error from
ext3_block_truncate_page() does not seem like a huge win when we cannot
handle error anywhere else during truncate but it's an improvement I
agree). I'll move ext3_block_truncate_page() before the setting of i_size.
Thanks for having a look at the patch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
