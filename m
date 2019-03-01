Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3FFC4360F
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 15:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DEA320851
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 15:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="2SDS1JEp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfCAPtm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 10:49:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57470 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbfCAPtm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 10:49:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21FnInB158589;
        Fri, 1 Mar 2019 15:49:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=TWzLwlBw80sal8SZOfzooPlHiApaVV+JB/ucbkH64G8=;
 b=2SDS1JEpUAO1eMzM8EIYQT+Yrh2Xamy5wqA7fhDFZr6B6ady71832GgGPPzr3Jv/yeq+
 P6QepHD1FWA/isoWNJPfiocvjDzLHQhzKdcfkeuA3H+brRR2o7vF8lIkVyWwEPnWBXjh
 aT/53gp6xIFGZymT+mjN4IanrvMqem0Zmgu/JhPyp669vNtfZ5cLsI70AV3pgFqx7DEZ
 3ItAk8Lz7Ke4J7TQFHR6atgyNl2ShqQG6CFrlYj7/nuEhVcD0a6lvyNTpm0OQpK683jK
 DoCt+LMx1VV6XGw+d1B59kUkz9lJUxIbL1Vg/y1Kz+mQGxyXMOSn72OcvDfyxvrtKxKu bg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2qtxts807d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 Mar 2019 15:49:29 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x21FnSMI022415
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Mar 2019 15:49:28 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21FnRMI001164;
        Fri, 1 Mar 2019 15:49:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 Mar 2019 07:49:27 -0800
Date:   Fri, 1 Mar 2019 07:49:26 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Wang Shilong <wangshilong1991@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>
Subject: Re: [PATCH 4/8] xfs: support project ID in xfs_setattr()
Message-ID: <20190301154926.GN21626@magnolia>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
 <1551449141-7884-5-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551449141-7884-5-git-send-email-wshilong1991@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9181 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903010111
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 01, 2019 at 11:05:37PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> From: Wang Shilong <wshilong@ddn.com>

Needs a commit message here ^^^^

e.g. "Wire up XFS to the new ATTR_PROJID setattr functionality"

> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/xfs/xfs_iops.c  | 51 +++++++++++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_linux.h | 10 +++++++++
>  2 files changed, 51 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index f48ffd7a8d3e..c10466fe6ed4 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -589,7 +589,8 @@ xfs_vn_change_ok(
>  	struct dentry	*dentry,
>  	struct iattr	*iattr)
>  {
> -	struct xfs_mount	*mp = XFS_I(d_inode(dentry))->i_mount;
> +	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
> +	struct xfs_mount	*mp = ip->i_mount;
>  
>  	if (mp->m_flags & XFS_MOUNT_RDONLY)
>  		return -EROFS;
> @@ -597,6 +598,13 @@ xfs_vn_change_ok(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	 if ((iattr->ia_valid & ATTR_PROJID) &&
> +	     current_user_ns() != &init_user_ns) {
> +		if (!projid_eq(xfs_projid_to_kprojid(xfs_get_projid(ip)),
> +			       iattr->ia_projid))
> +			return -EPERM;
> +	}
> +
>  	return setattr_prepare(dentry, iattr);
>  }
>  
> @@ -619,8 +627,10 @@ xfs_setattr_nonsize(
>  	int			error;
>  	kuid_t			uid = GLOBAL_ROOT_UID, iuid = GLOBAL_ROOT_UID;
>  	kgid_t			gid = GLOBAL_ROOT_GID, igid = GLOBAL_ROOT_GID;
> -	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
> +	kprojid_t		projid, iprojid;
> +	struct xfs_dquot	*udqp = NULL, *gdqp = NULL, *pdqp = NULL;
>  	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
> +	struct xfs_dquot	*olddquot3 = NULL;
>  
>  	ASSERT((mask & ATTR_SIZE) == 0);
>  
> @@ -632,7 +642,7 @@ xfs_setattr_nonsize(
>  	 * If the IDs do change before we take the ilock, we're covered
>  	 * because the i_*dquot fields will get updated anyway.
>  	 */
> -	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID))) {
> +	if (XFS_IS_QUOTA_ON(mp) && (mask & (ATTR_UID|ATTR_GID|ATTR_PROJID))) {
>  		uint	qflags = 0;
>  
>  		if ((mask & ATTR_UID) && XFS_IS_UQUOTA_ON(mp)) {
> @@ -647,18 +657,25 @@ xfs_setattr_nonsize(
>  		}  else {
>  			gid = inode->i_gid;
>  		}
> +		if ((mask & ATTR_PROJID) && XFS_IS_PQUOTA_ON(mp)) {
> +			projid = iattr->ia_projid;
> +			qflags |= XFS_QMOPT_PQUOTA;
> +		}  else {
> +			projid = xfs_projid_to_kprojid(xfs_get_projid(ip));

Hmm.  Prior to this change, xfs never actually touched the kernel's kprojid
infrastructure, which is to say that I don't think we actually map the
xfs project ids into a "kprojid user-namespace pair".  Does that cause a
user-visible change in how project ids work?  Don't we need to change
getxattr and setxattr to perform the translation too?  Or is everything
just fine the way it is in xfs without a new layer of mapping?

And if we /are/ deciding to wrap xfs project ids in kprojid now, I think
that ought to be a separate patch.

> +		}
>  
>  		/*
> -		 * We take a reference when we initialize udqp and gdqp,
> +		 * We take a reference when we initialize udqp,gdqp and pdqp,

                               space after the comma, please ^^^

--D

>  		 * so it is important that we never blindly double trip on
>  		 * the same variable. See xfs_create() for an example.
>  		 */
>  		ASSERT(udqp == NULL);
>  		ASSERT(gdqp == NULL);
> +		ASSERT(pdqp == NULL);
>  		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
>  					   xfs_kgid_to_gid(gid),
> -					   xfs_get_projid(ip),
> -					   qflags, &udqp, &gdqp, NULL);
> +					   xfs_kprojid_to_projid(projid),
> +					   qflags, &udqp, &gdqp, &pdqp);
>  		if (error)
>  			return error;
>  	}
> @@ -673,7 +690,7 @@ xfs_setattr_nonsize(
>  	/*
>  	 * Change file ownership.  Must be the owner or privileged.
>  	 */
> -	if (mask & (ATTR_UID|ATTR_GID)) {
> +	if (mask & (ATTR_UID|ATTR_GID|ATTR_PROJID)) {
>  		/*
>  		 * These IDs could have changed since we last looked at them.
>  		 * But, we're assured that if the ownership did change
> @@ -682,8 +699,10 @@ xfs_setattr_nonsize(
>  		 */
>  		iuid = inode->i_uid;
>  		igid = inode->i_gid;
> +		iprojid = xfs_projid_to_kprojid(xfs_get_projid(ip));
>  		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
>  		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
> +		projid = (mask & ATTR_PROJID) ? iattr->ia_projid : iprojid;
>  
>  		/*
>  		 * Do a quota reservation only if uid/gid is actually
> @@ -691,10 +710,11 @@ xfs_setattr_nonsize(
>  		 */
>  		if (XFS_IS_QUOTA_RUNNING(mp) &&
>  		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
> -		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
> +		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)) ||
> +		     (XFS_IS_PQUOTA_ON(mp) && !projid_eq(iprojid, projid)))) {
>  			ASSERT(tp);
>  			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> -						NULL, capable(CAP_FOWNER) ?
> +						pdqp, capable(CAP_FOWNER) ?
>  						XFS_QMOPT_FORCE_RES : 0);
>  			if (error)	/* out of quota */
>  				goto out_cancel;
> @@ -704,7 +724,7 @@ xfs_setattr_nonsize(
>  	/*
>  	 * Change file ownership.  Must be the owner or privileged.
>  	 */
> -	if (mask & (ATTR_UID|ATTR_GID)) {
> +	if (mask & (ATTR_UID|ATTR_GID|ATTR_PROJID)) {
>  		/*
>  		 * CAP_FSETID overrides the following restrictions:
>  		 *
> @@ -741,6 +761,15 @@ xfs_setattr_nonsize(
>  			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
>  			inode->i_gid = gid;
>  		}
> +		if (!projid_eq(iprojid, projid)) {
> +			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
> +				ASSERT(mask & ATTR_PROJID);
> +				ASSERT(pdqp);
> +				olddquot3 = xfs_qm_vop_chown(tp, ip,
> +							&ip->i_pdquot, pdqp);
> +			}
> +			xfs_set_projid(ip, xfs_kprojid_to_projid(projid));
> +		}
>  	}
>  
>  	if (mask & ATTR_MODE)
> @@ -763,8 +792,10 @@ xfs_setattr_nonsize(
>  	 */
>  	xfs_qm_dqrele(olddquot1);
>  	xfs_qm_dqrele(olddquot2);
> +	xfs_qm_dqrele(olddquot3);
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(gdqp);
> +	xfs_qm_dqrele(pdqp);
>  
>  	if (error)
>  		return error;
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index edbd5a210df2..80f5ea32823d 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -191,6 +191,16 @@ static inline kgid_t xfs_gid_to_kgid(uint32_t gid)
>  	return make_kgid(&init_user_ns, gid);
>  }
>  
> +static inline uint32_t xfs_kprojid_to_projid(kprojid_t projid)
> +{
> +	return from_kprojid(&init_user_ns, projid);
> +}
> +
> +static inline kprojid_t xfs_projid_to_kprojid(uint32_t projid)
> +{
> +	return make_kprojid(&init_user_ns, projid);
> +}
> +
>  static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
>  {
>  	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
> -- 
> 2.19.1
> 
