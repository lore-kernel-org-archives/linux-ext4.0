Return-Path: <SRS0=D/JD=QG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E5EC282D7
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 13:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DB552184D
	for <linux-ext4@archiver.kernel.org>; Wed, 30 Jan 2019 13:57:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="le9sxbVQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbfA3N5S (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 30 Jan 2019 08:57:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:29552 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfA3N5R (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jan 2019 08:57:17 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20190130135713epoutp0313ab014af4ee37731717a3cf24ccdee8~_pOb85qHt1649016490epoutp035;
        Wed, 30 Jan 2019 13:57:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20190130135713epoutp0313ab014af4ee37731717a3cf24ccdee8~_pOb85qHt1649016490epoutp035
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548856633;
        bh=QTBuW+DrgfAwWY8gNJNWLKpQygBUuHGuL1YMrJChFe0=;
        h=Subject:To:Cc:From:Date:In-reply-to:References:From;
        b=le9sxbVQ7xqm8l6xY5kawZA8pC5c2JkamuyUXLiJlKM/7qYC8LgXe2m5nwCqjkFLC
         Oxrz75thX/OzsYNTa/sQWm6dXe2r5dsq2Y9MeQ/KRUPDzAdVAPJqpfLxB5QmzFhm3c
         NHNCU6H9SbLA7eoW9QGgq1My9jXBj5Kc7rFZs+UI=
Received: from epsmges2p3.samsung.com (unknown [182.195.42.71]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20190130135713epcas2p2fa20cbea51f550bea9f66213adb0812f~_pObg2umW2104421044epcas2p25;
        Wed, 30 Jan 2019 13:57:13 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.A9.04134.93DA15C5; Wed, 30 Jan 2019 22:57:13 +0900 (KST)
Received: from epsmgms2p2new.samsung.com (unknown [182.195.42.143]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20190130135713epcas2p36f828f7e372dcc1ad49f31e3547d3232~_pObP8iwm1967819678epcas2p3b;
        Wed, 30 Jan 2019 13:57:13 +0000 (GMT)
X-AuditID: b6c32a47-8abff70000001026-4e-5c51ad39270a
Received: from epmmp2 ( [203.254.227.17]) by epsmgms2p2new.samsung.com
        (Symantec Messaging Gateway) with SMTP id 54.F7.03689.83DA15C5; Wed, 30 Jan
        2019 22:57:13 +0900 (KST)
Received: from [107.108.221.212] by mmp2.samsung.com (Oracle Communications
        Messaging Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PM500CDPDF0GB70@mmp2.samsung.com>; Wed, 30 Jan 2019 22:57:12 +0900 (KST)
Subject: Re: [PATCH v2 0/4] Write-hint for FS journal
To:     Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Cc:     Keith Busch <keith.busch@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "jack@suse.com" <jack@suse.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "prakash.v@samsung.com" <prakash.v@samsung.com>,
        Jens Axboe <axboe@fb.com>
From:   Kanchan Joshi <joshi.k@samsung.com>
Message-id: <0ab2f0e1-27f2-7ab4-1772-f96c1430ea3b@samsung.com>
Date:   Wed, 30 Jan 2019 19:24:39 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
        Thunderbird/52.6.0
MIME-version: 1.0
In-reply-to: <20190130001349.GT6173@dastard>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-US
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsWy7bCmqa7l2sAYg8WdIhb/9xxjs9hy7B6j
        xfPlixktZk9vZrK4d/QLk8XeW9oWM+fdYbPYs/cki8X8ZU/ZLa5MWcRs0drzk92B22Ni8zt2
        j1OLJDwW73nJ5LF5Sb1H05mjzB59W1YxeqzfcpXF48yCI+wenzfJBXBGcdmkpOZklqUW6dsl
        cGUcfitUsEqx4sGbF6wNjDcluxg5OCQETCTufGXtYuTiEBLYwShxYdZb5i5GTiDnO6PEjVfW
        IDZIzaLfRxghijYwSly6eY4JougBo0TvYk4QW1jAVOLjthWsILaIgL3E7is7wGqYBfYyS1z9
        pQKyjE1AU+LC5FKQMK+AncTlWVNYQGwWAVWJ2UfOMILYogIREgunPmWEqBGU+DH5HlgNp4CO
        xNZP+xghRlpJPPvXygphi0s0t95kgbDlJTavAbmfC+jmbnaJnW+Os0I84CLxf8VWZghbWuLZ
        qo2MEHaxxK87R6EaOhglrjfMZIFI2Etc3PMX6gE+iY7Df9khocUr0dEmBGF6SHz4rQEJkzdM
        Eo/+NLFMYJSZheTuWUhunYXk1llIbl3AyLKKUSy1oDg3PbXYqMBYrzgxt7g0L10vOT93EyM4
        zWi572Dcds7nEKMAB6MSD2/H6sAYIdbEsuLK3EOMEhzMSiK8hr/9Y4R4UxIrq1KL8uOLSnNS
        iw8xSnOwKInzPpSeGy0kkJ5YkpqdmlqQWgSTZeLglGpgPPZMZKJJ1o/qC5Jaf8xjrMz0bEr+
        lHy4IbN/g2jy2dK971ry9HhfstvYHM7m9vbncDwf3iO36+O5ib7ed37yhe+c9d9JuzOgyEbn
        5tSPcZqbapZz3BCsdE9veDnfT4j92s/ZDL0Z8w1mmh1T35vWkf38tdmjbRMnqB6f7+q5iMW0
        Of/M39WflFiKMxINtZiLihMB75wicS8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jQV3LtYExBpPnMln833OMzWLLsXuM
        Fs+XL2a0mD29mcni3tEvTBZ7b2lbzJx3h81iz96TLBbzlz1lt7gyZRGzRWvPT3YHbo+Jze/Y
        PU4tkvBYvOclk8fmJfUeTWeOMnv0bVnF6LF+y1UWjzMLjrB7fN4kF8AZxWWTkpqTWZZapG+X
        wJVx+K1QwSrFigdvXrA2MN6U7GLk5JAQMJFY9PsIYxcjF4eQwDpGie17rrBDOI8YJT78m88O
        UiUsYCrxcdsKVhBbRMBeYveVHUwgRcwCe5kl9s7fzwrR8Y5JYubbo0AOBwebgKbEhcmlIA28
        AnYSl2dNYQGxWQRUJWYfOcMIYosKREh0rpzPAlEjKPFj8j0wm1NAR2Lrp31gNcwCZhJfXh5m
        hbDFJZpbb7JA2PISm9e8ZZ7AKDALSfssJC2zkLTMQtKygJFlFaNkakFxbnpusVGBUV5quV5x
        Ym5xaV66XnJ+7iZGYERtO6zVv4Px8ZL4Q4wCHIxKPLwMwQExQqyJZcWVuYcYJTiYlUR4DX/7
        xwjxpiRWVqUW5ccXleakFh9ilOZgURLn5c8/FikkkJ5YkpqdmlqQWgSTZeLglGpgFE8W4Vs/
        M+D8mo9LJgW5qzWZhjz5troqMlAr1k2De+0/7c0Cz9hVF08RuNe//MuSGEN52fOz259FXb+7
        287j07+Stku/Pt2rVlkhyDnpzpOWc1Y6yfOXbHPd+OP20wsn/q1+//381NjPzZtmKGcmT94Y
        +3l/bdJlmX8vttXf+P/XLcd1C0cQU5gSS3FGoqEWc1FxIgBvwsSHpAIAAA==
X-CMS-MailID: 20190130135713epcas2p36f828f7e372dcc1ad49f31e3547d3232
CMS-TYPE: 102P
X-CMS-RootMailID: 20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17
References: <CGME20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17@epcas2p4.samsung.com>
        <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
        <20190125162353.GA11210@localhost.localdomain>
        <20190128124709.GB27972@quack2.suse.cz>
        <20190128232423.GD15302@localhost.localdomain>
        <20190129100702.GA29981@quack2.suse.cz> <20190130001349.GT6173@dastard>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On Wednesday 30 January 2019 05:43 AM, Dave Chinner wrote:
> On Tue, Jan 29, 2019 at 11:07:02AM +0100, Jan Kara wrote:
>> On Mon 28-01-19 16:24:24, Keith Busch wrote:
>>> On Mon, Jan 28, 2019 at 04:47:09AM -0800, Jan Kara wrote:
>>>> On Fri 25-01-19 09:23:53, Keith Busch wrote:
>>>>> On Wed, Jan 09, 2019 at 09:00:57PM +0530, Kanchan Joshi wrote:
>>>>>> Towards supporing write-hints/streams for filesystem journal.
>>>>>>                                                                                  
>>>>>> Here is the v1 patch for background -
>>>>>> https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2
>>>>>>                                                                                  
>>>>>> Changes since v1:
>>>>>> - introduce four more hints for in-kernel use, as recommended by Dave chinner
>>>>>>    & Jens axboe. This isolates kernel-mode hints from user-mode ones.
>>>>>
>>>>> The nvme driver disables streams if the controller doesn't support
>>>>> BLK_MAX_WRITE_HINT number of streams, so this series breaks the feature
>>>>> for controllers that only support up to 4.
>>>>
>>>> Right. Do you know if there are such controllers? Or are you just afraid
>>>> that there could be?
>>>
>>> I've asked around, and the concensus I received is all currently support
>>> at least 8, but they couldn't say if that would be true for potential
>>> lower budget products. Can we implement a reasonable fallback to use
>>> what's available?
>>
>> OK, thanks for input. So probably we should just map kernel stream IDs to 0
>> if the device doesn't support them. But that probably means we need to
>> propagate number of available streams up from NVME into the block layer so
>> that this can be handled reasonably seamlessly. Jens, Kanchan?
> 
> Yeah, that's basically what I said we needed to do when this was
> last discussed. i.e. that the block layer needed to know how many
> streams the hardware had and map the 4 "kernel internal" hints
> appropriately to what he device supports.
> 
> e.g. if the device only supports 4 hints, then it needs to map the
> kernel hints either to zero. If it supports less than 8 streams,
> then they need otbe mapped into the hints above index 5. If there
> are N streams, then they need to be mapped to the hints {N-3,N}
> 
> And, to top it all off, there needs to be guards so that if we want
> to grow the userspace hints to more than 4 hints, they don't crash
> into ranges the kernel is already reserving because of limited
> device range support.
> 
> Nothing is ever simple....
> 
Thanks all for feedback.
user-hints, when they reach to kernel via fcntl path, are sanity-checked 
(rw_hint_valid function).
Currently streams are enabled when nvme driver is made to run with 
"streams =1" option, while stream users always pass some write-hint, 
without bothering whether streams (and how many of those) are 
operational or not. This keeps configuration simple for stream users. 
Second, block layer does not translate write-hint to stream-number, 
rather it is done inside nvme driver. I suppose I should keep both these 
properties intact.
And considering all the suggestions, this is the plan for V3 -

[In block layer]
1. Introduce one macro "KERN_WRITE_HINT_MIN" which will take the value 
"user_hint_cnt + 1".
FS code will use this value (onwards) to define their own streams.

2. Introduce another macro "BLK_MAX_KERNEL_WRITE_HINTS" which will be 
set to 4 for now.

[In nvme driver]
1. Continue working as before if device supports just 4 streams. All 
these streams are used by user-hints, and kernel-hints are translated to 0.

2. If device supports any more than 4 streams, those will be mapped to 
serve kernel-hints, starting from KERN_WRITE_HINT_MIN onwards.
For example, if device has 6 streams, four streams (numbers = 1,2,3,4) 
will be used to serve user-hints and two streams ( numbers = 65535, 
65534) will be used to serve first two kernel hints. Other kernel-hints 
get mapped to 0. OTOH, if device has 10 streams, first four kernel-hints 
will be mapped to non-zero values (65535 to 65532) and anything else 
would get turned to 0.


Let me know if this sounds fine?


Thanks,
Kanchan






