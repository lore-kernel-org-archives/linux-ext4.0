From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] update i_disksize coherently with block allocation
Date: Sat, 23 Aug 2014 18:00:29 -0400
Message-ID: <20140823220029.GC6236@thunk.org>
References: <1408707147-22482-1-git-send-email-dmonakhov@openvz.org>
 <1408707147-22482-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46221 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaHWWAi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Aug 2014 18:00:38 -0400
Content-Disposition: inline
In-Reply-To: <1408707147-22482-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 22, 2014 at 03:32:27PM +0400, Dmitry Monakhov wrote:
> Writeback call trace looks like follows:
> ext4_writepages
>  while(nr_pages)
>  ->journal_start
>  ->mpage_map_and_submit_extent -> may alloc some blocks
>    ->mpage_map_one_extent
>  ->journal_stop
> In case of delalloc block i_disksize may be less than i_size. So we have to
> update i_disksize each time we allocated and submitted some blocks beyond
> i_disksize. And we MUST update it in the same transaction, otherwise this
> result in fs-inconsistency in case of upcoming power-failure.
> 
> Another possible way to fix that issue is to insert inode to orhphan list
> on ext4_writepages entrance.
> 
> testcase: xfstest generic/019
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Hi Dmitry, were you seeing generic/019 fail before this patch series?
I've been trying to build a kernel with CONFIG_FAIL_MAKE_REQUEST and I
haven't been able to get generic/019 to fail on me.  Is there
something else we need in order to reliably trigger the test fail?

Thanks,

					- Ted
