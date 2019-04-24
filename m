Return-Path: <SRS0=cG1U=S2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AE2C10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 13:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B351C218D2
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 13:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbfDXNuK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:50:10 -0400
Received: from foss.arm.com ([217.140.101.70]:43986 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729289AbfDXNuK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Apr 2019 09:50:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37A8380D;
        Wed, 24 Apr 2019 06:50:10 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 154F73F5C1;
        Wed, 24 Apr 2019 06:50:08 -0700 (PDT)
Subject: Re: [aarch64] Kernel crash on v5.1-rc5,
 __arch_copy_from_user+0x1bc/0x240
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <58a2439c-f92a-4053-702e-5cc65d38fff5@gmx.com>
 <6a867ea5-c389-30b9-1c84-3be5682146b5@gmx.com>
 <20190421132840.GK7751@bombadil.infradead.org>
 <09135f7a-874e-5ea0-164a-306ca3db2799@gmx.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <98fad1eb-b033-3c31-9100-bad672b4cfe0@arm.com>
Date:   Wed, 24 Apr 2019 14:50:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <09135f7a-874e-5ea0-164a-306ca3db2799@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Qu,

On 22/04/2019 02:14, Qu Wenruo wrote:
> On 2019/4/21 下午9:28, Matthew Wilcox wrote:
>> On Sun, Apr 21, 2019 at 05:12:50PM +0800, Qu Wenruo wrote:
>>> On 2019/4/21 下午4:20, Qu Wenruo wrote:
>>>> Just hit one crash on v5.1-rc5 kernel, on ext4 filesystem.
>>>
>>> Well, also hit the same one in v5.0.8 kernel.
>>>
>>> Exact the same backtrace.
>>>
>>> Really not sure which part is to blame, ARM or ext4?
>>
>> You probably have faulty hardware:

> I tried memtester, and kernel also crashed.
> 
> Maybe it's really faulty memory or I'm using wrong memory speed.

As another option: there may be no memory at this physical address.
If your board only has 1G of memory, but the bootloader/DT is reporting 2G, you could see
SError like this (assuming this is the first access to that page).

SError can be a fatal interrupt from the hardware, its also how the CPU tells us about
'asynchronous external abort'. In this case it could be an attempt to access a physical
address where nothing exists.


Thanks,

James
