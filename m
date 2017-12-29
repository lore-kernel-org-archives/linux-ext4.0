From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] misc: add e2mmpstatus utility
Date: Fri, 29 Dec 2017 16:02:04 -0700
Message-ID: <F976B3B9-90C4-446E-B8D4-49571CA535A4@dilger.ca>
References: <1513934564-89598-1-git-send-email-adilger@dilger.ca>
 <20171222171716.GB29153@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Wang Shilong <wshilong@ddn.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:46253 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbdL2XCK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Dec 2017 18:02:10 -0500
Received: by mail-io0-f180.google.com with SMTP id x129so42415671iod.13
        for <linux-ext4@vger.kernel.org>; Fri, 29 Dec 2017 15:02:09 -0800 (PST)
In-Reply-To: <20171222171716.GB29153@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 22, 2017, at 10:17 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> On Fri, Dec 22, 2017 at 02:22:44AM -0700, Andreas Dilger wrote:
>> From: Shuichi Ihara <sihara@ddn.com>
>> 
>> e2mmpstatus is an MMP helper utility to read status from an MMP block.
>> It outputs the latest MMP updated nodename and time for the device.
> 
> Why not include this into dumpe2fs?  Maybe dumpe2fs -m to just print
> the MMP information and include the MMP nodetime and time for either
> the full dumpe2fs or dumpe2fs -h output?

That would definitely be an option.  The mmpstatus utility was written by
DDN, and I'm passing it on after some code cleanup.

I think it would be reasonable to include the other MMP fields into the
dumpe2fs output, and then run the full MMP activity check if called with
"-m" or named as "mmpstatus".  I don't want dumpe2fs to be blocked on
the MMP update checking all the time, since that can be slow.

I'll see if I can get a patch out in the next couple of days.

Cheers, Andreas
