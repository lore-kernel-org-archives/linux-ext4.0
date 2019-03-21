Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC9EC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 04:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86B33218A5
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 04:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HTaS2frD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbfCUECp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 00:02:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55160 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfCUECo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 00:02:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2L3wxFc086391;
        Thu, 21 Mar 2019 04:02:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=b1DO4fF3YK/8r6FXtonukrYZfkN2VnXHaVYvqHXWjdo=;
 b=HTaS2frDWqyZLNqVhJwRENaEkNG1Tceky7QDyW3mh/cp1XiRTvfRrNS/s0XMSiBSLYTq
 jqIbsfJhcdoxjHtZltdVGT19Pp7BbQRcdb1aPqZau2ZNz/NOkvfZgMZAvIolr5F+A6tA
 6vBP4zUjWrE+CX8jsKm06tEMWDI6B/wT1zBqQXR4J3XXLE7HzMbIZTYkW2JHLkftJaal
 VfF9fv1iuxYjgdUgkU/SnMkppTtVsW8U3vFkS7yzRwadJ2hrZdN34D3LiQV7sp/xp5+t
 z2Jh8Y61/IIbQoCYuOPIN2r7823sZrmN3pRqkYQkU5ZOcQYDw7JJJIEdiGrxtRtmXYud gQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2r8ssrp5v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 04:02:41 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2L42flH001541
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Mar 2019 04:02:41 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2L42fxp020893;
        Thu, 21 Mar 2019 04:02:41 GMT
Received: from localhost (/10.159.247.212)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Mar 2019 21:02:40 -0700
Date:   Wed, 20 Mar 2019 21:02:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 7/9] e2scrub_all: make sure there's enough free space for
 a snapshot
Message-ID: <20190321040242.GE1173@magnolia>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-7-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321020218.5154-7-tytso@mit.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9201 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=29 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903210026
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 10:02:16PM -0400, Theodore Ts'o wrote:
> If there isn't, skip the volume so we don't spam the system
> administrator with error messages.  It's quite commkon that there is

'common'

> is zero free space in the volume group.
> 
> Addresses-Debian-Bug: #924301
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  scrub/e2scrub_all.in | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
> index 8bc868aa0..4cb90a0de 100644
> --- a/scrub/e2scrub_all.in
> +++ b/scrub/e2scrub_all.in
> @@ -21,6 +21,7 @@
>  PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
>  
>  scrub_all=0
> +snap_size_mb=256
>  conffile="@root_sysconfdir@/e2scrub.conf"
>  
>  test -f "${conffile}" && . "${conffile}"
> @@ -108,6 +109,9 @@ ls_scrub_targets() {
>  		eval "${lvm_vars}"
>  		echo "${LVM2_LV_ROLE}" | grep -q "snapshot" && continue
>  
> +		free_space="$(vgs -o vg_free --units m --noheadings --no-suffix "${LVM2_VG_NAME}" 2> /dev/null | sed -e 's/\..*//')"
> +		test "${snap_size_mb}" -gt "${free_space}" && continue
> +
>  		if [ -n "${MOUNTPOINT}" ]; then
>  			echo "${MOUNTPOINT}"
>  		else
> -- 
> 2.19.1
> 
