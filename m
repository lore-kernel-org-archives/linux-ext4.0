Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D52BC4360F
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 04:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B983208E4
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 04:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZLLaYsII"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfDBEzZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 00:55:25 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51546 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfDBEzZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2019 00:55:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x324tLNY076812;
        Tue, 2 Apr 2019 04:55:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=xTLBhoPar1N3KO7pDz8fyMJSrxb03nUb3wSrurX+Q58=;
 b=ZLLaYsIIB9ROYFbrHXR77j0wMAsBdIdvrTqYsSatVZQB2fF05KEGv33PkMRuQhM0voBC
 FQAwOoceyBq9Y5AnAo9/e6L5dRf+FehIz8ifUYvBrV9xxrcus2W+RaLa1Ytp8yRPAEML
 dODYEY1nRXyR60DG8/tQqHnh/gzMIsA+YwhS+gZxiMJIE/yAJ43ujDw3Gj+F6Bm2iOye
 vAapuzEOUwbZcDlcZfaGeAqkzcYYnEGQK+rHY6VyaVuYXi8L/qvFFlhR5R7gHSNTAnQe
 F2BDXlE3pGpktMI7kqpY6rVIwkBzKvzuHsWWgDmkQp0qxyp3MmhkClcLB7jvJE1jCtEC Qw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2rhwyd2wg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Apr 2019 04:55:21 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x324tKUh007336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Apr 2019 04:55:20 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x324tKho006644;
        Tue, 2 Apr 2019 04:55:20 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Apr 2019 21:55:20 -0700
Date:   Mon, 1 Apr 2019 21:55:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Message-ID: <20190402045519.GK1173@magnolia>
References: <20190401070001.GJ1173@magnolia>
 <20190401214632.GS26298@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401214632.GS26298@dastard>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9214 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904020035
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 02, 2019 at 08:46:32AM +1100, Dave Chinner wrote:
> On Mon, Apr 01, 2019 at 12:00:01AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Does your computer use a bootloader which arrogantly declares that it can
> > read boot files off a filesystem but isn't sophisticated enough even to
> > recognize when that filesystem needs journal recovery?
> > 
> > Does your system software deployment program foolishly omit system calls
> > to flush newly unwrapped packages to disk?  Do you sometimes wonder if
> > they've forgotten that old maxim, "wait for the disk drive light to turn
> > off /before/ you power down"?
> > 
> > Are your computer operators aggressively derpy?  Do they have a habit of
> > leaving disk cables on the floor so they can trip over them twenty times
> > a day?  Does this leave you with sad files full of zeroes?
> > 
> > If so, bootfs is for you!  This new filesystem type uses journalling to
> > ensure metadata integrity, but forces all writes and directory tree
> > updates to be synchronous, fsyncs files on close, and checkpoints its
> > journal whenever a synchronization event happens.  Some allege this is
> > very slow, but I've been able to max out the iops on both of my double
> > height floppy drives!  In a power-cycling stress test, I found that the
> > switch broke off in my hand before I lost any data.  This concept may
> > sound terrible, but like any good crutch, it _is_ made of wood!
> > 
> > Singed-off-by: Darrick J. Wong <djwong@kernel.org>
>   ^^^^^^^^^^
> 
> Ooooo - such a hot topic! Finally bootfs is more than just
> we-really-should-do-this conference talk!
> 
> Looks good to me - with this we can finally move on from LILO....

When Ted is done laughing, I really would like to consider something
like this to solve the problem of grub-style bootloaders requiring a
lease on the blocks underneath a file with a term exceeding that of the
running kernel.

We can probably skip the harsh synchronous writes in favor of fsync on
close, but we would need to keep the critical component of checkpointing
the journal on fsync and syncfs.

> Acked-by: Dave Chinner <david@fromorbit.com>
> 
> FWIW, Should this have a cc: stable@kernel.org tag on
> it so it gets out into distro-world ASAP?

Eh, I was going to let AI autoselect it...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
