Return-Path: <SRS0=wlmB=SF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC5DC4360F
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 14:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA67F20882
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 14:30:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WjuzflWw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfDCOah (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 3 Apr 2019 10:30:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35066 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfDCOag (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2019 10:30:36 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20190403143034epoutp01fa4758a3e00ed4d6d06152f87752c5d4~R-UiWA2av2459524595epoutp019
        for <linux-ext4@vger.kernel.org>; Wed,  3 Apr 2019 14:30:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20190403143034epoutp01fa4758a3e00ed4d6d06152f87752c5d4~R-UiWA2av2459524595epoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1554301834;
        bh=+F7hRxdS2KNX5g1XcJobi4Ayb71DLbsZxQetbH+CdZc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=WjuzflWwexGSmfTmaEduznJhGfVlukD1Q6c/NBNADh+twZZjiyi57k2ISmMgYGay2
         KxWIykkXK4x7yuTIk9rf7bPVLzlbqtL6Phi1D5837EQZbZHBStdyE5hrQqE7oFbC8J
         0NUREOKBrbiIzv48XNL/IJtC4DiDFKs0/JZpUdWs=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20190403143033epcas5p239ad3d0505252fdaca7ed28d4a4d073d~R-Ug80YoU1769917699epcas5p2X;
        Wed,  3 Apr 2019 14:30:33 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.A5.04066.983C4AC5; Wed,  3 Apr 2019 23:30:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20190403143032epcas5p432c879ab06f75d97c06de0366e1dfa37~R-Ugsp16M1503315033epcas5p4t;
        Wed,  3 Apr 2019 14:30:32 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190403143032epsmtrp2a7fce6b1b7a82202a723f18bfc52ae96~R-Ugr4IQD2162421624epsmtrp2J;
        Wed,  3 Apr 2019 14:30:32 +0000 (GMT)
X-AuditID: b6c32a4a-95bff70000000fe2-dd-5ca4c3890ae7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.F2.03662.883C4AC5; Wed,  3 Apr 2019 23:30:32 +0900 (KST)
Received: from JOSHIK01 (unknown [107.111.93.135]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20190403143031epsmtip1062d6b77d84ef265a3a4b37e1a6562a9~R-UfNfWP83016930169epsmtip10;
        Wed,  3 Apr 2019 14:30:31 +0000 (GMT)
From:   "kanchan" <joshi.k@samsung.com>
To:     "'Dave Chinner'" <david@fromorbit.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <axboe@fb.com>,
        <prakash.v@samsung.com>, <anshul@samsung.com>,
        <joshiiitr@gmail.com>
In-Reply-To: <20190401051239.GP26298@dastard>
Subject: RE: [PATCH v3 6/7] fs: introduce write-hint start point for
 in-kernel hints
Date:   Wed, 3 Apr 2019 20:00:22 +0530
Message-ID: <11ce01d4ea29$cb576c90$620645b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQE0pJf9fllz3AfCWkxgRsQT/9U6SAHaCoqAAdy8AAEBs1spx6c/rcJQ
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUhTYRTGfXfv3b0bLW9T8WiZurJwoZYU3D5ICYmhUmFQVGKNuvita1ct
        DWpkmK60NDM3ZootsQgKUzPnKFx+a1GWE1FR0JyVZlphiRnbNfK/33nP85xzHngpTGomPKn4
        lDRWnaJMkgnFeL3Ff3NAnsUYvbVfhzMLd4oJZqmpVcjUtg4j5s2URcCYB7YwuruDQqbJ3IEz
        vY0GIVNeNU4y74srsVCxojB7mlR0VoLiuX6IVDw1XlIU1D5Eirma9YeEx8V7zrBJ8RmsOmjv
        KXFc4eJHTFXtfd4wayA0aAa0SEQBvR2sLy5jWiSmpLQJQVvdEwFfzCK4bbGRdpWU/olg0CbV
        Isrh6LQG8xozggZbNckXEwh6CwxCu0FI+8HwfL6DXWk5mEpHCLsIo/8gsOgmHVNFdABkl7/E
        7OxCH4HrOhuyM05vhPbfebidJfROyK7RkDyvgQ7dmOMdo73h2ZQB4zP4gGm2heCX7Yd7I/3L
        GneYbHnluA7oaySUTdwn+QhhsNjnxntd4FNbLcmzJ8xNm4U8c/B7sAXjvbkIrBodzjdC4G3T
        osA+B6P94XFjEL9rNeQvjAn48RLIzZHyal8YLhoneHaH0VLjMiugprwOv4l89SuS6Vck069I
        oP+/rALhD5EHq+KSY1luhyo4hT0XyCmTufSU2MDTqck1yPGp5OENqOp1ZDOiKSRbJal4YIyW
        EsoMLjO5GQGFyVwl3TcqoqWSM8rMLFadelKdnsRyzWgthcvcJWVeZSekdKwyjU1kWRWr/tcV
        UCJPDYqsco668CUkwt/tQ0VI6BE8a92o9eiPbz2hc37HvoJo/t3ERa8NZT1DXRTxyKOp5Mpz
        eWD/TJhMu++AxyaDqv1WgtWW8ysq3CVm57HSLr+DREnf0qOiXROHYzUDCVN0sOl7jqg5jk2c
        rzUOOJ2t10YsTGZf/RzT2h1e3LjbadzZR4ZzccptckzNKf8CgHHq+FADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWy7bCSnG7H4SUxBqs/6Fv8nj6F1eL/nmNs
        FluO3WO0OP/2MJPF3lvaFjPn3WGz2LP3JIvF5V1z2CzmL3vKbnFlyiJmBy6Pic3v2D1OLZLw
        2DnrLrvH5iX1Hn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJUx8e8z5oIV8hVzPs1hbWD8INHF
        yMEhIWAiceq6URcjF4eQwG5GiScPNzJ2MXICxcUlmq/9YIewhSVW/nsOZgsJPGWUODQrHsRm
        E1CVuPejlw3EFhHQktg94wEryCBmgQ4miVVHzzBCTH3DKLH+62KwKk4BXYnm+QeYQTYLC4RI
        LLltChJmEVCROPGrkwXE5hWwlGje1MAOYQtKnJz5hAWknFlAT6IN4jZmAXmJ7W/nMEPcpiCx
        +9NRVogb3CQWP7jBAlEjLvHy6BH2CYzCs5BMmoUwaRaSSbOQdCxgZFnFKJlaUJybnltsWGCU
        l1quV5yYW1yal66XnJ+7iREca1paOxhPnIg/xCjAwajEw7tg5ZIYIdbEsuLK3EOMEhzMSiK8
        Z/oXxAjxpiRWVqUW5ccXleakFh9ilOZgURLnlc8/FikkkJ5YkpqdmlqQWgSTZeLglGpgtO+I
        6jUNVtffnsLx6uqimoOHGX8uentjbvjku6cUvsfqWsypOKy5d1GsQdn++X5nrsadLF16uuec
        Vd58JgFrrjWbXZ/Od/FP5mHiv/1raYgWv5zdw7NqF5gFGbOOMaZuYNcM+bKaV1ln7Yqqj2cz
        XP4sZfv3IUx3a6CkepVz3tzNJ21XTvo+VYmlOCPRUIu5qDgRABNC/T6xAgAA
X-CMS-MailID: 20190403143032epcas5p432c879ab06f75d97c06de0366e1dfa37
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20190329075758epcas1p335511dcb10bb5592ea72409a1d01e752
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075758epcas1p335511dcb10bb5592ea72409a1d01e752@epcas1p3.samsung.com>
        <1553846032-4451-7-git-send-email-joshi.k@samsung.com>
        <20190401051239.GP26298@dastard>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> Which means that when a new userspace hint is defined, all the kernel
hints change numbers and, AIUI, that changes how the kernel hints are mapped
to the underlying device.

Currently adding a new user-space hint requires modifying code and
installing modified kernel. So I felt it would be less probable to encounter
that situation while in production workload.


>The kernel hints need to be mapped to the highest supported number a work
down, while userspace starts at the lowest and works up.

Actually, I initially implemented "blk_write_hint_to_streamid" function like
that i.e. as per the table you've put. But that code involved more
checks/branches (condition checks) than the current one.
Also, request queue contained this statically defined array called
"write_hints", which nvme driver updated to gather stream stats.
Snippet below - 

  	if (streamid < ARRAY_SIZE(req->q->write_hints))
		req->q->write_hints[streamid] += blk_rq_bytes(req) >> 9;

That requires nvme driver doing a reverse conversion from streamid to
array-index(some more conditional checks) if kernel-hints get mapped to
highest possible stream numbers.


Overall, will it not be about adding additional  run-time checks in I/O path
(which we will always execute) for the condition which will happen only if
one chooses to extend user-space hint count in between?


Thanks,

-----Original Message-----
From: Dave Chinner [mailto:david@fromorbit.com] 
Sent: Monday, April 01, 2019 10:43 AM
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: linux-kernel@vger.kernel.org; linux-block@vger.kernel.org;
linux-nvme@lists.infradead.org; linux-fsdevel@vger.kernel.org;
linux-ext4@vger.kernel.org; axboe@fb.com; prakash.v@samsung.com;
anshul@samsung.com; joshiiitr@gmail.com
Subject: Re: [PATCH v3 6/7] fs: introduce write-hint start point for
in-kernel hints

On Fri, Mar 29, 2019 at 01:23:51PM +0530, Kanchan Joshi wrote:
> kernel-mode components can define own write-hints using 
> "WRITE_LIFE_KERN_MIN" as base.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  include/linux/fs.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h index 
> 29d8e2c..6a2673e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -291,6 +291,8 @@ enum rw_hint {
>  	WRITE_LIFE_MEDIUM	= RWH_WRITE_LIFE_MEDIUM,
>  	WRITE_LIFE_LONG		= RWH_WRITE_LIFE_LONG,
>  	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
> +/* Kernel should use write-hint starting from this */
> +	WRITE_LIFE_KERN_MIN,

Which means that when a new userspace hint is defined, all the kernel hints
change numbers and, AIUI, that changes how the kernel hints are mapped to
the underlying device.

The kernel hints need to be mapped to the highest supported number a work
down, while userspace starts at the lowest and works up. The "kernel to
device stream id" needs to translate the kernel hints down to the upper
range of the device hints.

I think the mapping range the code uses should be:

    HINT		Type			device
     0			USER 0			  0
     1			USER 1			  1
     ......
     n			USER MAX		  n

     {n,65535-m}	UNUSED			{n,dev_max-m}

     65535 - m		KERN_MIN,		dev_max - m
     ......
     65532		KERN 3			dev_max - 3
     65533		KERN 2			dev_max - 2
     65534		KERN 1			dev_max - 1
     65535		KERN 0			dev_max

i.e. if you look at the mapping as a signed short, >= 0 are user hints, < 0
are kernel hints. This provides an obvious, simple way to map the kernel
hints to the upper range of the device hint range. It also provides a simple
way to compress both user and kernel hints into a limited device hint range
- kernel always uses the top device hint, user is limited to the rest of the
range....

This means the ranges don't overlap or change at either the code or the
device level as we add more user and kernel hint channels in the future.

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

