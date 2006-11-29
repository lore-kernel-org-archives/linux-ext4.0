From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 1/12] ext3 balloc: reset windowsz when full
Date: Wed, 29 Nov 2006 05:46:17 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0611290530250.32007@blonde.wat.veritas.com>
References: <1164773634.4341.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@osdl.org>, Mel Gorman <mel@skynet.ie>,
	"Martin J. Bligh" <mbligh@mbligh.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from excu-mxob-2.symantec.com ([198.6.49.23]:17383 "EHLO
	excu-mxob-2.symantec.com") by vger.kernel.org with ESMTP
	id S934180AbWK2Fvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 00:51:42 -0500
Received: from [172.21.56.25]([172.21.56.25]) (1575 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1GpIGd-0000I8C@megami.veritas.com>
	for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2006 21:45:59 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
To: Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <1164773634.4341.34.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 28 Nov 2006, Mingming Cao wrote:

> Port a series ext2 balloc patches from Hugh to ext3/4. The first 6
> patches are against ext3, and the rest are aginst ext4.

Thanks for all that, Mingming:
whichever is appropriate, all twelve
Acked-by: Hugh Dickins <hugh@veritas.com>
or
Signed-off-by: Hugh Dickins <hugh@veritas.com>

I'll think about your other mails, those that need further thought,
later on: I need to pin down more accurately the repetitious sequence of
reservations in the mistaken case - maybe it indicated further issues,
maybe not; and I need to consider our different views of the my_rsv
find_next_usable_block.

Hugh
