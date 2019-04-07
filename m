Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1636EC10F0E
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 20:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D85FB213F2
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 20:13:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QlwUTVBb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfDGUNp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 7 Apr 2019 16:13:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41756 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfDGUNo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Apr 2019 16:13:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x37KDct2065083;
        Sun, 7 Apr 2019 20:13:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=69nkW4wP172EZR8n2/ioHP9B2y76dhBeNZxnBuIKe80=;
 b=QlwUTVBbCSZS/4DoREHljuCY9zPqa4+1RMbOz5WhYeCC1Ceem7THmhYvUNK/stt9+qHD
 RCvYm4vIPnERnPR/h+YMzq5ili0KwXFPoy8CulJ7+LwCInrv0KuWUaSgL9K/VFyqn2/I
 4UP9oaGNavNP8hebBTSB4/LLrnTq8zTAdhiWPJUtu76dSCDm1ih8B6NOPGNUFypUT7+k
 gafklRRtEM0FG3ajy1bdBptK+ApVFKY6KyV7WyxC5yDNNdeIriUgRzjpAA0rnHemHSqE
 va7pig2BALHBYoEiOrIjfr+wBJj3qHGUHDDwFOlG3YFh8JB7NRGWK6QbgDe6kOqDt2NT jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2rphme3b34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Apr 2019 20:13:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x37KDT5c150537;
        Sun, 7 Apr 2019 20:13:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2rph7rqbtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Apr 2019 20:13:37 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x37KDYpv020165;
        Sun, 7 Apr 2019 20:13:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Apr 2019 13:13:34 -0700
Date:   Sun, 7 Apr 2019 13:13:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190407201328.GR15524@magnolia>
References: <20190401070001.GJ1173@magnolia>
 <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia>
 <20190406232717.GH18897@mit.edu>
 <e358c920-d49e-8319-ee19-4b3fa930b0f5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e358c920-d49e-8319-ee19-4b3fa930b0f5@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904070192
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9220 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904070192
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Apr 07, 2019 at 01:10:55PM -0500, Eric Sandeen wrote:
> On 4/6/19 6:27 PM, Theodore Ts'o wrote:
> > On Mon, Apr 01, 2019 at 09:55:19PM -0700, Darrick J. Wong wrote:
> >>
> >> When Ted is done laughing, I really would like to consider something
> >> like this to solve the problem of grub-style bootloaders requiring a
> >> lease on the blocks underneath a file with a term exceeding that of the
> >> running kernel.
> >>
> >> We can probably skip the harsh synchronous writes in favor of fsync on
> >> close, but we would need to keep the critical component of checkpointing
> >> the journal on fsync and syncfs.
> > 
> > At least for ext4, we don't need to add anything new, since FIFREEZE
> > force a journal checkpoint.  So we could try to get a patch into grub
> > which causes update_grub to open each kernel that it finds, and calls
> > fsync(2) on it, and then for all file systems where it finds a kernel,
> > it can call FIFREEZE and FITHAW on it, and that would be that.
> 
> Certain operating systems have hacked this in.  My concern would be when
> /boot is on / ... calling FIFREEZE on the root fs would most likely be
> a bad thing.  Certain operating systems avoid calling FIFREEZE for
> /boot-on-root.  ;)
> 
> Doing it for a standalone /boot seems like a reasonable (if hacky)
> workaround as long as we lack a more targeted quiesce interface...

The other problem we noticed is that neither the grub scripts nor the
rpm package scripts bother to call fsync on the files they write (or
sync after they're done to mop up after everyone else), so I figured as
long as I'm ("jokingly") working around it all in kernel space, why not
just go all the way? :P

Ok, I'll go work on an ioctl or something.

--D

> -Eric
>  
> > That's not guaranteed to work for all file systems, of course.  So the
> > right answer may be to define a new IOCTL which causes all file system
> > to do whatever log truncation is needed so that grub will do the right
> > thing.
> > 
> > 					- Ted
> > 
