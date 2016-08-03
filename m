From: Jan Kara <jack@suse.cz>
Subject: Re: Hi, how to test the patch?
Date: Wed, 3 Aug 2016 14:40:31 +0200
Message-ID: <20160803124031.GC14025@quack2.suse.cz>
References: <579EC7B1.1090309@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Zhang AiHua <zhangaihua1@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbcHCMke (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2016 08:40:34 -0400
Content-Disposition: inline
In-Reply-To: <579EC7B1.1090309@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Mon 01-08-16 11:53:21, Zhang AiHua wrote:
>     "ext4: fix races between page faults and hole punching"
> 
>     can you tell me how to test the patch? Thank you very much.

Well, it is not really easy to test for (which is why I haven't written an
xfstest for that) :). You can prepare a some zeroed file, mmap it, and read
it through mmap while puching holes into the file and also randomly filling
holes back while writing zeroes. When there is some other activity in the
filesystem allocating blocks and writing to them some data, you may see
this data instead of zeros in the mmap if the bug triggers.

If you create a successful reproducer, please let me know and consider
contributing it to xfstests so that we can check the behavior.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
