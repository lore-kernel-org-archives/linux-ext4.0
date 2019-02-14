Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE11C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 15:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F15BC21927
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 15:54:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qTjoXASK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbfBNPyT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 10:54:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53018 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbfBNPyT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 10:54:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1EFXtWY034102;
        Thu, 14 Feb 2019 15:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=5AyraXUZnCsatxmhVy3tURT5eYycy9gewdE/Vl2A2Hw=;
 b=qTjoXASKJSe+6+iDvOOajtufXNVrwdrZIco7Vw/gMobmk/+N1ItaXEAzXWFTvaR8T03a
 ClO1RrpoLzkhi7sKhd8Ay0E/xUpntCI24QtgkCjvEC0JNU5T/6Bxf57357fIV9tVWBfj
 LTTvfb4FAv6IKgYJl9Kr7G3dIxJMgoVdUvXqMJIt+FYHXWWh6ZJehkTseA38WOvEOlwg
 /oJy3Qwoq6dQma3SpQdPtWgrYt2w95RnQQZjGJmye1moX9HT21JCu/HOe1HNLfbojEbE
 fRP6jc+55ilJKLbj7uszwbaz/5Ci4Wu/Y4MktKOpayxnoBITQR/ks1kVH0S0a3Fx5ur0 oQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qhrekrth9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Feb 2019 15:54:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1EFsBWV011864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Feb 2019 15:54:11 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1EFsAKb030797;
        Thu, 14 Feb 2019 15:54:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Feb 2019 15:54:10 +0000
Date:   Thu, 14 Feb 2019 07:54:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Wang Shilong <wshilong@ddn.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-fs@vger.kernel.org" <linux-fs@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUkY=?= =?utf-8?Q?C?= PATCH] ext4: add link
 file support for {GET,SET}XATTR ioctl
Message-ID: <20190214155410.GF32253@magnolia>
References: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
 <20190131034106.GJ4205@dastard>
 <20190131174059.GA10211@magnolia>
 <20190131204301.GK4205@dastard>
 <BYAPR19MB2758BDB15262B0333504B70ED4670@BYAPR19MB2758.namprd19.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR19MB2758BDB15262B0333504B70ED4670@BYAPR19MB2758.namprd19.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9167 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902140109
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 14, 2019 at 08:14:56AM +0000, Wang Shilong wrote:
> Hi Dave, Darrick,
> 
>       Thanks for good suggestions!
> As my understanding, we could modify 
> 
> do_fchownat() to change project ID instead of
> group id if AT_FCHOWN_PROJID(new flags) passed in.
> 
> Besides that we also need a new flag AT_FCHOWN_PROJ_INHERIT.
> to set/clear inherit attributes? 

That sounds reasonable enough to consider as a formal proposal.

> And for Project Get, we might need extend 'struct attr {'
> to include project id.

Let's add a new STATX_PROJID so that statx() callers can fetch it?

Also manpage updates and fstests cases...

--D

> What do you think?
> 
> Thanks,
> Shilong
