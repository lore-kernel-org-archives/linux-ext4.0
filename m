From: Ted Ts'o <tytso@mit.edu>
Subject: Re: confused by delayed allocation and ordered journal
Date: Sat, 25 Dec 2010 09:39:16 -0500
Message-ID: <20101225143916.GD2595@thunk.org>
References: <AANLkTi=2S3JsAOP290_1ASMNGKMFZK+Srt4v5Qs474dB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49080 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab0LYOjW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Dec 2010 09:39:22 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=2S3JsAOP290_1ASMNGKMFZK+Srt4v5Qs474dB@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 25, 2010 at 09:15:28PM +0800, Yongqiang Yang wrote:
> 
> I found that if a block'allocation is delayed, and is not allocated
> when journal flushes it, then journal just redirties it and return in
> journal_submit_data_buffers.
> 
> If I understand right, how to guarantee that the journal mode is ordered?

The primary goal of ordered mode is to make sure that stale data is
not exposed after a crash.  To the extent that delayed allocation also
achieves this goal, it's fine.  The fact that ext3 forced data blocks
out as part of its jbd commit function was always an implementation
detail.

In the long run we'll be getting rid of ordered mode even more so, by
writing the data block first, and only then updating the file system
metadata.  At that point there will be no ordered flushing at all, and
in fact ordered mode will go away as a journal mode supported by ext4.

   		     	     	  - Ted
