Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E9CC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 04:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF001218A5
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 04:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TlNVAQO9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfCUEEV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 00:04:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34102 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfCUEEV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 00:04:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2L3wuhO117044;
        Thu, 21 Mar 2019 04:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=/JNQshqejWglzfysbxhV65ZiLW8yFHdxOAtmbu/4axc=;
 b=TlNVAQO92DjoSYKbeszPKX+657K7ZdXZL2IgUqrFL7qTVjLhpMbfa8+uNCWCljvrwK33
 FiZQEaV1N0UszgYlcJc1tEMtKLerfN/xnGzUCYQOxrKH6X5Jqp8TaKcUNVXrOUNpVbG3
 2g+lqU6Ql1omYy4lK97gqVwYvb71dWEN7sT3rq8rhrVMBh/gIAPXP6xfLMkuA9x1vezl
 uYk/QQFVqErWSFPVhvavlVV7A3Q70GItjNYiMiQWRqDuUAXZYXBu7pN70bOnpA+Yso3Z
 dAZ8P35EGTkbPg15WVUbckKQE+2BI3u5PKjGrmBn36Rio7b0NJsSHkyq8neJi7VkR1x+ Ww== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2r8pnexhhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 04:04:18 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2L44Huo005379
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 04:04:17 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2L44Hbu017532;
        Thu, 21 Mar 2019 04:04:17 GMT
Received: from localhost (/10.159.247.212)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Mar 2019 21:04:17 -0700
Date:   Wed, 20 Mar 2019 21:04:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 9/9] e2scrub,e2scrub_all: print a (more understandable)
 error if not run as root
Message-ID: <20190321040418.GF1173@magnolia>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-9-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321020218.5154-9-tytso@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9201 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903210026
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 10:02:18PM -0400, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Oops, yeah, I forgot this. :/

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  scrub/e2scrub.in     | 5 +++++
>  scrub/e2scrub_all.in | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
> index 301574968..666d6485a 100644
> --- a/scrub/e2scrub.in
> +++ b/scrub/e2scrub.in
> @@ -25,6 +25,11 @@
>  
>  PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
>  
> +if (( $EUID != 0 )); then
> +    echo "e2scrub must be run as root"
> +    exit 1
> +fi
> +
>  snap_size_mb=256
>  fstrim=0
>  reap=0
> diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
> index cad232987..a02ffe226 100644
> --- a/scrub/e2scrub_all.in
> +++ b/scrub/e2scrub_all.in
> @@ -20,6 +20,11 @@
>  
>  PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
>  
> +if (( $EUID != 0 )); then
> +    echo "e2scrub_all must be run as root"
> +    exit 1
> +fi
> +
>  scrub_all=0
>  snap_size_mb=256
>  reap=0
> -- 
> 2.19.1
> 
