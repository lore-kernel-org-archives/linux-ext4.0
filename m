From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] ext3: Convert ext3 to new truncate calling convention
Date: Fri, 27 May 2011 03:16:40 -0400
Message-ID: <20110527071640.GA5330@infradead.org>
References: <1306320216-19368-1-git-send-email-jack@suse.cz>
 <20110525114822.GA6251@infradead.org>
 <20110526142337.GA5123@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58556
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758682Ab1E0Io3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 May 2011 04:44:29 -0400
Content-Disposition: inline
In-Reply-To: <20110526142337.GA5123@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 26, 2011 at 04:23:37PM +0200, Jan Kara wrote:
> > This doesn't look quite correct me.  One of the major points of the
> > new truncate sequence is to to *_truncate_page before updating i_size,
> > so that we can properly handle an error there.  With your patch it's
> > still called too late.
>   OK, I missed this point (frankly, handling of error from
> ext3_block_truncate_page() does not seem like a huge win when we cannot
> handle error anywhere else during truncate but it's an improvement I
> agree). I'll move ext3_block_truncate_page() before the setting of i_size.
> Thanks for having a look at the patch.

Btw, I think ext4 has the same issue.

