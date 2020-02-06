Return-Path: <SRS0=cg8q=32=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE3DC2D0B1
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Feb 2020 13:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CE64218AC
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Feb 2020 13:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgBFN3Y (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Feb 2020 08:29:24 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:47675 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbgBFN3Y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Feb 2020 08:29:24 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04396;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TpHHK0W_1580995756;
Received: from 30.13.184.134(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TpHHK0W_1580995756)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 06 Feb 2020 21:29:17 +0800
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, ted <tytso@mit.edu>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: ext4 support iopoll
Message-ID: <e1df9ed9-763a-d3a8-0159-782a8a6d6844@linux.alibaba.com>
Date:   Thu, 6 Feb 2020 21:29:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

hi,

While testing iouring in ext4, we find ext4 does not support .iopoll yet, since
commit "ext4: introduce direct I/O write using iomap infrastructure", seems that
ext4 can support iopoll as well, just add a ".iopoll = iomap_dio_iopoll,".
So I wonder is there any special reason that ext4 does not have have this iopoll
interface? Thanks.

Regards,
Xiaoguang Wang
