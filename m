From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: don't abort if flushing file data failed
Date: Thu, 31 Jul 2008 22:33:59 -0400
Message-ID: <20080801023358.GC8736@mit.edu>
References: <1217118414-18636-1-git-send-email-tytso@mit.edu> <1217118414-18636-2-git-send-email-tytso@mit.edu> <1217118414-18636-3-git-send-email-tytso@mit.edu> <1217118414-18636-4-git-send-email-tytso@mit.edu> <488EB060.7080303@hitachi.com> <20080729123513.GG9378@mit.edu> <48915500.3050500@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36731 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752190AbYHACeF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 22:34:05 -0400
Content-Disposition: inline
In-Reply-To: <48915500.3050500@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 03:00:32PM +0900, Hidehiro Kawai wrote:
> I tested this patch on 2.6.27-rc1, but it didn't work properly.
> Then, I noticed two mistakes.
> 
> (1) journal_submit_data_buffers() just submits I/Os, doesn't wait
>     their completion.  We have to check file data write errors
>     after calling journal_finish_inode_data_buffers()
> (2) AS_EIO is cleared by wait_on_page_writeback_range(), so we
>     have to set it again

Thank you very much for catching these errors; you are very correct!  

> I attached the revised patch below.  journal_submit_data_buffers()
> can return error, but it wouldn't be write I/O error AFAIK, so I
> didn't touched.

I've replaced the patch with your revised patch in the ext4 patch
queue; thanks again for double-checking the patch and offering the
revised version.

Many thanks,

						- Ted
