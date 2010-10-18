From: Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-2.6-block/for-next: Removal of BLKDEV_IFL_BARRIER and BLKDEV_IFL_WAIT
Date: Mon, 18 Oct 2010 09:13:06 +0200
Message-ID: <4CBBF382.4000505@kernel.dk>
References: <AANLkTi=EiCvRxAqnbWoPMhqYAZDQmsjaDRt+0dK-fRcV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:60891 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab0JRHNI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Oct 2010 03:13:08 -0400
In-Reply-To: <AANLkTi=EiCvRxAqnbWoPMhqYAZDQmsjaDRt+0dK-fRcV@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-18 02:11, Sedat Dilek wrote:
> Hi,
> 
> today, I pulled linux-2.6-block/for-next GIT branch [1] on top of
> Linus-tree (2.6.36-rc8-git3).
> 
> Unfortunately, ext4/next GIT branch [2] is not "GIT-pull-able" on top
> of this local GIT repository.
> The cause for this is the removal of BLKDEV_IFL_BARRIER and
> BLKDEV_IFL_WAIT in linux-2.6-block/for-next.
> 
> As there are few days left for 2.6.36-final, it would be great when
> ext4/next could be prepared to work with linux-2.6-block/for-next.
> Thanks in advance.

The argument just has to be removed. linux-next has had a fixup
patch for this for a long time.

-- 
Jens Axboe

