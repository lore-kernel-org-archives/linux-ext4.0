Return-Path: <SRS0=E3Xq=SZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69018C282E3
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 22:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 331FA21738
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 22:12:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AhdCKmBV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfDWWM0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 23 Apr 2019 18:12:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43272 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfDWWM0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Apr 2019 18:12:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3NM4iVc124778;
        Tue, 23 Apr 2019 22:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=l0VzuwK7fWj7U7YTxx4jiGO26nwCCDX522qiPNeC+/Y=;
 b=AhdCKmBVc8BIdraythvZytA3kVTqYzt3V1UvkKa8Xfe7HC6YDSnfPPTDrmy/WFLKpdLi
 ybqnDXcxozLtDQZSJb/CyE/DswT9j6XDoINpoqLbd6fOf2weWsI9t9Vt+ibJCOhqPJzw
 zGO2+HapNtynOsBUnzXoIU6Pc/S2ZpFJ3nH0vY8pOzQxRYNAIzglWCXbOjBv1lu+6J+7
 ySjy/HIHmQFoQfRXMyTRrFIvGvIeczjvrUJP4emcLz7EwfM87kUd7rVf3KgiZCVQFjSy
 FjbRSFpgfPWnPRLuDOYrsPj2Y3KqDGi6HU6LDXE9hYrQP/SLd8jpFIC+4tXpBOwTFwR3 Qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ryv2q6uyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Apr 2019 22:10:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3NM8hPQ066650;
        Tue, 23 Apr 2019 22:10:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2s0dwegm54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Apr 2019 22:10:24 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3NMAFaf014717;
        Tue, 23 Apr 2019 22:10:15 GMT
Received: from localhost (/10.145.179.89)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Apr 2019 15:10:15 -0700
Date:   Tue, 23 Apr 2019 15:10:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org,
        qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, dan.j.williams@intel.com,
        zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
        mst@redhat.com, jasowang@redhat.com, willy@infradead.org,
        rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org,
        jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca,
        lcapitulino@redhat.com, kwolf@redhat.com, imammedo@redhat.com,
        jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com,
        stefanha@redhat.com, aarcange@redhat.com, david@redhat.com,
        cohuck@redhat.com, xiaoguangrong.eric@gmail.com,
        pbonzini@redhat.com, yuval.shaia@oracle.com, kilobyte@angband.pl
Subject: Re: [PATCH v6 6/6] xfs: disable map_sync for async flush
Message-ID: <20190423221011.GD178290@magnolia>
References: <20190423080612.15361-1-pagupta@redhat.com>
 <20190423080612.15361-7-pagupta@redhat.com>
 <20190423220217.GA29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423220217.GA29573@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9236 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904230157
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9236 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904230157
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 24, 2019 at 08:02:17AM +1000, Dave Chinner wrote:
> On Tue, Apr 23, 2019 at 01:36:12PM +0530, Pankaj Gupta wrote:
> > Dont support 'MAP_SYNC' with non-DAX files and DAX files
> > with asynchronous dax_device. Virtio pmem provides
> > asynchronous host page cache flush mechanism. We don't
> > support 'MAP_SYNC' with virtio pmem and xfs.
> > 
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 1f2e2845eb76..0e59be018511 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1196,11 +1196,13 @@ xfs_file_mmap(
> >  	struct file	*filp,
> >  	struct vm_area_struct *vma)
> >  {
> > -	/*
> > -	 * We don't support synchronous mappings for non-DAX files. At least
> > -	 * until someone comes with a sensible use case.
> > +	struct dax_device *dax_dev = xfs_find_daxdev_for_inode
> > +						(file_inode(filp));

    tab separation here ^^^                   ^^^^ and cut
                                                       down the indent
                                             while you're at
						    it, please:

	struct dax_device	*dax_dev;

	dax_dev = xfs_find_daxdev_for_inode(file_inode(filp));
	if (!dax_is_frobbed(dax))
		return -EMEWANTCOOKIE;

--D

> > +
> > +	/* We don't support synchronous mappings for non-DAX files and
> > +	 * for DAX files if underneath dax_device is not synchronous.
> >  	 */
> 
> 	/*
> 	 * This is the correct multi-line comment format. Please
> 	 * update the patch to maintain the existing comment format.
> 	 */
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
