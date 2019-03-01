Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1A0C43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 15:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34E0D2084D
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 15:39:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CcVUtXt6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388428AbfCAPjt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 10:39:49 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33190 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfCAPjs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 10:39:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21Fcmq4147520;
        Fri, 1 Mar 2019 15:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=1E5raqqljVB2vDmZxp/484G595ZxEGWLIg2go8o6zPw=;
 b=CcVUtXt6B6lgyoFC/CR7nVyjxZXvE5KCSJ4FXd6em+9FZfHtkyO3tx4lLgbrOvUPnOAO
 /hxGKujJRds0oGKgsS5RXvBY0mv+pUow0nU2Ek3JVjYqf4h2OhHRoRtPHNMVaOtWOOTr
 jpoUoELbQzWtbAgttj01/raGWPVMzHgoEYbetINKhIqVZVRqt/jGgiprTf2niIaxdZRZ
 rOPBX2OjaPj2VeqdnK48wEhM899yrBEjt43RvKBXPMZkK+zZgeVXM7HA0gJvAJLqxzKg
 jYjq4i5FLnkjpV1jNndBoYK/QDAM1KQnpSHfR6ly303j8RuXYlo1lkx+06Ot2FGdM2lY 6g== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qtuper7xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Mar 2019 15:39:35 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x21FdYEj022242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Mar 2019 15:39:34 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21FdWKX013310;
        Fri, 1 Mar 2019 15:39:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Mar 2019 07:39:32 -0800
Date:   Fri, 1 Mar 2019 07:39:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: Re: [PATCH 8/8] xfs: support project in xfs_getattr()
Message-ID: <20190301153931.GM21626@magnolia>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
 <1551449141-7884-9-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551449141-7884-9-git-send-email-wshilong1991@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9181 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903010110
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 01, 2019 at 11:05:41PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> From: Wang Shilong <wshilong@ddn.com>
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/xfs/xfs_iops.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index c10466fe6ed4..a2f8c0f048cf 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -501,6 +501,7 @@ xfs_vn_getattr(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	stat->projid = xfs_projid_to_kprojid(xfs_get_projid(ip));

I think we're supposed to set STATX_PROJID in the result mask if the
caller asks for it, right?

if (request_mask & STATX_PROJID) {
	stat->projid = xfs_projid_to_kprojid(xfs_get_projid(ip));
	stat->result_mask |= STATX_PROJID;
}

>  	stat->size = XFS_ISIZE(ip);
>  	stat->dev = inode->i_sb->s_dev;
>  	stat->mode = inode->i_mode;
> @@ -528,6 +529,8 @@ xfs_vn_getattr(
>  		stat->attributes |= STATX_ATTR_APPEND;
>  	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
>  		stat->attributes |= STATX_ATTR_NODUMP;
> +	if (ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
> +		stat->attributes |= STATX_ATTR_PROJINHERIT;

I think we also have to set STATX_ATTR_PROJINHERIT in the
attributes_mask, but ... heh, XFS doesn't do that at all. :(

--D

>  	switch (inode->i_mode & S_IFMT) {
>  	case S_IFBLK:
> -- 
> 2.19.1
> 
