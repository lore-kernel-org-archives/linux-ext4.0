Return-Path: <SRS0=wlmB=SF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A3FC4360F
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 00:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6A8A206C0
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 00:22:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zdfdnWmf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfDCAWX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 20:22:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfDCAWX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2019 20:22:23 -0400
X-Greylist: delayed 6928 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2019 20:22:22 EDT
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x32MJ9Ek062947;
        Tue, 2 Apr 2019 22:26:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=O3Mkyuxl6MC3jWLa0Q8dLt2NHNoAPDz1zJ+TDGNqe7k=;
 b=zdfdnWmfcfo0TZbKcSpCMMZ1JLUQcYexA7QeH6ImYKaHlTK9DYsd+3aYzWYbuoK5nO7B
 T7U/7rFeq+scCNAN5wVQY4i2ruz6PeB9jyQ9cMMV/aS1JD3QXIPPDlNKDvpgfY3Dp0zj
 YUa4yJlqyGebnz3KHz5vjArF4vC01MQjbW3lhwCD8qtkl2iXeU3yp3yP1LbQO/ZeGoEJ
 TuNwA5jRP4prBH+xrUY5AppZVIh6KDdjOP63rzU0S2Snobq7ROxmyMqXFUTtSuSnusYo
 0AyzW845zdF9AgQ4pWE/DVkP3hgt6HkV+96fYQMYQzlKgvnPwNyOkoPrGBg7MNCy1sdv WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2rj0dnmm5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Apr 2019 22:26:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x32MLPXN099980;
        Tue, 2 Apr 2019 22:22:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2rm8f50xrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Apr 2019 22:22:49 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x32MMkf4025054;
        Tue, 2 Apr 2019 22:22:46 GMT
Received: from localhost (/10.145.179.115)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 15:22:46 -0700
Date:   Tue, 2 Apr 2019 15:22:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190402222244.GH5147@magnolia>
References: <20190401070001.GJ1173@magnolia>
 <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia>
 <E2E8A5E4-D174-4E90-8D8F-F1D69E98F20E@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2E8A5E4-D174-4E90-8D8F-F1D69E98F20E@dilger.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904020146
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9215 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904020146
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 02, 2019 at 03:52:59PM -0600, Andreas Dilger wrote:
> On Apr 1, 2019, at 10:55 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > On Tue, Apr 02, 2019 at 08:46:32AM +1100, Dave Chinner wrote:
> >> On Mon, Apr 01, 2019 at 12:00:01AM -0700, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <djwong@kernel.org>
> >>> 
> >>> Does your computer use a bootloader which arrogantly declares that it can
> >>> read boot files off a filesystem but isn't sophisticated enough even to
> >>> recognize when that filesystem needs journal recovery?
> >>> 
> >>> Does your system software deployment program foolishly omit system calls
> >>> to flush newly unwrapped packages to disk?  Do you sometimes wonder if
> >>> they've forgotten that old maxim, "wait for the disk drive light to turn
> >>> off /before/ you power down"?
> >>> 
> >>> Are your computer operators aggressively derpy?  Do they have a habit of
> >>> leaving disk cables on the floor so they can trip over them twenty times
> >>> a day?  Does this leave you with sad files full of zeroes?
> >>> 
> >>> If so, bootfs is for you!  This new filesystem type uses journalling to
> >>> ensure metadata integrity, but forces all writes and directory tree
> >>> updates to be synchronous, fsyncs files on close, and checkpoints its
> >>> journal whenever a synchronization event happens.  Some allege this is
> >>> very slow, but I've been able to max out the iops on both of my double
> >>> height floppy drives!  In a power-cycling stress test, I found that the
> >>> switch broke off in my hand before I lost any data.  This concept may
> >>> sound terrible, but like any good crutch, it _is_ made of wood!
> >>> 
> >>> Singed-off-by: Darrick J. Wong <djwong@kernel.org>
> >>  ^^^^^^^^^^
> >> 
> >> Ooooo - such a hot topic! Finally bootfs is more than just
> >> we-really-should-do-this conference talk!
> >> 
> >> Looks good to me - with this we can finally move on from LILO....
> > 
> > When Ted is done laughing, I really would like to consider something
> > like this to solve the problem of grub-style bootloaders requiring a
> > lease on the blocks underneath a file with a term exceeding that of the
> > running kernel.
> > 
> > We can probably skip the harsh synchronous writes in favor of fsync on
> > close, but we would need to keep the critical component of checkpointing
> > the journal on fsync and syncfs.
> 
> Wouldn't it be enough if Grub marked the file IMMUTABLE so that it didn't
> get remapped/rewritten?  The RPM pre/post kernel update scripts already
> have hooks to rerun grub and update /etc/grub.conf, so they should also
> be able to handle set/clear of the immutable flag during upgrade.

It would not, because the fundamental problem (with grub) is that it
stumbles if the log hasn't been checkpointed.  The transaction to add
the immutable flag will just end up pending in the log like any other
metadata change, because that doesn't force a log checkpoint.

(Unless you're suggesting that adding IMMUTABLE also checkpoint the log,
which would be a lot of disk writing work...)

--D

> Cheers, Andreas
> 
> 
> 
> 
> 


