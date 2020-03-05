Return-Path: <SRS0=3og0=4W=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251E4C3F2D2
	for <linux-ext4@archiver.kernel.org>; Thu,  5 Mar 2020 20:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2A7D2072D
	for <linux-ext4@archiver.kernel.org>; Thu,  5 Mar 2020 20:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgCEUko (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 5 Mar 2020 15:40:44 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45161 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726092AbgCEUko (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2020 15:40:44 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-105.corp.google.com [104.133.0.105] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 025KeYCG001562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 5 Mar 2020 15:40:35 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 765EA42045B; Thu,  5 Mar 2020 15:40:34 -0500 (EST)
Date:   Thu, 5 Mar 2020 15:40:34 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-ext4@vger.kernel.org, jack@suse.cz,
        joseph qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH] ext4: start to support iopoll method
Message-ID: <20200305204034.GC20967@mit.edu>
References: <20200207120758.2411-1-xiaoguang.wang@linux.alibaba.com>
 <c535d8f5-e746-30dc-f3e8-aeed04fcb5b8@linux.alibaba.com>
 <20200302191604.GD6826@mit.edu>
 <22af3309-cccf-57a8-af35-32c9e5fa06ca@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22af3309-cccf-57a8-af35-32c9e5fa06ca@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 04, 2020 at 09:40:54PM +0800, Xiaoguang Wang wrote:
> hi,
> 
> Sorry for being late.
> > On Mon, Mar 02, 2020 at 05:17:09PM +0800, Xiaoguang Wang wrote:
> > > hi,
> > > 
> > > Ted, could you please consider applying this patch? Iouring polling
> > > tests in ext4 needs this patch, Jan Kara has nicely reviewed this patch, thanks.
> > 
> > Yeah, I had been waiting to make sure the fix: "io_uring: fix
> > poll_list race for SETUP_IOPOLL|SETUP_SQPOLL" was going to land.
> I confirmed that it had been merged into mainline.
> 
> > 
> > Am I correct that the bug fixed in the above fix isn't going to impact
> > xfstests (since it looks like there are no fio runs with the io_uring
> > engine at the moment)?
> Yes, I have run xfstests with "-g auto", with or without this patch, there always
> are six same failed test cases, so I think it won't impact current xfstests, thanks.

Thanks, applied.

						- Ted
