Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE48C282C7
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 14:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A04D7218A2
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 14:23:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WadKhcge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfAYOXi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 25 Jan 2019 09:23:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50718 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbfAYOXh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jan 2019 09:23:37 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20190125142334epoutp038524800fefff976fe5905173d0fd4793~9HXApazOi2614126141epoutp03d;
        Fri, 25 Jan 2019 14:23:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20190125142334epoutp038524800fefff976fe5905173d0fd4793~9HXApazOi2614126141epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1548426214;
        bh=XPFJiucx4QIjip+P3jjob6oWwEnG/5Zd00rBwuUWYqo=;
        h=Subject:To:Cc:From:Date:In-reply-to:References:From;
        b=WadKhcgev18lrHhsObwYVriFkPVYAkQIZQtbl3vDjccy/ILbE/jsrkI+tmWsrs71n
         I78RwH8pPv/DAIzshO5cl9DfHd/neRDvPoT8p9oTWbAkDLdNvmUDEMpKlJ7pFk4Wkq
         8rA4bMobhZBpZV7vPj6jYn2KnenhrCF+SbkoJ0o0=
Received: from epsmges1p1.samsung.com (unknown [182.195.42.53]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190125142333epcas1p2d657c45aa3ecbaaaa2d98473cfa0569f~9HW-ZTzsx0185301853epcas1p2w;
        Fri, 25 Jan 2019 14:23:33 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.00.04074.5EB1B4C5; Fri, 25 Jan 2019 23:23:33 +0900 (KST)
Received: from epsmgms2p1new.samsung.com (unknown [182.195.42.142]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190125142331epcas1p10d435e6ffe573611b71ce4ba6ece8b98~9HW_SyXiH0363803638epcas1p1L;
        Fri, 25 Jan 2019 14:23:31 +0000 (GMT)
X-AuditID: b6c32a35-297ff70000000fea-66-5c4b1be5fed4
Received: from epmmp1.local.host ( [203.254.227.16]) by
        epsmgms2p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        79.84.04015.3EB1B4C5; Fri, 25 Jan 2019 23:23:31 +0900 (KST)
Received: from [107.108.221.212] by mmp1.samsung.com (Oracle Communications
        Messaging Server 7.0.5.31.0 64bit (built May  5 2014)) with ESMTPA id
        <0PLW00H0C5AMH5A0@mmp1.samsung.com>; Fri, 25 Jan 2019 23:23:31 +0900 (KST)
Subject: Re: [PATCH v2 0/4] Write-hint for FS journal
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        jack@suse.com, david@fromorbit.com, Jan Kara <jack@suse.cz>,
        prakash.v@samsung.com
From:   Kanchan Joshi <joshi.k@samsung.com>
Message-id: <fb13c936-aa6c-46af-7d35-72548b5baaab@samsung.com>
Date:   Fri, 25 Jan 2019 19:50:50 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
        Thunderbird/52.6.0
MIME-version: 1.0
In-reply-to: <20190124082933.GA12184@quack2.suse.cz>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-US
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42LZdlhTV/eptHeMwYyVLBar7/azWWw5do/R
        4vnyxYwWs6c3M1nsvaVtMXPeHTaLPXtPsljMX/aU3eLKlEXMDpwepxZJeFw+W+qxeUm9R9+W
        VYwe67dcZfE4s+AIu8fnTXIB7FFcNimpOZllqUX6dglcGRte32Mt+MJfMeFBVgNjA3cXIyeH
        hICJxMWjq5i6GLk4hAR2MEr8mbKFEcL5ziix/fF5dpiq8+93sEMkdjNKvDh+GqrlAaPEjsk/
        WUGqhAVMJT5uWwFmiwgoSPT8XskGUsQscIlR4nvrKqAEBwebgKbEhcmlIDW8AnYSZz9sZgax
        WQRUJbZ/XMAGYosKREgsnPqUEaJGUOLH5HssIDYn0BVnHywCq2EWsJJ49q+VFcIWl2huvckC
        YctLbF7zlhlkr4TAczaJQ/dOskK84CJxd9pSZpAbJASkJS4dtYUIF0v8unMUqr6DUeJ6w0wW
        iIS9xMU9f5kghvJJvPvawwrRyyvR0SYEYXpIfPitAQmHA4wS715cZ5rAKDMLydmzkJw6C8mp
        s5CcuoCRZRWjWGpBcW56arFhgaFecWJucWleul5yfu4mRnAK0TLdwTjlnM8hRgEORiUe3gh+
        7xgh1sSy4srcQ4wSHMxKIrycAkAh3pTEyqrUovz4otKc1OJDjNIcLErivOsdnGOEBNITS1Kz
        U1MLUotgskwcnFINjBNmi/6zsNn5ceaUBqX/m3/dmLeNWUa2dlad0r53zOVvxdw/nD40jenl
        SwUB/ZfCAnsPBjyPlVUKbLr340jwxax53bOX3ZoSONNS8Xa4jVG3UiXHwfiHVSoix59e0zuW
        Lj1z9d3CT4vqMqTO//it8uerRtLJ2JIVLb/Do9MFIkLzNe7fzw7x+K3EUpyRaKjFXFScCABs
        S0DUHQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t9jAd3H0t4xBo2TjSxW3+1ns9hy7B6j
        xfPlixktZk9vZrLYe0vbYua8O2wWe/aeZLGYv+wpu8WVKYuYHTg9Ti2S8Lh8ttRj85J6j74t
        qxg91m+5yuJxZsERdo/Pm+QC2KO4bFJSczLLUov07RK4Mja8vsda8IW/YsKDrAbGBu4uRk4O
        CQETifPvd7B3MXJxCAnsZJQ4s28eM0hCSOARkNNTC2ILC5hKfNy2ghXEFhFQkOj5vZINpIFZ
        4BKjxK/zTUwQ3YcYJXZNbwQaxcHBJqApcWFyKUgDr4CdxNkPm8GGsgioSmz/uIANxBYViJDo
        XDmfBaJGUOLH5HtgNifQRWcfLAKrYRYwk/jy8jArhC0u0dx6kwXClpfYvOYt8wRGgVlI2mch
        aZmFpGUWkpYFjCyrGCVTC4pz03OLjQoM81LL9YoTc4tL89L1kvNzNzECo2TbYa2+HYz3l8Qf
        YhTgYFTi4d0g6B0jxJpYVlyZC/QkB7OSCC+nAFCINyWxsiq1KD++qDQntfgQozQHi5I47+28
        Y5FCAumJJanZqakFqUUwWSYOTqkGxpU/T6YxlWz8FBRxs98+5jZzRHbuwcNTxC6WvTcwtFZ+
        sPbxy9XNt48sec9uWPb1yZZljYfF5xusy156br3t910Fl7YELlvA+bFng9/JD5mdevNDQm3n
        SLEq3pkSYD7Loe7dHslOvTNzVnB+X3/zrcL0/86hZq4VQhUPbrLy6C3heOe8/+SWkzuVWIoz
        Eg21mIuKEwEmaF9rjgIAAA==
X-CMS-MailID: 20190125142331epcas1p10d435e6ffe573611b71ce4ba6ece8b98
CMS-TYPE: 101P
X-CMS-RootMailID: 20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17
References: <CGME20190109153328epcas2p4643cbdc7a2182b47893a2bcaa0778e17@epcas2p4.samsung.com>
        <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
        <20190124082933.GA12184@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Jens,
Can you please have a glance on this patch series, given than attempt is 
to extend the original architecture of write-hints.

Thanks,

On Thursday 24 January 2019 01:59 PM, Jan Kara wrote:
> Hello,
> 
> On Wed 09-01-19 21:00:57, Kanchan Joshi wrote:
>> Towards supporing write-hints/streams for filesystem journal.
>>                                                                                  
>> Here is the v1 patch for background -
>> https://marc.info/?l=linux-fsdevel&m=154444637519020&w=2
>>                                                                                  
>> Changes since v1:
>> - introduce four more hints for in-kernel use, as recommended by Dave chinner
>>    & Jens axboe. This isolates kernel-mode hints from user-mode ones.
>> - remove mount-option to specify write-hint, as recommended by Jan kara &
>>    Dave chinner. Rather, FS always sets write-hint for journal. This gets ignored
>>    if device does not support stream.
>> - Removed code-redundancy for write_dirty_buffer (Jan kara's review comment)
> 
> I guess the series should also go to Jens since he was the original author
> of write-hint support so he has the best idea about the architecture.
> 
> 								Honza
> 
>> Kanchan Joshi (4):
>>    block: Increase count of supported write-hints
>>    fs: introduce four macros for in-kernel hints
>>    fs: introduce APIs to enable sending write-hint with buffer-head
>>    fs/ext4,jbd2: add support for passing write-hint with journal.
>>
>>   fs/buffer.c                 | 18 ++++++++++++++++--
>>   fs/ext4/super.c             |  2 ++
>>   fs/jbd2/commit.c            | 11 +++++++----
>>   fs/jbd2/journal.c           |  3 ++-
>>   fs/jbd2/revoke.c            |  3 ++-
>>   include/linux/blkdev.h      |  5 ++++-
>>   include/linux/buffer_head.h |  3 +++
>>   include/linux/fs.h          |  5 +++++
>>   include/linux/jbd2.h        |  8 ++++++++
>>   9 files changed, 49 insertions(+), 9 deletions(-)
>>
>> -- 
>> 2.7.4
>>
>>
