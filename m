Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB99C282E3
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 13:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A19C2064A
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 13:33:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="iRXdnekE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfDVNdq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 09:33:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60538 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbfDVNdh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Apr 2019 09:33:37 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190422133334epoutp044186d3ced219a88c14cf6e6716018146~XzzMdc7ic3127231272epoutp04d
        for <linux-ext4@vger.kernel.org>; Mon, 22 Apr 2019 13:33:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190422133334epoutp044186d3ced219a88c14cf6e6716018146~XzzMdc7ic3127231272epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555940014;
        bh=sd1eXOswPa5nm3ChHzPMI6ycwmTgYTh2kSxeQr83gps=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=iRXdnekELPof2kfJ7X6gZ2lNgNh4o3GO21KL4ff3QHBRiNvRzYbX27uv5hFKY0jRA
         D3a8/mbd8LVGiiw4FZMTdkAQT3glHgMzIE/UFeJJWeeY6mQlsNB4QLOIbgiF3a/fln
         iFwPpXzGwiOVV1B1F1QVeAq+sJxwPR7CSTpEAj4U=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20190422133334epcas5p213f3bd9d0a6e87699340c0194eb398c0~XzzMPww3C0991409914epcas5p2s;
        Mon, 22 Apr 2019 13:33:34 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        54.A6.04067.EA2CDBC5; Mon, 22 Apr 2019 22:33:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20190422133333epcas5p2aadec7a5e0134b70292317801e6473cb~XzzLeS1Ee0205302053epcas5p25;
        Mon, 22 Apr 2019 13:33:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190422133333epsmtrp1c14056d80db481a53ec843fa708cebba~XzzLdqcp_1100311003epsmtrp1_;
        Mon, 22 Apr 2019 13:33:33 +0000 (GMT)
X-AuditID: b6c32a4b-78bff70000000fe3-e8-5cbdc2ae806b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.33.03692.DA2CDBC5; Mon, 22 Apr 2019 22:33:33 +0900 (KST)
Received: from JOSHIK01 (unknown [107.111.93.135]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20190422133332epsmtip25b7698b956f516489d129fa863c670ca~XzzKK-S4G1746417464epsmtip2c;
        Mon, 22 Apr 2019 13:33:32 +0000 (GMT)
From:   "kanchan" <joshi.k@samsung.com>
To:     "'Andreas Dilger'" <adilger@dilger.ca>, "'Jan Kara'" <jack@suse.cz>
Cc:     "'open list'" <linux-kernel@vger.kernel.org>,
        "'linux-block'" <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>,
        "'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <prakash.v@samsung.com>
In-Reply-To: <9BD0C782-5967-4DCB-9D01-E5BCC73E653C@dilger.ca>
Subject: RE: [PATCH v4 4/7] block: introduce write-hint to stream-id
 conversion
Date:   Mon, 22 Apr 2019 19:03:23 +0530
Message-ID: <009b01d4f90f$fb2a3520$f17e9f60$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQK8/LoE/AuxJQqBdxKlIaVgudw56QGc9em7AVEQUzUCVhRCvgLBb+oYpDf4POA=
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsWy7bCmlu66Q3tjDD5dk7ZYdvIRk8Xs6c1M
        FntvaVvMnHeHzWLP3pMsFpd3zWGzmL/sKbvFlSmLmB04PFo2l3tsXlLv0bdlFaPHmQVH2D0+
        b5ILYI3isklJzcksSy3St0vgylh/9zhjwWaZilUvJzE2MF4T62Lk5JAQMJE42bOLpYuRi0NI
        YDejxN3lTewQzidGicNHVjBDON8YJRa8ecYI0zJ57TqoxF5GidXnPrFCOM8ZJTpOTmAGqWIT
        UJW496OXDcQWEXCXWP74MhNIEbPAR0aJeW0LgRIcHJwCthLft5iB1AgLBEo0H30D1ssC1Pu4
        ZQXYNl4BS4krd46zQtiCEidnPmEBsZkF5CW2v53DDHGRgsTuT0dZIXb5Sdx+f5ARokZc4uXR
        I2D/SAi8Z5OYfnEG1AsuEv1P3zBB2MISr45vYYewpSRe9rdB2cUSv+4cZYZo7mCUuN4wkwUi
        YS9xcc9fJpAHmAU0Jdbv0odYxifR+/sJWFhCgFeio00IolpR4t6kp6wQtrjEwxlLoGwPieP3
        jrJPYFScheS1WUhem4XkhVkIyxYwsqxilEwtKM5NTy02LTDOSy3XK07MLS7NS9dLzs/dxAhO
        R1reOxg3nfM5xCjAwajEw/th1Z4YIdbEsuLK3EOMEhzMSiK8v9KAQrwpiZVVqUX58UWlOanF
        hxilOViUxHnnys6NFhJITyxJzU5NLUgtgskycXBKNTBmqN9YFFNT0tDeFSz0NGrRlnU5i1eu
        uaMceftyu+LVJP7Wn1pxP64xfn+f8VRa+cqnXsUNDoXb/LZ7bz5pEtAQtql5W3WZCO9aL9XX
        ik0Ryn/5JiRM6ihcIRzcr/ibSfLD4o3tUUv3z5f86JH6i3dvqZvgJ8H2WOs/GZ8eLVBXlp6T
        aJ6k8VCJpTgj0VCLuag4EQAH2FquQwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCSvO7aQ3tjDGY+UrBYdvIRk8Xs6c1M
        FntvaVvMnHeHzWLP3pMsFpd3zWGzmL/sKbvFlSmLmB04PFo2l3tsXlLv0bdlFaPHmQVH2D0+
        b5ILYI3isklJzcksSy3St0vgylh/9zhjwWaZilUvJzE2MF4T62Lk5JAQMJGYvHYdcxcjF4eQ
        wG5GiQ9v7zBDJMQlmq/9YIewhSVW/nvODlH0lFFizuefjCAJNgFViXs/etlAbBEBT4lNU6aD
        FTELfGWUmH7vAAtExxImiS2HdwJVcXBwCthKfN9iBtIgLOAv0XDlNhOIzQI06HHLCrChvAKW
        ElfuHGeFsAUlTs58wgLSyiygJ9G2EayEWUBeYvvbOVCHKkjs/nSUFeIGP4nb7w9C1YhLvDx6
        hH0Co/AsJJNmIUyahWTSLCQdCxhZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBEeU
        luYOxstL4g8xCnAwKvHwfli1J0aINbGsuDL3EKMEB7OSCO+vNKAQb0piZVVqUX58UWlOavEh
        RmkOFiVx3qd5xyKFBNITS1KzU1MLUotgskwcnFINjBZrM/VvsVjuv/XU6+zbX7OXb5173M2v
        7NNnux+PrbN/Gr/447jc7KbxCSknRzsRyezWn2duFsQxJnFw3Tm76OINlqSF4W/5ig3VrDoL
        2Bh7v8iV18/TkdZgmMd8h3V15EXz39Uzyl5rTf59+5Sk2XL/215CGz29BKrOxQqblH6beeam
        a3LuUSWW4oxEQy3mouJEAKdo9gukAgAA
X-CMS-MailID: 20190422133333epcas5p2aadec7a5e0134b70292317801e6473cb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
        <CGME20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604@epcas1p4.samsung.com>
        <1555523406-2380-5-git-send-email-joshi.k@samsung.com>
        <20190418140603.GL28541@quack2.suse.cz>
        <9BD0C782-5967-4DCB-9D01-E5BCC73E653C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> Someone told me that stream ids are potentially persistent on the 
> storage so it isn't great to change the id for the same thing e.g. if 
> we add another user hint. So maybe we should allocate kernel hints 
> from top as Dave Chinner suggested? I.e., something like the following
mapping function:

This function is good. Thank you for sharing. 

-----Original Message-----
From: Andreas Dilger [mailto:adilger@dilger.ca] 
Sent: Friday, April 19, 2019 12:28 AM
To: Jan Kara <jack@suse.cz>
Cc: Kanchan Joshi <joshi.k@samsung.com>; open list
<linux-kernel@vger.kernel.org>; linux-block <linux-block@vger.kernel.org>;
linux-nvme@lists.infradead.org; linux-fsdevel
<linux-fsdevel@vger.kernel.org>; linux-ext4@vger.kernel.org;
prakash.v@samsung.com
Subject: Re: [PATCH v4 4/7] block: introduce write-hint to stream-id
conversion

On Apr 18, 2019, at 8:06 AM, Jan Kara <jack@suse.cz> wrote:
> 
> On Wed 17-04-19 23:20:03, Kanchan Joshi wrote:
>> This patch moves write-hint-to-stream-id conversion in block-layer.
>> Earlier this was done by driver (nvme). Current conversion is of the 
>> form "streamid = write-hint - 1", for both user and kernel streams.
>> Conversion takes stream limit (maintained in request queue) into 
>> account. Write-hints beyond the exposed limit turn to 0.
>> A new field 'streamid' has been added in request. While 'write-hint'
>> field continues to exist. It keeps original value passed from upper 
>> layer, and used during merging checks.
>> 
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> ---
>> block/blk-core.c       | 20 ++++++++++++++++++++
>> include/linux/blkdev.h |  1 +
>> 2 files changed, 21 insertions(+)
>> 
>> diff --git a/block/blk-core.c b/block/blk-core.c index 
>> a55389b..712e6b7 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -730,6 +730,25 @@ bool blk_attempt_plug_merge(struct request_queue *q,
struct bio *bio,
>> 	return false;
>> }
>> 
>> +enum rw_hint blk_write_hint_to_streamid(struct request *req,
>> +				        struct bio *bio)
>> +{
>> +	enum rw_hint streamid, nr_streams;
>> +	struct request_queue *q = req->q;
>> +	nr_streams = q->limits.nr_streams;
>> +
>> +	streamid = bio->bi_write_hint;
>> +	if (!nr_streams || streamid == WRITE_LIFE_NOT_SET ||
>> +	    streamid == WRITE_LIFE_NONE)
>> +		streamid = 0;
>> +	else {
>> +		--streamid;
>> +		if(streamid > nr_streams)
>> +			streamid = 0;
>> +	}
>> +	return streamid;
>> +}
>> +
> 
> Someone told me that stream ids are potentially persistent on the 
> storage so it isn't great to change the id for the same thing e.g. if 
> we add another user hint. So maybe we should allocate kernel hints 
> from top as Dave Chinner suggested? I.e., something like the following
mapping function:
> 
> 	if (streamid <= BLK_MAX_USER_HINTS) {
> 		streamid--;
> 		if (streamid > nr_streams)
> 			streamid = 0;
> 	} else {
> 		/* Kernel hints get allocated from top */
> 		streamid -= WRITE_LIFE_KERN_MIN;
> 		if (streamid > nr_streams - BLK_MAX_USER_HINTS)
> 			streamid = 0;
> 		else
> 			streamid = nr_streams - streamid - 1;
> 	}
> 
> what do you think?

Dave has expressed this sentiment several times, and I agree.  We don't want
the filesystem hint values/mapping to change over time, or it will conflict
with data that was written with the previous hints (e.g. if data was written
with a "short lifetime" hint suddenly changes to be grouped with a "long
lifetime" hint).  This is easily avoided with some simple changes now, but
harder to fix after this patch has landed.

Cheers, Andreas






