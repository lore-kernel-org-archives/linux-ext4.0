From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [BUG][PATCH 1/4] ext3: fix a cause of __schedule_bug via	blkdev_releasepage
Date: Mon, 15 Dec 2008 11:21:59 +0900
Message-ID: <4945BF47.5090508@jp.fujitsu.com>
References: <20081202200647.72cc5807.toshi.okajima@jp.fujitsu.com> <20081208140138.GA17700@mit.edu> <4941B63A.3090302@jp.fujitsu.com> <20081212062148.GJ10890@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: aneesh.kumar@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51732 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYLOCWJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Dec 2008 21:22:09 -0500
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id mBF2M6hk020013
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Mon, 15 Dec 2008 11:22:06 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 5800245DE62
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2008 11:22:06 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 14C2545DE5D
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2008 11:22:06 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id DC7871DB8042
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2008 11:22:05 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 48C7DE18003
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2008 11:22:05 +0900 (JST)
In-Reply-To: <20081212062148.GJ10890@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted-san,

Theodore Tso wrote:
 > On Fri, Dec 12, 2008 at 09:54:18AM +0900, Toshiyuki Okajima wrote:
 > > > To tell the truth, at first, I imagined the same patch as yours to fix this
 > > > problem. But I have made another patch because I thought that ext3(or ext4)
 > > > should not know the contents of the processing of journal_try_to_free_buffers
 > > >  in detail. (ext3 should not know there is a possibility to call
 > > > journal_wait_for_transaction_sync_data from journal_try_to_free_buffers.)
 >
 > I agree, but ext3 doesn't need to know that.  What my change did was
 > to mask off the _GFP_WAIT flag, which prohibits the function it calls
 > from blocking, because it knows that its caller is holding a spinlock.
 >
 > And actually, come to think of it.  We can do even better; the right
 > fix is to have blkdev_releasepage() mask off the _GFP_WAIT flag; this
 > is the function which is taking spinlock, and by masking off the
 > __GFP_WAIT flag, this is simply requesting all of the downstream
 > functions not to block, but to do the best job they can do without
 > blocking.  It doesn't need to know whether it's going to call
 > log_wait_commit(), or anything else; all it needs to do is request
 > "please don't block".

 > That means we only make the request once, in the function which is
 > taking spinlock, so all of the per-filesystem implementations of
 > release_metadata() don't need to know that its caller is holding a
 > spinlock.

OK. I agree your last change.

I also think blkdev_releasepage must do something so that downstream
functions of it don't sleep. Masking off the _GFP_WAIT flag is the
easiest achievement of it.
Besides, I think it is not valid implementation that brings us a care
about ei->client_releasepage's sleeping.

Additional Information:
I did an easy test with your last change and then I haven't experienced
any errors.

Regards,
Toshiyuki Okajima

