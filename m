From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Wed, 23 Apr 2014 13:35:21 +0800
Message-ID: <20140423053520.GA9041@gmail.com>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
 <20140416151938.GA17208@thunk.org>
 <20140416154209.GB17208@thunk.org>
 <20140417153526.GF18591@thunk.org>
 <20140421231002.GC15995@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41856 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaDWF26 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2014 01:28:58 -0400
Received: by mail-pd0-f173.google.com with SMTP id p10so57579pdj.32
        for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2014 22:28:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140421231002.GC15995@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 22, 2014 at 09:10:02AM +1000, Dave Chinner wrote:
> On Thu, Apr 17, 2014 at 11:35:26AM -0400, Theodore Ts'o wrote:
> > So I've been thinking about this some more, and it seems to me is
> > actually, what we need is *both* an LRU and a RR scheme.
> 
> We already have shrinker implementations that do this. It would
> probably take 10-15 lines of code to add it to any existing LRU
> list based shrinker.....

Hi Dave,

I guess that you are talking about lru list in include/linux/list_lru.h.
Thanks for pointing it out, and I will take a look at it.

Thanks,

                                                - Zheng
