Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12A7C636CC
	for <linux-ext4@archiver.kernel.org>; Thu, 16 Feb 2023 19:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBPT4y (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 16 Feb 2023 14:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBPT4x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2023 14:56:53 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEAA216337
        for <linux-ext4@vger.kernel.org>; Thu, 16 Feb 2023 11:56:52 -0800 (PST)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5F8EC4DCA02;
        Thu, 16 Feb 2023 13:55:21 -0600 (CST)
Message-ID: <abcc1ec6-a1d6-28a2-d0f5-29baac0722b8@sandeen.net>
Date:   Thu, 16 Feb 2023 13:56:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-Language: en-US
To:     Reindl Harald <h.reindl@thelounge.net>, linux-ext4@vger.kernel.org
References: <1620c46d-efcf-aca6-341b-083ef593c612@thelounge.net>
 <e21a53a9-10c5-a9da-02a6-338a78688c11@sandeen.net>
 <95b1df7e-3eb9-484c-d655-c42501ce7429@thelounge.net>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: e4defrag don't work really well
In-Reply-To: <95b1df7e-3eb9-484c-d655-c42501ce7429@thelounge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 2/16/23 12:21 PM, Reindl Harald wrote:
> 
> 
> Am 16.02.23 um 17:50 schrieb Eric Sandeen:
>> On 2/12/23 12:14 PM, Reindl Harald wrote:
>>>
>>> what's wrong with e4defrag that it pretends it reduced th efragments of a file to 1 while in the next "e4defrag -c" (why does that only list 5 files at all) the same file is listed again with the same old frag count?
>>
>> You might want to examine the actual allocation before and after with "filefrag -v"
>> which could offer some clues to whether anything was modified by e4defrag.
>>
>> (I would also suggest that there is no need to defragment a 3-extent 2 megabyte
>> file, in general.)
> 
> it's not a question if it's needed
> 
> the point is it pretends "Success: [1/1]" but a following "e4defrag -c" still says "now/best 3/1"

I understand. It seems that your irritation at my parenthetical caused you
to skip over the request for more information from filefrag, though.

-Eric
