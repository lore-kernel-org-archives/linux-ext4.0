Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AB8C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 03:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4267218A5
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 03:57:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TlEm1emK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfCUD5d (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 23:57:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56408 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbfCUD5d (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 23:57:33 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2L3sCBv113529;
        Thu, 21 Mar 2019 03:57:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=5wiCyTnJaVfHC5Vu01yCxpg0uuw8s/qTxdStt6pWwm4=;
 b=TlEm1emK4nbPPl4FegiPrKFeNTzIx1PdNigTQ46rChhEe9S3PCyUD9Q/Kg2wxjyCVN0n
 +2bMSVTrydQ4GToRNjWcfFIeAWX3qQG1TH3gp2aaIVFMoNzadXCtPtyQQiOZRTvxICZ/
 8xtUalwcQho459cK2c9X2wJZPD1oZ/sG7zFTT0ZiC3VCaKUMBEDVGHrtEtnT3YJKMxh3
 grrAl7ZIJtn/+uIx5/NtZdr/eICOUl4bPvuBdcIMZXXqLbXflizz8e4DeIrHleCb6n8j
 UK3uiLCijPRTm2umGdQmhdQZCSEJA2VnngommaOBjhf1wftODNuss2/8TfKRg+eEvxDk rA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2r8pnexgj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 03:57:28 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2L3vSSt021443
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 03:57:28 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2L3vSOv028672;
        Thu, 21 Mar 2019 03:57:28 GMT
Received: from localhost (/10.159.247.212)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Mar 2019 20:57:27 -0700
Date:   Wed, 20 Mar 2019 20:57:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/9] debian: drop lvm2 from the recommends line
Message-ID: <20190321035729.GB1173@magnolia>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-2-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321020218.5154-2-tytso@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9201 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903210025
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 10:02:11PM -0400, Theodore Ts'o wrote:
> If the user doesn't intend to use lvm2, and it's not installed,
> installing e2fsprogs shouldn't drag it (and all of its dependencies)
> into the system.
> 
> Addresses-Debian-Bug: 924275
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  debian/control | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debian/control b/debian/control
> index 1bb8adb15..e454687f9 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -191,7 +191,7 @@ XB-Important: yes
>  Pre-Depends: ${shlibs:Depends}, ${misc:Depends}, libblkid1, libuuid1
>  Multi-Arch: foreign
>  Suggests: gpart, parted, fuse2fs, e2fsck-static
> -Recommends: e2fsprogs-l10n, lvm2
> +Recommends: e2fsprogs-l10n
>  Architecture: any
>  Description: ext2/ext3/ext4 file system utilities
>   The ext2, ext3 and ext4 file systems are successors of the original ext
> -- 
> 2.19.1
> 
