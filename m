Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B62C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 03:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EF3A218C3
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 03:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k/Z6MZUC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfCUD7g (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 23:59:36 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58240 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfCUD7f (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 23:59:35 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2L3xFaQ117529;
        Thu, 21 Mar 2019 03:59:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Khc+rx1kZs6qS8pkYe+iS/1PJP3Rn0Ju8prAT2eoAeE=;
 b=k/Z6MZUChphpDtkv+2SA1auvIQzuAwUqkKZ+UTDSj43dS2JuXXHM8QV18Fs1qNMLN0VN
 MLTr/BeQs7AG9sAVwsHCxtaQz4ikYs7fiwPFLlEn7lctncDgaTuIAkuCpUkfdrk5r/+C
 cdlP/Fl3IrzVOFj8/mkUBjSTBN7q9Z/Rahz1AIW0KZLwwzSNoH3o+GZL5OB95rKuUQ9O
 /ByNVGJDxjZeMAdsEkAowuMutnPksdW6nzmQIPrJnjIukt98dkRwMlTOCRjtBdaNR3/y
 BPRRTbKbhguuPEmgUXMjcVOoB3G6qJYmTSAU4QjjJPWkPk4YNtrL4W24iEtMjQj9ree5 +Q== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2r8pnexgtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 03:59:32 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2L3xP9q023093
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 03:59:26 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2L3xPg3029598;
        Thu, 21 Mar 2019 03:59:25 GMT
Received: from localhost (/10.159.247.212)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Mar 2019 20:59:25 -0700
Date:   Wed, 20 Mar 2019 20:59:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 5/9] e2fscrub: add the -n option which shows what
 commands e2scrub would execute
Message-ID: <20190321035927.GC1173@magnolia>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-5-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321020218.5154-5-tytso@mit.edu>
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

On Wed, Mar 20, 2019 at 10:02:14PM -0400, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  scrub/e2scrub.8.in | 5 +++++
>  scrub/e2scrub.in   | 6 ++++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/scrub/e2scrub.8.in b/scrub/e2scrub.8.in
> index ff03523e3..7342876a3 100644
> --- a/scrub/e2scrub.8.in
> +++ b/scrub/e2scrub.8.in
> @@ -38,6 +38,11 @@ If the filesystem is not repaired,
>  will be run before the next mount.
>  .SH OPTIONS
>  .TP
> +\fB-n\fR
> +Print what commands
> +.B e2scrub
> +would execute (but don't actually execute them).
> +.TP
>  \fB-r\fR
>  Remove the e2scrub snapshot and exit without checking anything.
>  .TP
> diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
> index 51a909373..301574968 100644
> --- a/scrub/e2scrub.in
> +++ b/scrub/e2scrub.in
> @@ -37,6 +37,7 @@ print_help() {
>  	echo "Usage: $0 [OPTIONS] mountpoint | device"
>  	echo
>  	echo "mountpoint must be on a LVM-managed block device"
> +	echo "-n: Show what commands e2scrub would execute."
>  	echo "-r: Remove e2scrub snapshot and exit, do not check anything."
>  	echo "-t: Run fstrim if successful."
>  	echo "-V: Print version information and exit."
> @@ -68,8 +69,9 @@ exitcode() {
>  	exit "${ret}"
>  }
>  
> -while getopts "rtV" opt; do
> -	case "${opt}" in
> +while getopts "nrtV" opt; do
> +    case "${opt}" in
> +	"n") DBG="echo Would execute: " ;;
>  	"r") reap=1;;
>  	"t") fstrim=1;;
>  	"V") print_version; exitcode 0;;
> -- 
> 2.19.1
> 
