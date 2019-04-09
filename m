Return-Path: <SRS0=i6rR=SL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7E6C10F13
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Apr 2019 03:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3986C20880
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Apr 2019 03:25:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xqaXzMkI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfDIDZU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Apr 2019 23:25:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53640 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfDIDZT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2019 23:25:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x393O4aS152460;
        Tue, 9 Apr 2019 03:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ZCSj2DOxFkKhFMwrijQVo7632lAxfc4UdUyJK1s5S5o=;
 b=xqaXzMkIO8i0SdwjoDMNMMlr2ltrceHmnQnkHJ76U1ZmLj6lnm1RpBGWQBTIZ5X/8r0Z
 3HddyX65QSAp2vTCCly+QIVKqFjiPHQ2syZoFwXhGmCQM+1Z022TxK6XPjv6t9rTIlVi
 BOsEusWV0pCWcsSSbK3WsG3JAw7kQ4GDyMhaqiJETPx8ulbTOlUYdoQ/yHhXk78XVLWx
 OMD20/O+kZDfV5AVcwA6KLxZzv261ZVZ/vY+7Dt8xule/KU9+t7CJwtvT9CZ7XdwBvBp
 G83z31ci1esjltnr98Y0FVkVazcZP0xJCCo3nfEitowQ/QhIHLJj+57GDIsABvVJRTSY 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2rpmrq23yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Apr 2019 03:25:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x393MYcc167860;
        Tue, 9 Apr 2019 03:23:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2rpytbcgyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Apr 2019 03:23:11 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x393N8hm011571;
        Tue, 9 Apr 2019 03:23:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Apr 2019 20:23:07 -0700
Date:   Mon, 8 Apr 2019 20:23:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190409032303.GS15524@magnolia>
References: <20190401070001.GJ1173@magnolia>
 <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia>
 <20190406232717.GH18897@mit.edu>
 <e358c920-d49e-8319-ee19-4b3fa930b0f5@sandeen.net>
 <20190407201328.GR15524@magnolia>
 <581BC10D-6743-4E2E-A4C1-C8C3F9BE9DA3@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <581BC10D-6743-4E2E-A4C1-C8C3F9BE9DA3@dilger.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9221 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904090022
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9221 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904090022
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 08, 2019 at 05:28:23AM -0600, Andreas Dilger wrote:
> On Apr 7, 2019, at 2:13 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > On Sun, Apr 07, 2019 at 01:10:55PM -0500, Eric Sandeen wrote:
> >> On 4/6/19 6:27 PM, Theodore Ts'o wrote:
> >>> On Mon, Apr 01, 2019 at 09:55:19PM -0700, Darrick J. Wong wrote:
> >>>> 
> >>>> When Ted is done laughing, I really would like to consider something
> >>>> like this to solve the problem of grub-style bootloaders requiring a
> >>>> lease on the blocks underneath a file with a term exceeding that of the
> >>>> running kernel.
> >>>> 
> >>>> We can probably skip the harsh synchronous writes in favor of fsync on
> >>>> close, but we would need to keep the critical component of checkpointing
> >>>> the journal on fsync and syncfs.
> >>> 
> >>> At least for ext4, we don't need to add anything new, since FIFREEZE
> >>> force a journal checkpoint.  So we could try to get a patch into grub
> >>> which causes update_grub to open each kernel that it finds, and calls
> >>> fsync(2) on it, and then for all file systems where it finds a kernel,
> >>> it can call FIFREEZE and FITHAW on it, and that would be that.
> >> 
> >> Certain operating systems have hacked this in.  My concern would be when
> >> /boot is on / ... calling FIFREEZE on the root fs would most likely be
> >> a bad thing.  Certain operating systems avoid calling FIFREEZE for
> >> /boot-on-root.  ;)
> >> 
> >> Doing it for a standalone /boot seems like a reasonable (if hacky)
> >> workaround as long as we lack a more targeted quiesce interface...
> > 
> > The other problem we noticed is that neither the grub scripts nor the
> > rpm package scripts bother to call fsync on the files they write (or
> > sync after they're done to mop up after everyone else), so I figured as
> > long as I'm ("jokingly") working around it all in kernel space, why not
> > just go all the way? :P
> > 
> > Ok, I'll go work on an ioctl or something.
> 
> If Grub isn't even bothering to call fsync() on a file, what is the chance
> that they would call a special ioctl on the file?

Well yes, that is the justification for the existence of bootfs, isn't
it? :)

> What about doing "chattr +S /boot" so that all file IO in this directory is
> done synchronously, which would work even if /boot is not on a separate
> filesystem?  The "+S" flag is inherited by new files created in the directory.

That also isn't sufficient, since it doesn't solve the problem of grub
needing the journal/log to be checkpointed.

(I mean, unless you meant chattr +S on *bootfs* instead of its forced
-o sync,dirsync funniness?)

--D

> Cheers, Andreas
> 
> 
> 
> 
> 


