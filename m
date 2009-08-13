From: Curt Wohlgemuth <curtw@google.com>
Subject: Questions on ext4 and writeback
Date: Thu, 13 Aug 2009 09:09:58 -0700
Message-ID: <6601abe90908130909v582df37aq773e95f49f4a1248@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:5317 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZHMQKC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Aug 2009 12:10:02 -0400
Received: from spaceape8.eur.corp.google.com (spaceape8.eur.corp.google.com [172.28.16.142])
	by smtp-out.google.com with ESMTP id n7DGA1NO032688
	for <linux-ext4@vger.kernel.org>; Thu, 13 Aug 2009 17:10:02 +0100
Received: from bwz9 (bwz9.prod.google.com [10.188.26.9])
	by spaceape8.eur.corp.google.com with ESMTP id n7DG9wcX022657
	for <linux-ext4@vger.kernel.org>; Thu, 13 Aug 2009 09:09:59 -0700
Received: by bwz9 with SMTP id 9so771807bwz.41
        for <linux-ext4@vger.kernel.org>; Thu, 13 Aug 2009 09:09:58 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've got a question about how ext4 handles the writeback control fields in
ext4_da_writepages().

I understand how the big picture works:  since we're doing delayed
allocation, when we're asked to write out a range of dirty pages, we need to
do allocation *now*, and we want to do allocation on the largest contiguous
range of pages possible.

So when __mpage_da_writepage() finds a page discontinuity, we submit the
page extent we have so far for I/O, and call redirty_page_for_writepage() on
the current page, skip the rest of the pages in the pagevec, and wait for a
new transaction.

On return from write_cache_pages(), ext4_da_writepages() will check the
return value from __mpage_da_writepage(), and if it's MPAGE_DA_EXTENT_TAIL,
will bump the number of pages written, and possibly cause another loop to
handle the rest of the pages (after the discontinuity).

What I don't understand is why wbc->pages_skipped is reset in this case.

I *think* that ext4_da_writepages() is trying to undo the effect of
redirty_page_for_writepage() to increment pages_skipped -- since we didn't
really skip this page, we only postponed its handling to the next pagevec.

But the actual submittal of I/O for the previous extent might cause
pages_skipped to be bumped, right?  Removing these increments might cause
the accounting to be incorrect, it seems to me.

I think it would be safer to explicitly decrement wbc->pages_skipped after a
call to redirty_page_for_writepage(), rather than reset this value to what
it was when ext4_da_writepages() was called.  Can somebody help me
understand where I might be mistaken?

Thanks,
Curt
