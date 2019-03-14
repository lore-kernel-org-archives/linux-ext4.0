Return-Path: <SRS0=Ur5Y=RR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AC7C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 20:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 626B22082F
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 20:03:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fKknkSPs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfCNUDV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 16:03:21 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:41306 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfCNUDV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Mar 2019 16:03:21 -0400
Received: by mail-ed1-f48.google.com with SMTP id n14so5707018edv.8
        for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2019 13:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=m1GpNrhGPhPIadNBmRssboCf+3v/bxNoeFbg9rhx+gU=;
        b=fKknkSPsDAiUfaDKiidzbg/9ew1jmOltdP6kFbylp2dHfqqQYNfgqOf0PmAstV40He
         M1DrRsNKKVAGdsBdqW6/DSZ7zF/qlixdUbrrUDef/fE8yyXvh9pqKLgZ0Rg95xj7fv18
         cpc2oyfj0JMjDFmCtYePJlNhXM9yWV2NYK8vzDqLhMCgQs6O86ghjpoFh5SVLjNDrc9D
         A/xDw94y5omdX3Gfe8cJV/iPceCwYtLU6BnuXgP6qOrd75mtabkhKGEqfCCjFjR/yhy+
         DDnrhS2a9iBnhgcNd1xSXgWPl6ZyQ2AfC4RsKpiFTUW1KvGH8BiNjnZCI1OFLcl4cOXt
         8vgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=m1GpNrhGPhPIadNBmRssboCf+3v/bxNoeFbg9rhx+gU=;
        b=XSIWsNfJs/0FzQOKcbqf34GpNI5c5zJLIxxqRK4RIKmiwMAR1uFlWmf8s7b4pV44JX
         aGaz3Zqm3nTabYAw06WIVYgrE4qIGB00Wf1elnCvpP2+5RvVwlEIUpUZZeMSSJGmz2xf
         sEWVLvx7TqEXEp9umSd6ZK3TExxq/YRPWhJL1iEaRBv+SoMafoYdDHVxJq5Fs5bRcnva
         MGq1jp98HtqdTHdrOwcQq35ZJlR/v/6IIBr9Fta+04HGcwN7l5rpOoBKrqs3tXjsj3SA
         sxOkfYYnO7IgiVIcqvmEOTVa+L08Ht2TG6P2r3gbphKauLm96M4vNIArAFZdC87CbSdT
         MWiw==
X-Gm-Message-State: APjAAAXTAEXLycT00t8N4JLhj+bnvsqCA0YOAYUd7d6eqQE1hsAinbMw
        Wks0raEfxb+xEnQ3QKlPsLuT46kI1grjU7GPrgu2fMgn
X-Google-Smtp-Source: APXvYqz+GfG8+Hbl7zKprRJ2SA5Uil/iA6bVU3pOCpgoIB/ZEqmC5frovMSqkPLi3XEcuB8nqMH1NjwzxB5KQ5wbAFQ=
X-Received: by 2002:a17:906:8491:: with SMTP id m17mr20379908ejx.229.1552593799297;
 Thu, 14 Mar 2019 13:03:19 -0700 (PDT)
MIME-Version: 1.0
From:   Ross Zwisler <zwisler@google.com>
Date:   Thu, 14 Mar 2019 14:03:08 -0600
Message-ID: <CAGRrVHxhK9Bsk42m5D2LEiVzoWxbK7Z5=FGynLcbqsX-5iWT0g@mail.gmail.com>
Subject: question about writeback
To:     linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jan Kara <jack@suse.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Cc:     Ross Zwisler <zwisler@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

I'm trying to understand a failure I'm seeing with both v4.14 and
v4.19 based kernels, and I was hoping you could point me in the right
direction.

What seems to be happening is that under heavy I/O we get into a
situation where for a given inode/mapping we eventually reach a steady
state where one task is continuously dirtying pages and marking them
for writeback via ext4_writepages(), and another task is continuously
completing I/Os via ext4_end_bio() and clearing the
PAGECACHE_TAG_WRITEBACK flags.  So, we are making forward progress as
far as I/O is concerned.

The problem is that another task calls filemap_fdatwait_range(), and
that call never returns because it always finds pages that are tagged
for writeback.  I've added some prints to __filemap_fdatawait_range(),
and the total number of pages tagged for writeback seems pretty
constant.  It goes up and down a bit, but does not seem to move
towards 0.  If we halt I/O the system eventually recovers, but if we
keep I/O going we can block the task waiting in
__filemap_fdatawait_range() long enough for the system to reboot due
to what it perceives as hung task.

My question is: Is there some mechanism that is supposed to prevent
this sort of situation?  Or is it expected that with slow enough
storage and a high enough I/O load, we could block inside of
filemap_fdatawait_range() indefinitely since we never run out of dirty
pages that are marked for writeback?

Thanks,
- Ross
