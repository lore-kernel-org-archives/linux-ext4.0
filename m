From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/4 v4] ext3/4: enhance fsync performance when using CFQ
Date: Wed, 26 May 2010 11:33:17 -0400
Message-ID: <x49sk5ebruq.fsf@segfault.boston.devel.redhat.com>
References: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
	<20100519105706.8821.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jens.axboe@oracle.com, vgoyal@redhat.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab0EZPdY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 May 2010 11:33:24 -0400
In-Reply-To: <20100519105706.8821.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's
	message of "Wed, 19 May 2010 11:05:20 +0900 (JST)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:

> Hi Jeff,
>
>> This patch series addresses a performance problem experienced when running
>> io_zone with small file sizes (from 4KB up to 8MB) and including fsync in
>> the timings.  A good example of this would be the following command line:
>>   iozone -s 64 -e -f /mnt/test/iozone.0 -i 0
>> As the file sizes get larger, the performance improves.  By the time the
>> file size is 16MB, there is no difference in performance between runs
>> using CFQ and runs using deadline.  The storage in my testing was a NetApp
>> array connected via a single fibre channel link.  When testing against a
>> single SATA disk, the performance difference is not apparent.
>
> offtopic:
>
> Can this patch help to reduce a pain of following much small files issue?
>
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=578635

Perhaps.  I don't have a debian system handy to test that, though.

Cheers,
Jeff
