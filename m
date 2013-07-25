From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: Remove extent tree purging from
 ext4_da_page_release_reservation()
Date: Fri, 26 Jul 2013 07:36:11 +0800
Message-ID: <20130725233611.GA27902@gmail.com>
References: <1374099015-6829-1-git-send-email-jack@suse.cz>
 <20130719004439.GA21615@gmail.com>
 <20130724200536.GC27307@quack.suse.cz>
 <20130725115234.GA26044@gmail.com>
 <20130725140528.GD9388@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42054 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3GYXgL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Jul 2013 19:36:11 -0400
Received: by mail-pd0-f179.google.com with SMTP id v10so2073238pde.24
        for <linux-ext4@vger.kernel.org>; Thu, 25 Jul 2013 16:36:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130725140528.GD9388@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 25, 2013 at 04:05:28PM +0200, Jan Kara wrote:
[...]
> > Yes, thanks for pointing it out.  I attach a patch below.  Could you
> > please review it?
>   Thanks for writing the patch! It looks good. BTW, feel free to take
> authorship of it.  I've just pointed out the problem. One typo correction
> below:

Thanks for your review.  The latest patch will be sent out soon.

                                                - Zheng
