Return-Path: <SRS0=wlmB=SF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7AEC4360F
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 14:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EDC720830
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 14:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oQN+KN7Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfDCOrz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 3 Apr 2019 10:47:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43098 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfDCOru (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Apr 2019 10:47:50 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190403144747epoutp04719bfceebe8a0fc572e2ee7fc8962ef4~R-jkOop3K2355523555epoutp04f
        for <linux-ext4@vger.kernel.org>; Wed,  3 Apr 2019 14:47:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190403144747epoutp04719bfceebe8a0fc572e2ee7fc8962ef4~R-jkOop3K2355523555epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1554302867;
        bh=Ik3x2jg4dFtuwVGA07IVMFfjWBKhLA8qT0YbPTH/qbg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=oQN+KN7Z8Lf6kBPrLO4mbNQ79s3q2Ij75nuBG+038SNJbg3mP6Aws3PwOpXNtLiaw
         aqe1ip431Mhrc8d1RB+VGfjWS5GYtNbWqu4sdSqshXE4JhJE8CAf+qnkzMn2u2QL91
         SOysWDOw2wrlgl1w9seMoXJRJmaOZR5aUa2JMMyk=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20190403144746epcas5p2d2478f6e8d574d29109e66893d819942~R-ji9gJBc1327713277epcas5p2G;
        Wed,  3 Apr 2019 14:47:46 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.D6.04067.197C4AC5; Wed,  3 Apr 2019 23:47:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20190403144744epcas5p4f177adcd2ba698be7563e96788a4fc63~R-jh00PZ12903729037epcas5p4R;
        Wed,  3 Apr 2019 14:47:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190403144744epsmtrp2cd5035576b3efa74d99ae15e6c713e16~R-jh0E53i2684726847epsmtrp2M;
        Wed,  3 Apr 2019 14:47:44 +0000 (GMT)
X-AuditID: b6c32a4b-78bff70000000fe3-7f-5ca4c79137cb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7F.B1.03692.097C4AC5; Wed,  3 Apr 2019 23:47:44 +0900 (KST)
Received: from JOSHIK01 (unknown [107.111.93.135]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20190403144742epsmtip210a9a5c74e13c0e211f4461cac6bb541~R-jgFYRWK2419024190epsmtip29;
        Wed,  3 Apr 2019 14:47:42 +0000 (GMT)
From:   "kanchan" <joshi.k@samsung.com>
To:     "'Jan Kara'" <jack@suse.cz>, "'Dave Chinner'" <david@fromorbit.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <axboe@fb.com>,
        <prakash.v@samsung.com>, <anshul@samsung.com>,
        <joshiiitr@gmail.com>
In-Reply-To: <20190403093610.GE8836@quack2.suse.cz>
Subject: RE: [PATCH v3 3/7] block: add write-hint to stream-id conversion
Date:   Wed, 3 Apr 2019 20:17:32 +0530
Message-ID: <11cf01d4ea2c$32666920$97333b60$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQE0pJf9fllz3AfCWkxgRsQT/9U6SAHd8tMyAXaChx0CBP0rFQHUTth6AfWMST8BtgfTAqcUQCcQ
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsWy7bCmlu6k40tiDD7cYLL4PX0Kq8X/PcfY
        LLYcu8doMXt6M5PF+beHmSz23tK2mDnvDpvFnr0nWSwu75rDZjF/2VN2iytTFjE7cHtMbH7H
        7nFqkYTHzll32T02L6n36NuyitHjzIIj7B6fN8kFsEdx2aSk5mSWpRbp2yVwZbTMecFU8EGg
        4nfnfrYGxp28XYycHBICJhKtL/exdTFycQgJ7GaUOHv9HjuE84lRovPBJkYI5xujxJPru5hg
        Wv4eaIFK7GWU2DR5F1TLc0aJjUcPgFWxCahK3PvRywZiiwi4S7y6cRCsg1ngH6PE4Zkv2UES
        nALGEh+2zgdrEBbwlHix8ihYA4uAikTr3gawOK+ApURX+w42CFtQ4uTMJywgNrOAvMT2t3OY
        IU5SkNj96SgrxLIoieVrnzNC1IhLvDx6BOw6CYHJ7BJflvxngWhwkdi88C1Us7DEq+Nb2CFs
        KYnP7/ayQdjFEr/uHGWGaO5glLjeMBOq2V7i4p6/QNdxAG3QlFi/Sx9iGZ9E7+8nYGEJAV6J
        jjYhiGpFiXuTnrJC2OISD2csYYUo8ZDYddBhAqPiLCSfzULy2SwkH8xC2LWAkWUVo2RqQXFu
        emqxaYFxXmq5XnFibnFpXrpecn7uJkZwAtPy3sG46ZzPIUYBDkYlHt4FK5fECLEmlhVX5h5i
        lOBgVhLhPdO/IEaINyWxsiq1KD++qDQntfgQozQHi5I471zZudFCAumJJanZqakFqUUwWSYO
        TqkGxrKT/xSMBUL51v288rCt4pa1ab9W9e68pXxM08+W/gi9aDC3/96xZNv099VWB587mrgV
        hKgLLS24LfjbRUhtXXTN4+eVhhtkbL9vVd664lS9bcokuTfJvPGK7HH536ZuYJwrnz1Z61fU
        nYnVae7+Z871rdZ6/r+Df96Cn9Gcm24sP985/6AKtxJLcUaioRZzUXEiAJkPCMtcAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWy7bCSvO6E40tiDK780bT4PX0Kq8X/PcfY
        LLYcu8doMXt6M5PF+beHmSz23tK2mDnvDpvFnr0nWSwu75rDZjF/2VN2iytTFjE7cHtMbH7H
        7nFqkYTHzll32T02L6n36NuyitHjzIIj7B6fN8kFsEdx2aSk5mSWpRbp2yVwZbTMecFU8EGg
        4nfnfrYGxp28XYycHBICJhJ/D7QwdjFycQgJ7GaUWPTuDxtEQlyi+doPdghbWGLlv+dgtpDA
        U0aJuVsFQWw2AVWJez96wepFBDwlFh/vBxvELNDBJLHq6BmoqXeYJC5M6gOr4hQwlviwdT4T
        iC0M1PFi5VGwOIuAikTr3gawOK+ApURX+w42CFtQ4uTMJyxdjBxAU/Uk2jYygoSZBeQltr+d
        wwxxnILE7k9HWSGOiJJYvvY5VI24xMujR9gnMArPQjJpFsKkWUgmzULSsYCRZRWjZGpBcW56
        brFhgWFearlecWJucWleul5yfu4mRnAMamnuYLy8JP4QowAHoxIP74/VS2KEWBPLiitzDzFK
        cDArifCe6V8QI8SbklhZlVqUH19UmpNafIhRmoNFSZz3ad6xSCGB9MSS1OzU1ILUIpgsEwen
        VAPj9Pv2277fm9whHOwY8/KG6ZKvK3YeX7vQRSUh4NCs/Rf/HmB828b1jOn2Xvlauw67iZ+a
        vprOO75bWdHug7qHVcEOfaa7Gh+yHacJWTfnHpiS4efMq/gvUeJJrknFZxaO4yVrGoO1fr87
        p7pwQoSopEyUm9KSvggXNd43dwQ37SufsHeFl0+fEktxRqKhFnNRcSIApPCHLb0CAAA=
X-CMS-MailID: 20190403144744epcas5p4f177adcd2ba698be7563e96788a4fc63
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20190329075749epcas2p22b85cbdbb7ccb4f7f3ecf69b84f75dc9
References: <1553846032-4451-1-git-send-email-joshi.k@samsung.com>
        <CGME20190329075749epcas2p22b85cbdbb7ccb4f7f3ecf69b84f75dc9@epcas2p2.samsung.com>
        <1553846032-4451-4-git-send-email-joshi.k@samsung.com>
        <20190401050821.GQ23020@dastard> <20190402092044.GE12133@quack2.suse.cz>
        <20190402203508.GT26298@dastard> <20190403093610.GE8836@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> Then do what we do now for that case. For every other case, the kernel 
> should have reserved space and not get intermingled with userspace 
> hints.

I hope this means that we're fine with the current conversion approach. 
As you would have noticed, current approach does not disable stream feature
based on dearth of streams.
It either exposes 8 streams (if device has equal or more than 8 streams) or
N streams (if N is less than 8). 
For less than 8 streams case, user-space hints get priority over
kernel-space hints. But at any point of time, there is no intermingling.


Thanks,
Kanchan

-----Original Message-----
From: Jan Kara [mailto:jack@suse.cz] 
Sent: Wednesday, April 03, 2019 3:06 PM
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>; Kanchan Joshi <joshi.k@samsung.com>;
linux-kernel@vger.kernel.org; linux-block@vger.kernel.org;
linux-nvme@lists.infradead.org; linux-fsdevel@vger.kernel.org;
linux-ext4@vger.kernel.org; axboe@fb.com; prakash.v@samsung.com;
anshul@samsung.com; joshiiitr@gmail.com
Subject: Re: [PATCH v3 3/7] block: add write-hint to stream-id conversion

On Wed 03-04-19 07:35:08, Dave Chinner wrote:
> On Tue, Apr 02, 2019 at 11:20:44AM +0200, Jan Kara wrote:
> > On Mon 01-04-19 16:08:21, Dave Chinner wrote:
> > > On Fri, Mar 29, 2019 at 01:23:48PM +0530, Kanchan Joshi wrote:
> > > > +		if(streamid > nr_streams)
> > > > +			streamid = 0;
> > > 
> > > So, basically, we'll compress all the kernel hints down to "no hint"
> > > if there are more user streams than the device supports?
> > > 
> > > Surely we should be reserving a stream for the kernel hints 
> > > separate from the user and "none" streams when we have limited 
> > > device streams available...
> > 
> > The question is what to do in a situation when the device has 
> > exactly as many hints as we currently offer to userspace.
> 
> Then do what we do now for that case. For every other case, the kernel 
> should have reserved space and not get intermingled with userspace 
> hints.

Yup, we are on the same page then.

								Honza
--
Jan Kara <jack@suse.com>
SUSE Labs, CR

