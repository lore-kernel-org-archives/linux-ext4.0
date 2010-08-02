From: Jan Kara <jack@suse.cz>
Subject: Re: BUG? ext3: Allocate blocks over quota limit with mmap
Date: Mon, 2 Aug 2010 14:43:59 +0200
Message-ID: <20100802124359.GB3278@quack.suse.cz>
References: <4C50E297.5090205@rs.jp.nec.com>
 <4C56534A.5030806@rs.jp.nec.com>
 <87ocdlvbaz.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, akpm@linux-foundation.org,
	adilger@dilger.ca, Jan Kara <jack@suse.cz>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34598 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab0HBMog (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Aug 2010 08:44:36 -0400
Content-Disposition: inline
In-Reply-To: <87ocdlvbaz.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-08-10 09:22:12, Dmitry Monakhov wrote:
> Akira Fujita <a-fujita@rs.jp.nec.com> writes:
> 
> > Hi ext3 maintainers,
> >
> > Could you look into this?
> > If this is not a problem, it is good though.
> Actually this is a problem. Because this issue makes quota just a fake
> limit. I've done this test for ext4 and was satisfied with result,
> but was too lazy to perform it on ext3/2 :(
> At least we have to have testcase for that in xfstest-qa.
> It seems that private page_mkwrite will be sufficient.
> I'm working on that.
  Yes, it's a long standing bug. Another manifestation of the bug is that
we just throw away user's data without warning if we really cannot find
space for it. Fixing it isn't completely trivial - doing block allocation
during page_mkwrite really sucks performance-wise (tried that) so we
basically have to implement delayed allocation for ext3 (and other
filesystems) for mmaped writes and do reservation on page_mkwrite time and
allocation on writepage time. I already have patches doing that but they
depended on the truncate rewrite patch series and that was dragging on and
on for half an year or so. Now I guess it's right time to rebase them and
start pushing them again...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
