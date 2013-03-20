From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] xfstests 299-305: remove fio config files after finished
 test
Date: Wed, 20 Mar 2013 13:37:44 +0800
Message-ID: <20130320053744.GA4017@gmail.com>
References: <1363685450-27452-1-git-send-email-wenqing.lz@taobao.com>
 <51489024.20301@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:46192 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3CTFWO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2013 01:22:14 -0400
Received: by mail-da0-f46.google.com with SMTP id y19so751952dan.5
        for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 22:22:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <51489024.20301@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 19, 2013 at 11:19:48AM -0500, Eric Sandeen wrote:
> On 3/19/13 4:30 AM, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > After finished test, temporarily fio config file should be removed.
> 
> Looks fine, except that in test 300 you don't do rm -f; in every
> other test -f is used.  Was that intentional?

Thanks for pointing it out.  It's a typo.  I will submit a newer patch
to fix it.

> 
> Also, while looking at this, in 305 cleanup uses "poweron_scratch_dev"
> - is that defined anywhere?  I can't find it.

Yeah, I also cannot find it.  I am not sure why it is called here.  I
will take a look at it and make sure that we can remove it.

Regards,
                                                - Zheng
