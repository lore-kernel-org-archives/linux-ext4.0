From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH v2] ext4: dynamical adjust the length of zero-out chunk
Date: Mon, 13 Aug 2012 10:32:24 -0700
Message-ID: <20120813173224.GF9117@lenny.home.zabbo.net>
References: <1342075703-4537-1-git-send-email-wenqing.lz@taobao.com>
 <4FFEE402.7090601@redhat.com>
 <7B794B69-EF6C-4279-83D7-EA47E35CD54C@dilger.ca>
 <20120813032243.GB13072@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab2HMRcc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 13:32:32 -0400
Content-Disposition: inline
In-Reply-To: <20120813032243.GB13072@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I also reworded the commit description slightly, and this is what I
> currently have in my tree.  What do people think?

(well, you asked! :))

>     we allow it to be tunable via sysfs and set an initial default value
>     of 32, so instead of creating uninitalized extents smaller than

s/32/16/?

>     256k (assuming a 4k block size), they will be zeroed out instead.

Having to qualify the zeroout len with the block size caught my
attention!

> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2541,6 +2541,7 @@ EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
>  EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
>  EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
>  EXT4_RW_ATTR_SBI_UI(max_writeback_mb_bump, s_max_writeback_mb_bump);
> +EXT4_RW_ATTR_SBI_UI(extent_zeroout_len, s_extent_zeroout_len);
>  EXT4_ATTR(trigger_fs_error, 0200, NULL, trigger_test_error);

"len" seems to stand out amongst all those "mb" names :)

It'd be nice to define the tunable in terms of some fixed unit, kb or
mb, whatever, and then translate to the block size in the code so people
don't have to do that math by hand.

No?

- z
