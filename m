From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH] ext4: remove a duplicate call in ext4_init_new_dir()
Date: Sat, 23 Aug 2014 11:48:08 +0800
Message-ID: <7F0C9105-F6FE-480B-8225-080624BECD7B@gmail.com>
References: <1407856709-18612-1-git-send-email-wangshilong1991@gmail.com> <B0F97F2C-631A-4D01-97EC-E6687D4E674D@gmail.com> <20140822235540.GS11085@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41027 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaHWDsi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Aug 2014 23:48:38 -0400
Received: by mail-pa0-f54.google.com with SMTP id fa1so17900804pad.27
        for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2014 20:48:37 -0700 (PDT)
In-Reply-To: <20140822235540.GS11085@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

> On Wed, Aug 20, 2014 at 01:21:55AM +0800, Wang Shilong wrote:
>> Any comments on this cleanup patch?
> 
> Looks good.  This got sent just before the merge window opened, and
> this week has been the Kernel Summit / LinuxCon North America.  So I
> haven't started accepting patches to the ext4 git tree just yet.  Now
> that the event is open, we'll start with regression fixes and high
> priority bug fixes that need to go to Linus before 3.17 is released,
> and then cleanup and patch mixups.

Thanks for detailed information!

> 
> Cheers,
> 
> 						- Ted

Best Regards,
Wang Shilong

