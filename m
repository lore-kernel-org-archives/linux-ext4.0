From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] ext3: Convert ext3 to new truncate calling convention
Date: Wed, 25 May 2011 07:48:23 -0400
Message-ID: <20110525114822.GA6251@infradead.org>
References: <1306320216-19368-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1EYLsX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 07:48:23 -0400
Content-Disposition: inline
In-Reply-To: <1306320216-19368-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 25, 2011 at 12:43:36PM +0200, Jan Kara wrote:
> Mostly trivial conversion. We fix a bug that IS_IMMUTABLE and IS_APPEND
> files could not be truncated during failed writes as we change the code.
> In fact we remove the test altogether because do_sys_[f]truncate() and
> may_open() do necessary checks anyway.

This doesn't look quite correct me.  One of the major points of the
new truncate sequence is to to *_truncate_page before updating i_size,
so that we can properly handle an error there.  With your patch it's
still called too late.

