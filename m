From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent
 by fsync
Date: Tue, 30 Nov 2010 14:45:05 +0100
Message-ID: <4CF4FFE1.9060507@kernel.org>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com> <20101130113906.176ffcad@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:58765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab0K3Npq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Nov 2010 08:45:46 -0500
In-Reply-To: <20101130113906.176ffcad@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On 11/30/2010 01:39 AM, Neil Brown wrote:
> I haven't seen any of the preceding discussion do I might be missing
> something important, but this seems needlessly complex and intrusive.
> In particular, I don't like adding code to md to propagate these timings up
> to the fs, and I don't the arbitrary '2ms' number.
> 
> Would it not be sufficient to simply gather flushes while a flush is pending.
> i.e
>   - if no flush is pending, set the 'flush pending' flag, submit a flush,
>     then clear the flag.
>   - if a flush is pending, then wait for it to complete, and then submit a
>     single flush on behalf of all pending flushes.

Heh, I was about to suggest exactly the same thing.  Unless the delay
is gonna be multiple times longer than avg flush time, I don't think
the difference between the above scheme and the one w/ preemptive
delay would be anything significant especially now that the cost of
flush is much lower.  Also, as Neil pointed out in another message,
the above scheme will result in lower latency for flushes issued while
no flush is in progress.

IMO, this kind of optimization is gonna make noticeable difference
only when there are a lot of simulatenous fsyncs, in which case the
above would behave in mostly identical way with the more elaborate
timer based one anyway.

Thanks.

-- 
tejun
