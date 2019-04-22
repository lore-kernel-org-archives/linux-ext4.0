Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEF5C10F11
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 13:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F84E20685
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 13:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tbvMAjDk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfDVNhR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 09:37:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61252 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727378AbfDVNhQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Apr 2019 09:37:16 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20190422133713epoutp04b4b3720e2901c832c7baef5c61d98a6f~Xz2YjV0lO0439204392epoutp040
        for <linux-ext4@vger.kernel.org>; Mon, 22 Apr 2019 13:37:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20190422133713epoutp04b4b3720e2901c832c7baef5c61d98a6f~Xz2YjV0lO0439204392epoutp040
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555940233;
        bh=iQqPP7aCWriecL0kX4i4+1/X7zYRmvCB7M1O0zcQtrc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=tbvMAjDkAacoOLtW4B2uSz7FzIjC7kiYMqxL0tUyB0OGSnDktSwEX6ggiK5y6jnqc
         BihxqDE1O1rsM+Ba3q/3f+MQYu9oeZriGXahAubhDBQp+TorF251kjOElGC15KwMh1
         F+k9njpQPqtXD3IwdeiVCCP5om+x+epWWZyB/8zM=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20190422133713epcas5p3c1a2f7936bfa9fab70a08604a5c2d093~Xz2YLnDBT1537215372epcas5p3G;
        Mon, 22 Apr 2019 13:37:13 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.F6.04067.983CDBC5; Mon, 22 Apr 2019 22:37:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20190422133712epcas5p2c70652336c2410d17bf3133c2cfd201a~Xz2Xb3EFE1998619986epcas5p2f;
        Mon, 22 Apr 2019 13:37:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190422133712epsmtrp1a6dfab65aaac932f42611bdaf071483c~Xz2XbPqPk1100311003epsmtrp1Z;
        Mon, 22 Apr 2019 13:37:12 +0000 (GMT)
X-AuditID: b6c32a4b-7a3ff70000000fe3-53-5cbdc3890061
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.43.03692.883CDBC5; Mon, 22 Apr 2019 22:37:12 +0900 (KST)
Received: from JOSHIK01 (unknown [107.111.93.135]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20190422133711epsmtip1cb27adc831d3e21db31cfcf22b8135a5~Xz2WTNuq72063720637epsmtip1H;
        Mon, 22 Apr 2019 13:37:11 +0000 (GMT)
From:   "kanchan" <joshi.k@samsung.com>
To:     "'Jens Axboe'" <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Cc:     <prakash.v@samsung.com>
In-Reply-To: <6850a3ad-805f-4232-1bc7-f3249e1fba96@kernel.dk>
Subject: RE: [PATCH v4 4/7] block: introduce write-hint to stream-id
 conversion
Date:   Mon, 22 Apr 2019 19:06:49 +0530
Message-ID: <009c01d4f910$7db6ec40$7924c4c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQK8/LoE/AuxJQqBdxKlIaVgudw56QGc9em7AVEQUzUCUdAPjaROKAng
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsWy7bCmpm7n4b0xBueWSVusvtvPZrH3lrbF
        zHl32Cz27D3JYnF51xw2i/nLnrJbXJmyiNmB3ePy2VKPzUvqPfq2rGL0+LxJLoAlissmJTUn
        syy1SN8ugSvjytyfLAW3uSs+XP7J1MD4gLOLkZNDQsBE4sHfKexdjFwcQgK7GSUW7F3ICOF8
        YpRou3SQFcL5xijR/uYsM0zLtMnbWCASexklFn+YzQzhPGeUaPw1hRWkik1AVeLej142kISI
        wAlGiRXtN9hBEswC0hITb+1lBLE5BWwl/p78DmYLCwRKNB99A7aCBah50vlOFhCbV8BSYsWe
        d4wQtqDEyZlPWCDmaEssW/ga6iQFid2fjoItFhFwk5j6+z0bRI24xMujR8C+kxC4zSbR9f4J
        UBEHkOMicaC1DqJXWOLV8S3sELaUxMv+Nii7WOLXnaPMEL0djBLXG2ayQCTsJS7u+csEModZ
        QFNi/S59iF18Er2/nzBBjOeV6GgTgqhWlLg36SkrhC0u8XDGEijbQ+L4vaPsExgVZyH5bBaS
        z2Yh+WAWwrIFjCyrGCVTC4pz01OLTQuM81LL9YoTc4tL89L1kvNzNzGCU4+W9w7GTed8DjEK
        cDAq8fB+WLUnRog1say4MvcQowQHs5II7680oBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeubJz
        o4UE0hNLUrNTUwtSi2CyTBycUg2MReLxgtr2Rnu9l1hvOqrlOIH5fCjztJttdW2q3ve3RnK3
        qk/8+vy83jzPH1IJ+v3/4zkZ9+3ZLH5c81h/w4IbrzRsl/RqJm+bpOOtaun9/fQuiUt72rbu
        mWhfc6wzamX0gh8zrZxesBYWSXUcabFI1OMoUHoxI3jF/DDviudilbUuzHH/5nErsRRnJBpq
        MRcVJwIArqIj3jkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LZdlhJTrfj8N4Yg2W9yhar7/azWey9pW0x
        c94dNos9e0+yWFzeNYfNYv6yp+wWV6YsYnZg97h8ttRj85J6j74tqxg9Pm+SC2CJ4rJJSc3J
        LEst0rdL4MrYfq2JsWA/d8XS9Q4NjEc4uxg5OSQETCSmTd7G0sXIxSEksJtRYsGD7SwQCXGJ
        5ms/2CFsYYmV/56zQxQ9ZZQ4+wciwSagKnHvRy8bSEJE4ByjxJ35f8C6mQWkJSbe2ssIYgsJ
        /GGU+NGQDGJzCthK/D35HSwuLOAv0XDlNhOIzQI0aNL5TrBeXgFLiRV73jFC2IISJ2c+gZqp
        LdH7sJURxl628DUzxHUKErs/HWUFsUUE3CSm/n7PBlEjLvHy6BH2CYzCs5CMmoVk1Cwko2Yh
        aVnAyLKKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4frQ0dzBeXhJ/iFGAg1GJh/fD
        qj0xQqyJZcWVuYcYJTiYlUR4f6UBhXhTEiurUovy44tKc1KLDzFKc7AoifM+zTsWKSSQnliS
        mp2aWpBaBJNl4uCUamD05w5szzk+aceLXXOn8d8+seGw26t2zxoFxaNytxwjll7JXdR5UMh6
        ka/aTMcER0Hh/a8msv3cvMfn1LvUyf8utv8u9Y3vzg+qKp0TFcSoqNkXsPh0yw/Ja+VK9jtD
        q6b++nWmfUaj60+GaFHRiDdxl68pP2gss867EBG653zgm76v7Ed6r9QqsRRnJBpqMRcVJwIA
        FJj5OJsCAAA=
X-CMS-MailID: 20190422133712epcas5p2c70652336c2410d17bf3133c2cfd201a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604
References: <1555523406-2380-1-git-send-email-joshi.k@samsung.com>
        <CGME20190417175358epcas1p41a0a4e349dfe0a70bdcc244161c71604@epcas1p4.samsung.com>
        <1555523406-2380-5-git-send-email-joshi.k@samsung.com>
        <6850a3ad-805f-4232-1bc7-f3249e1fba96@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

> Why not just use the bio write hint? We already disallow merging of dissi=
milar write hints, so req->bio->bi_write_hint is known to be identical with=
 the rest of the bio's in that chain.

Yes, that is better. Thanks for suggesting it.

-----Original Message-----
From: Jens Axboe =5Bmailto:axboe=40kernel.dk=5D=20
Sent: Wednesday, April 17, 2019 11:28 PM
To: Kanchan Joshi <joshi.k=40samsung.com>; linux-kernel=40vger.kernel.org; =
linux-block=40vger.kernel.org; linux-nvme=40lists.infradead.org; linux-fsde=
vel=40vger.kernel.org; linux-ext4=40vger.kernel.org
Cc: prakash.v=40samsung.com
Subject: Re: =5BPATCH v4 4/7=5D block: introduce write-hint to stream-id co=
nversion

On 4/17/19 11:50 AM, Kanchan Joshi wrote:
> This patch moves write-hint-to-stream-id conversion in block-layer.
> Earlier this was done by driver (nvme). Current conversion is of the=20
> form =22streamid =3D write-hint - 1=22, for both user and kernel streams.
> Conversion takes stream limit (maintained in request queue) into=20
> account. Write-hints beyond the exposed limit turn to 0.
> A new field 'streamid' has been added in request. While 'write-hint'
> field continues to exist. It keeps original value passed from upper=20
> layer, and used during merging checks.

Why not just use the bio write hint? We already disallow merging of dissimi=
lar write hints, so req->bio->bi_write_hint is known to be identical with t=
he rest of the bio's in that chain.

--
Jens Axboe


