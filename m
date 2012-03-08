From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Thu, 08 Mar 2012 15:42:52 -0500
Message-ID: <x49linaj037.fsf@segfault.boston.devel.redhat.com>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
	<4F57F523.3020703@redhat.com> <4F581BF6.8000305@zabbo.net>
	<20120308155419.GB6777@thunk.org> <20120308180951.GB29510@shiny>
	<4F59148A.4070001@panasas.com> <20120308203741.GE29510@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boaz Harrosh <bharrosh@panasas.com>, "Ted Ts'o" <tytso@mit.edu>,
	Zach Brown <zab@zabbo.net>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab2CHUnA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Mar 2012 15:43:00 -0500
In-Reply-To: <20120308203741.GE29510@shiny> (Chris Mason's message of "Thu, 8
	Mar 2012 15:37:41 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> writes:

> On Thu, Mar 08, 2012 at 12:20:26PM -0800, Boaz Harrosh wrote:
>> I think I understand this one. It's do to the sync nature introduced
>> by page_waiting in mkwrite.
>
> Pages go from dirty to writeback for a few reasons.  Background
> writeout, or O_DIRECT or someone running sync
>
> background writeout shouldn't be queueing up so much work that
> synchronous writeout has a 2 second delay.

So now we're back to figuring out how to tell how long I/O will take?
If writeback is issuing random access I/Os to spinning media, you can
bet it might be a while.  Today, you could lower nr_requests to some
obscenely small number to improve worst-case latency.  I thought there
was some talk about improving the intelligence of writeback in this
regard, but it's a tough problem, especially given that writeback isn't
the only cook in the kitchen.

Cheers,
Jeff
