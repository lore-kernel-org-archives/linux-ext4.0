Return-Path: <SRS0=L9HK=QH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B6BC282C7
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 08:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A4222087F
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 08:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbfAaIHH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Jan 2019 03:07:07 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:47916 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbfAaIHG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 31 Jan 2019 03:07:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---0TJJmERF_1548922024;
Received: from 30.5.112.255(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TJJmERF_1548922024)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 31 Jan 2019 16:07:04 +0800
To:     linux-ext4@vger.kernel.org
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: question about ext4 backup block group descriptors
Message-ID: <4fc3271a-3098-afcd-24c1-e2e130e1e86a@linux.alibaba.com>
Date:   Thu, 31 Jan 2019 16:07:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

hi,

Anyone can help answer when ext4's backup block group descriptors are updated?
I had used blktrace to track the corresponding backup block group descriptor
block, but didn't find that any backup blocks were written.
Thanks in advance.

Regards,
Xiaoguang Wang
