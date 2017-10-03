From: Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH] ext4: Use symbolic constants for well-known pow 2 sizes
Date: Tue, 3 Oct 2017 12:31:45 +0300
Message-ID: <26a209c0-384f-9646-9700-adb48c83eac3@suse.com>
References: <20171003070000.GA5162@lvzheng-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Zheng Lv <lv.zheng.2015@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751408AbdJCJbs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 3 Oct 2017 05:31:48 -0400
In-Reply-To: <20171003070000.GA5162@lvzheng-thinkpad>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On  3.10.2017 10:00, Zheng Lv wrote:
>> No functional changes, just makes the code a bit more readable. Also fix 1
>> trailing whitespace
> 
> I don't think so.
> 
> AFAIK, SZ_16 is just 16, not (16 * 1024). XXX * 1024 should be replaced with
> SZ_XXXk rather than SZ_XXX.

True, I meant kilobytes and not bytes, so my bad. THe patch is buggy
will redo it and resend. Thanks for spotting it.


> 
> Cheers
> Zheng Lv
> 
