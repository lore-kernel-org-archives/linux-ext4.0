From: Vasily Averin <vvs@sw.ru>
Subject: Re: How Inactive may be much greather than cached?
Date: Thu, 18 Oct 2007 14:33:32 +0400
Message-ID: <4717367C.1040902@sw.ru>
References: <4716FC04.6070107@sw.ru> <200710181627.27827.nickpiggin@yahoo.com.au> <471707BD.4000203@sw.ru> <200710181727.01128.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, devel@openvz.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:30831 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726AbXJRKdm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 06:33:42 -0400
In-Reply-To: <200710181727.01128.nickpiggin@yahoo.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Nick Piggin wrote:
> Some filesystems, including I believe, ext3 with data=ordered,
> can leave orphaned pages around after they have been truncated
> out of the pagecache. These pages get left on the LRU and vmscan
> reclaims them pretty easily.
> 
> Try ext3 data=writeback, or even ext2.

thanks, data=writeback helps.

Resume: ext3 with data=ordered gets bh with data and moves it to journal
transaction. If transaction handled immediately, ext3 frees bh on this page, and
then frees this page.
However if journal delays processing of this transaction, ext3 cannot free bh
that is still busy. Later jbd layer decrements bh counter but it makes nothing
with data page that is not freed and stays inactive.
