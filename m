Return-Path: <SRS0=h2j7=SH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E25DC4360F
	for <linux-ext4@archiver.kernel.org>; Fri,  5 Apr 2019 09:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04CCF217D7
	for <linux-ext4@archiver.kernel.org>; Fri,  5 Apr 2019 09:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730173AbfDEJNB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 5 Apr 2019 05:13:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:38352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729728AbfDEJNB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 5 Apr 2019 05:13:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7514AB645;
        Fri,  5 Apr 2019 09:12:59 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id CF1DC1E09F9; Fri,  5 Apr 2019 11:12:58 +0200 (CEST)
Date:   Fri, 5 Apr 2019 11:12:58 +0200
From:   Jan Kara <jack@suse.cz>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, miaoxie@huawei.com
Subject: Re: [PATCH] ext4: add inode to ordered data list when extending file
 without block allocation
Message-ID: <20190405091258.GA1600@quack2.suse.cz>
References: <1554370192-113254-1-git-send-email-yi.zhang@huawei.com>
 <20190404101823.GA22313@quack2.suse.cz>
 <c37e682d-a5b3-c23d-0a2c-e09474b64426@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c37e682d-a5b3-c23d-0a2c-e09474b64426@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 04-04-19 20:46:47, zhangyi (F) wrote:
> On 2019/4/4 18:18, Jan Kara Wrote:
> > On Thu 04-04-19 17:29:52, zhangyi (F) wrote:
> >> Currently we capture a NULL data exposure problem after a crash or
> >> poweroff when append writing a file in the data=ordered mode. The
> >> problem is that we were not add inode to the transaction's order data
> >> list when updating i_disksize without new block allocation no matter
> >> the delay allocated block feature is enabled or not.
> >>
> >> write                           jbd2                    writeback
> >> append write in allocated block
> >> mark buffer dirty
> >> update i_disksize
> >> mark inode dirty
> >>                           commit transaction
> >>                           write inode
> >>                           (data exposure after a crash)
> >>                                                     write dirty buffer
> >>
> >> It's fine in the case of new block allocation because we do this job in
> >> ext4_map_blocks(). To fix this problem, this patch add inode to current
> >> transaction's order data list after new data is copied and needing
> >> update i_disksize in the case of no block allocation.
> >>
> >> Fixes: 06bd3c36a733ac ("ext4: fix data exposure after a crash")
> >> Fixes: f3b59291a69d0b ("ext4: remove calls to ext4_jbd2_file_inode() from delalloc write path")
> >> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> > 
> > Thanks for the patch. The current behavior is a deliberate decision.
> > data=ordered mode does guarantee there is no stale data visible in case of
> > crash. However it does not guarantee you cannot see zeros where data was
> > written. 
> > 
> 
> Hi Jan,
> Thanks a lot for your explanation. I read the
> Documentation/admin-guide/ext4.rst, which said about the ordered mode:
> 
> > ... When it's time to write the new metadata out to disk, the associated data
> > blocks are written first...
> 
> So I reckon that the dirty data block should be written to disk before
> committing i_disksize and we cannot see the zero data. Now, I don't find
> any offical docs to record the behavior you mentioned, do you have some
> links talk about this behavior or am I miss something ?

Yeah, I agree that paragraph in Documentation/admin-guide/ext4.rst could be
interpretted the way you understood it. Ext4 Wiki [1] has this comment:

(Note, however, that Ordered Mode does not guarantee that the file will be
consistent at an application level; the application must use fsync() at
appropriate commit points in order to guarantee application-level
consistency.)

In addition, there are some applications which depend on data=ordered to
automatically force data blocks to be written to disk soon after the file
is written. Using Writeback Mode extends the time from when a file is
written to when it is pushed out to disk to 30 seconds. This can be
surprising for some users; however, it should be noted that such problems
can still be an issue with Ordered Mode (although they are much rarer).
Again, a careful application or library should always use fsync() at points
where the application is at a stable commit point. 

---

And we generally always made it clear that data=ordered mode is a "security
feature" - don't expose potentialy sensitive data after crash. Not app data
consistency feature (fsync(2) is for that). I don't have a good reference
for that except perhaps bugzilla comment from Ted [2] where he explains
some rationale behind data=ordered mode.

So overall no, data=ordered mode is not designed to provide the data
integrity guarantees you'd like to see. And providing more guarantees has
performance (and maintenance) costs so it should be better justified than
just "it would be nice for applications".

Also when you'd like to provide some guarantees about data integrity, you
need to specify your "promise" (currently our promise is: "no uninitialized
data visible"). Because full "writes are atomic operation wrt crash" kind
of guarantee is very hard (expensive) to achieve. I hope this clears things
out a bit.

								Honza

[1] https://ext4.wiki.kernel.org/index.php/Ext3_Data=Ordered_vs_Data=Writeback_mode
[2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/317781/comments/45

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
