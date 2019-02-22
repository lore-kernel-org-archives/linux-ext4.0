Return-Path: <SRS0=rve6=Q5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2674C4360F
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 03:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 913B42080F
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Feb 2019 03:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qf44VDE6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfBVDBo (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 22:01:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52392 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfBVDBn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2019 22:01:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1M2x5P5019298;
        Fri, 22 Feb 2019 03:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=tpgPbF9d5E5368LK/jxJPB2cg1bLoVGsXat/sDNK1Qw=;
 b=Qf44VDE6u5HC/AJwd2mYlSzl2uc8efIuefESwCB8TliHHoZpplRn+GSmrqZGCKLWKVPl
 wJfX26khOhZIscPn0QXF5UWrVr+2/JnuyxDrSvFajKiwJIIlUHAqpOjvuG0Ov/fwqugM
 ZBNsb+LNyOy5wdfz0Fx6x9RXYsYqFI4DnEm4vCVpDUcgNC1neRHBG4rnQobNu8v7vw4w
 PdWHXpNoC5IiMjMItjpZl/uv3aRHVnFE8M5FrvwMl8TVy/kcgX1KhIhwB0BHW22wGejW
 c9R4I2hiyvh27Fz2jkmdosyfIKVwadfs+IrJI9PgVYL1USX0IUE7Sq0M6x3+30ClFkWy HA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2qpb5ruuv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 03:01:29 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1M31RGb025023
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Feb 2019 03:01:28 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1M31Rcq006808;
        Fri, 22 Feb 2019 03:01:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Feb 2019 19:01:26 -0800
To:     Jeff Mahoney <jeffm@suse.com>
Cc:     Keith Busch <keith.busch@intel.com>,
        Ric Wheeler <ricwheeler@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async discard?
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
        <20190217210948.GB14116@dastard>
        <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
        <20190220234723.GA5999@localhost.localdomain>
        <45c27fea-6d74-2adc-fe9d-e314ce4f3672@suse.com>
Date:   Thu, 21 Feb 2019 22:01:24 -0500
In-Reply-To: <45c27fea-6d74-2adc-fe9d-e314ce4f3672@suse.com> (Jeff Mahoney's
        message of "Thu, 21 Feb 2019 18:55:05 -0500")
Message-ID: <yq17edsil17.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9174 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220017
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


Jeff,

> We've always been told "don't worry about what the internal block size
> is, that only matters to the FTL."  That's obviously not true, but
> when devices only report a 512 byte granularity, we believe them and
> will issue discard for the smallest size that makes sense for the file
> system regardless of whether it makes sense (internally) for the SSD.
> That means 4k for pretty much anything except btrfs metadata nodes,
> which are 16k.

The devices are free to report a bigger discard granularity. We already
support and honor that (for SCSI, anyway). It's completely orthogonal to
reported the logical block size, although it obviously needs to be a
multiple.

The real problem is that vendors have zero interest in optimizing for
discard. They are so confident in their FTL and overprovisioning that
they don't view it as an important feature. At all.

Consequently, many of the modern devices that claim to support discard
to make us software folks happy (or to satisfy a purchase order
requirements) complete the commands without doing anything at all.
We're simply wasting queue slots.

Personally, I think discard is dead on anything but the cheapest
devices.  And on those it is probably going to be
performance-prohibitive to use it in any other way than a weekly fstrim.

-- 
Martin K. Petersen	Oracle Linux Engineering
