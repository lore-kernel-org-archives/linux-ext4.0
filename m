Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD404C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 04:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5318218A5
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 04:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YPK3FVkK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfCUECA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 00:02:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfCUECA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 00:02:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2L3wwWC117086;
        Thu, 21 Mar 2019 04:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=TPUZwX+fSwtI2PfLKH1GEoMzwQBO57p2B76r7SLE6+g=;
 b=YPK3FVkK1pL9DZg96dwpmrFr+cfEH++CXanaP8wydGNS38+9YH0hQFDv3fiR+5W8E8p2
 X28wHcW5s0vg/8jpZfVaYOuDEPOvFsNxqiVX4ZtCG2IzuzXWb7DQBBLKJ5CkCVDE2hAc
 n9Mq8fK2HAWL1gll+FjPYGsccXwUkskbD8SzU/+mzcDqo1iGkAcYCx+RGfzgpaaV3Mfa
 KZ4NVC2D25Mv0ccU2avkDUjq4zDGktWuoOCPgAOoCuuo6UV/+lCsOlwKGXhuaHCld55A
 1oKsjpr38p8t10DYXF+TCABdvls9tjgZg424FoCaSnAa7R9xDxMWA3BNzAnp6bgjpq6l 9Q== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2r8pnexhb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 04:01:56 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2L41uj8000550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 04:01:56 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2L41tDT020448;
        Thu, 21 Mar 2019 04:01:55 GMT
Received: from localhost (/10.159.247.212)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Mar 2019 21:01:55 -0700
Date:   Wed, 20 Mar 2019 21:01:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 6/9] e2scrub_all: add the -n option which shows what
 e2scrub_all would do
Message-ID: <20190321040157.GD1173@magnolia>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-6-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321020218.5154-6-tytso@mit.edu>
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

On Wed, Mar 20, 2019 at 10:02:15PM -0400, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  scrub/e2scrub_all.8.in | 9 +++++++--
>  scrub/e2scrub_all.in   | 8 +++++---
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/scrub/e2scrub_all.8.in b/scrub/e2scrub_all.8.in
> index ba3b8735e..2787a7108 100644
> --- a/scrub/e2scrub_all.8.in
> +++ b/scrub/e2scrub_all.8.in
> @@ -20,12 +20,17 @@ See the
>  manual page for more information about how the checking is performed.
>  .SH OPTIONS
>  .TP
> -\fB-A\fR
> -Scrub all ext[234] filesystems even if they are not mounted.
> +\fB-n\fR
> +Print what commands
> +.B e2scrub_all
> +would execute (but don't actually execute them).
>  .TP
>  \fB-r\fR
>  Remove e2scrub snapshots but do not check anything.
>  .TP
> +\fB-A\fR
> +Scrub all ext[234] filesystems even if they are not mounted.
> +.TP

Nitpicking, but this is also rearranging the order of manpage and help
text.  The changes themselves look ok, but I don't know how picky you
are these days about this sort of thing being separate changes. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  \fB-V\fR
>  Print version information and exit.
>  .SH SEE ALSO
> diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
> index d725a7f2e..8bc868aa0 100644
> --- a/scrub/e2scrub_all.in
> +++ b/scrub/e2scrub_all.in
> @@ -29,8 +29,9 @@ scrub_args=""
>  
>  print_help() {
>  	echo "Usage: $0 [OPTIONS]"
> -	echo " -A: Scrub all ext[234] filesystems even if not mounted."
> +	echo " -n: Show what commands e2scrub_all would execute."
>  	echo " -r: Remove e2scrub snapshots."
> +	echo " -A: Scrub all ext[234] filesystems even if not mounted."
>  	echo " -V: Print version information and exit."
>  }
>  
> @@ -60,10 +61,11 @@ exitcode() {
>  	exit "${ret}"
>  }
>  
> -while getopts "ArV" opt; do
> +while getopts "nrAV" opt; do
>  	case "${opt}" in
> -	"A") scrub_all=1;;
> +	"n") DBG="echo Would execute: " ;;
>  	"r") scrub_args="${scrub_args} -r";;
> +	"A") scrub_all=1;;
>  	"V") print_version; exitcode 0;;
>  	*) print_help; exitcode 2;;
>  	esac
> -- 
> 2.19.1
> 
