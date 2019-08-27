Return-Path: <SRS0=Kp8Y=WX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E0EC3A5A3
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Aug 2019 11:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0020C2173E
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Aug 2019 11:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfH0LvZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 27 Aug 2019 07:51:25 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55970 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726071AbfH0LvZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Aug 2019 07:51:25 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F351A43E197;
        Tue, 27 Aug 2019 21:51:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2a0M-0005M0-Qf; Tue, 27 Aug 2019 21:51:18 +1000
Date:   Tue, 27 Aug 2019 21:51:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3] Revert parallel dio reads
Message-ID: <20190827115118.GY7777@dread.disaster.area>
References: <1566871552-60946-1-git-send-email-joseph.qi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566871552-60946-1-git-send-email-joseph.qi@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=VwQbUJbxAAAA:8 a=rNOIIekrAAAA:8 a=7-415B0cAAAA:8 a=i-Dg2M7HJCqoGRThW54A:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=HyV29BWo3XPGBPza7_5j:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Aug 27, 2019 at 10:05:49AM +0800, Joseph Qi wrote:
> This patch set is trying to revert parallel dio reads feature at present
> since it causes significant performance regression in mixed random
> read/write scenario.
> 
> Joseph Qi (3):
>   Revert "ext4: remove EXT4_STATE_DIOREAD_LOCK flag"
>   Revert "ext4: fix off-by-one error when writing back pages before dio
>     read"
>   Revert "ext4: Allow parallel DIO reads"
> 
>  fs/ext4/ext4.h        | 17 +++++++++++++++++
>  fs/ext4/extents.c     | 19 ++++++++++++++-----
>  fs/ext4/inode.c       | 47 +++++++++++++++++++++++++++++++----------------
>  fs/ext4/ioctl.c       |  4 ++++
>  fs/ext4/move_extent.c |  4 ++++
>  fs/ext4/super.c       | 12 +++++++-----
>  6 files changed, 77 insertions(+), 26 deletions(-)

Before doing this, you might want to have a chat and co-ordinate
with the folks that are currently trying to port the ext4 direct IO
code to use the iomap infrastructure:

https://lore.kernel.org/linux-ext4/20190827095221.GA1568@poseidon.bobrowski.net/T/#t

That is going to need the shared locking on read and will work just
fine with shared locking on write, too (it's the code that XFS uses
for direct IO). So it might be best here if you work towards shared
locking on the write side rather than just revert the shared locking
on the read side....

Cheers,

Dave,
-- 
Dave Chinner
david@fromorbit.com
