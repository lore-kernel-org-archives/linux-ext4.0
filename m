From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/3] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
Date: Fri, 25 Jun 2010 15:57:19 -0400
Message-ID: <x496316opgg.fsf@segfault.boston.devel.redhat.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<1277242502-9047-2-git-send-email-jmoyer@redhat.com>
	<20100624004622.GA3297@redhat.com>
	<x49bpaznjgx.fsf@segfault.boston.devel.redhat.com>
	<4C24FB84.5050408@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab0FYT5X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jun 2010 15:57:23 -0400
In-Reply-To: <4C24FB84.5050408@kernel.dk> (Jens Axboe's message of "Fri, 25
	Jun 2010 20:55:00 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jens Axboe <axboe@kernel.dk> writes:

> On 25/06/10 18.51, Jeff Moyer wrote:
>>>> +	cfq_log_cfqq(cfqd, cfqq, "yielding queue to %d", tsk->pid);
>>>> +	cfqq->yield_to = new_cic;
>>>
>>> We are stashing away a pointer to cic without taking reference?
>> 
>> There is no reference counting on the cic.
>
> Not on the cic itself, but on the io context it belongs to. So you
> need to grab a reference to that, if you are stowing a reference
> to the cic.

OK, easy enough.  Thanks!

Jeff
