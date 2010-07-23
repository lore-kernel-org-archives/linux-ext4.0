From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests 240: test non-aligned AIO hole-filling
Date: Thu, 22 Jul 2010 22:37:20 -0500
Message-ID: <4C490E70.3030902@redhat.com>
References: <4C489676.2000605@redhat.com> <20100723024938.GD32635@dastard> <4C490D4D.603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab0GWDhb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 23:37:31 -0400
In-Reply-To: <4C490D4D.603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Dave Chinner wrote:

...

   
>> looks good - it needs to remove the $TEST_DIR/aiodio_sparse file
>> before the test starts, though, so that repeated tests fail
>> correctly. Otherwise:
>>
>>   
> hm, but:
> 
> +rm -f "$TEST_DIR/aiodio_sparse*"
> +
> +# 2 threads, 4k writes, 16k filesize, stride throug file by 4k, start at 512 offset
> +$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w 4k -s 16k -n 4k -o 512 "$TEST_DIR/aiodio_sparse"
> 
> It does remove it ... no?

hm, no, what are those quotes doing there...

Ok, will fix up thanks.

-Eric
