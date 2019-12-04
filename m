Return-Path: <SRS0=1XWU=Z2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED84EC43603
	for <linux-ext4@archiver.kernel.org>; Wed,  4 Dec 2019 20:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8CAC206DF
	for <linux-ext4@archiver.kernel.org>; Wed,  4 Dec 2019 20:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfLDUrq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 4 Dec 2019 15:47:46 -0500
Received: from mail.phunq.net ([66.183.183.73]:47250 "EHLO phunq.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbfLDUrq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 4 Dec 2019 15:47:46 -0500
Received: from [172.16.1.14]
        by phunq.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim 4.92.3)
        (envelope-from <daniel@phunq.net>)
        id 1icbYm-0007WV-HM; Wed, 04 Dec 2019 12:47:44 -0800
Subject: Re: [RFC] Thing 1: Shardmap fox Ext4
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
References: <176a1773-f5ea-e686-ec7b-5f0a46c6f731@phunq.net>
 <20191127142508.GB5143@mit.edu>
 <6b6242d9-f88b-824d-afe9-d42382a93b34@phunq.net>
 <6C8DAF47-CA09-4F3B-BF32-2D7044C1EE78@dilger.ca>
From:   Daniel Phillips <daniel@phunq.net>
Message-ID: <22c57727-2826-8945-1964-66e66fe82d39@phunq.net>
Date:   Wed, 4 Dec 2019 12:47:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <6C8DAF47-CA09-4F3B-BF32-2D7044C1EE78@dilger.ca>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2019-12-04 10:03 a.m., Andreas Dilger wrote:
>> Here is a pretty picture to get started:
>>
>>    https://github.com/danielbot/Shardmap/wiki/Shardmap-media-format
> 
> The shardmap diagram is good conceptually, but it would be useful
> to add a legend on the empty side of the diagram that shows the on-disk
> structures.

Sounds good, but not sure exactly what you had in mind. Fields of a
shard entry? Fields of the block 0 header? The record entry block has
its own diagram, and is polymorphic anyway, so no fixed format.

Regards,

Daniel


