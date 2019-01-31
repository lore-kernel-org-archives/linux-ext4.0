Return-Path: <SRS0=L9HK=QH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69FD6C169C4
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 17:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 422B9218AF
	for <linux-ext4@archiver.kernel.org>; Thu, 31 Jan 2019 17:41:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cdSUCqwa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfAaRlO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 31 Jan 2019 12:41:14 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49264 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfAaRlO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2019 12:41:14 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0VHXjIC155684;
        Thu, 31 Jan 2019 17:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=mFEEW1rAPCWXrR8qdCuly8mnU20nbAlYMBSK7CHAq68=;
 b=cdSUCqwapWrRWAtCAuFkG46647++Ew1XchnFd85Ewtx/JrD6rnH+DQvS8/5RkgAjGbm/
 nBsFQqCFbBDl9kS0s7pXVvfANbMDj/O2VbLsYrvlir0joA3nV2JI0AsgWJx2QX2PuBNy
 c4qNT48SQBHzbOfq/PgJMdqtG3DCD/RGEJ8YMTvH1Ln42WM5HjGysJyBshS01wyVQsT3
 GWyrbx85r6GjBCVrgxAUQS7XYwTxFHrW6Lldl/hmqmSCED/tdyv6V43vz0yS/weFIWce
 hmZTZ+5haD5w0UsmNcywgF3Up57Cwi1LavNk3rDnFMXawxoSANvOMqKFG8S2WaT2wm3V EA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2q8d2ejebe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Jan 2019 17:41:07 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0VHf6oS007863
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Jan 2019 17:41:06 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0VHf6DP004069;
        Thu, 31 Jan 2019 17:41:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Jan 2019 09:41:05 -0800
Date:   Thu, 31 Jan 2019 09:40:59 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Wang Shilong <wangshilong1991@gmail.com>,
        linux-ext4@vger.kernel.org, linux-fs@vger.kernel.org,
        linux-xfs@vger.kernel.org, Wang Shilong <wshilong@ddn.com>,
        Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>
Subject: Re: [RFC PATCH] ext4: add link file support for {GET,SET}XATTR ioctl
Message-ID: <20190131174059.GA10211@magnolia>
References: <1548899232-30311-1-git-send-email-wshilong1991@gmail.com>
 <20190131034106.GJ4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190131034106.GJ4205@dastard>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9152 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1901310135
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 31, 2019 at 02:41:06PM +1100, Dave Chinner wrote:
> On Thu, Jan 31, 2019 at 10:47:12AM +0900, Wang Shilong wrote:
> > From: Wang Shilong <wshilong@ddn.com>
> > 
> > Currently there is no way to change project ID of
> > symlink file itself, this is important to implement
> > Directory quota for an existed directory.
> 
> This seems like something open(O_PATH|O_NOFOLLOW) should allow.
> from open(2):

...but I thought O_PATH|O_NOFOLLOW file descriptions didn't allow ioctl
calls?

$ ln -sf urk /mnt/cow
$ xfs_io -c 'open -PL /mnt/cow' -c 'chproj 6'
setprojid: Bad file descriptor
$ ls -la /mnt/
lrwxrwxrwx 1 root root 3 Jan 31 09:30 /mnt/cow -> moo

> 	If pathname is a symbolic link and the O_NOFOLLOW flag is
> 	also specified, then the call returns a file  descriptor
> 	referring  to  the symbolic  link.  This  file  descriptor
> 	can  be used as the dirfd argument in calls to fchownat(2),
> 	fstatat(2), linkat(2), and read¿ linkat(2) with an empty
> 	pathname to have the calls operate on the symbolic link.
> 
> Changing the project id is the equivalent of fchownat().....

/me & others wonder (on the ext4 call) if maybe we should promote
project id to a vfs level concept?  i.e. store project id in struct
inode instead of the fs-specific inode structures.  Then we can use the
existing setattr infrastructure to persist those changes.

As for fchownat, how about a new flag that means "use the value in the
gid field to set the project id"?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
