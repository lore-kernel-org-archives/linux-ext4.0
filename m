Return-Path: <SRS0=E3Xq=SZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B0DC282DD
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 22:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7012C218D2
	for <linux-ext4@archiver.kernel.org>; Tue, 23 Apr 2019 22:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbfDWW2v (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 23 Apr 2019 18:28:51 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36421 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726325AbfDWW2v (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 23 Apr 2019 18:28:51 -0400
X-Greylist: delayed 1583 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Apr 2019 18:28:49 EDT
Received: from dread.disaster.area (pa49-180-172-16.pa.nsw.optusnet.com.au [49.180.172.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 613CD105EA0B;
        Wed, 24 Apr 2019 08:02:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hJ3UX-0002gQ-2Q; Wed, 24 Apr 2019 08:02:17 +1000
Date:   Wed, 24 Apr 2019 08:02:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org,
        qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, dan.j.williams@intel.com,
        zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
        mst@redhat.com, jasowang@redhat.com, willy@infradead.org,
        rjw@rjwysocki.net, hch@infradead.org, lenb@kernel.org,
        jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca,
        darrick.wong@oracle.com, lcapitulino@redhat.com, kwolf@redhat.com,
        imammedo@redhat.com, jmoyer@redhat.com, nilal@redhat.com,
        riel@surriel.com, stefanha@redhat.com, aarcange@redhat.com,
        david@redhat.com, cohuck@redhat.com, xiaoguangrong.eric@gmail.com,
        pbonzini@redhat.com, yuval.shaia@oracle.com, kilobyte@angband.pl
Subject: Re: [PATCH v6 6/6] xfs: disable map_sync for async flush
Message-ID: <20190423220217.GA29573@dread.disaster.area>
References: <20190423080612.15361-1-pagupta@redhat.com>
 <20190423080612.15361-7-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423080612.15361-7-pagupta@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=UJetJGXy c=1 sm=1 tr=0 cx=a_idp_d
        a=P9M234EABmfYNCwpuVjnFw==:117 a=P9M234EABmfYNCwpuVjnFw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=oexKYjalfGEA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=zOUUIwEDNWhzvqsACr4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 23, 2019 at 01:36:12PM +0530, Pankaj Gupta wrote:
> Dont support 'MAP_SYNC' with non-DAX files and DAX files
> with asynchronous dax_device. Virtio pmem provides
> asynchronous host page cache flush mechanism. We don't
> support 'MAP_SYNC' with virtio pmem and xfs.
> 
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1f2e2845eb76..0e59be018511 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1196,11 +1196,13 @@ xfs_file_mmap(
>  	struct file	*filp,
>  	struct vm_area_struct *vma)
>  {
> -	/*
> -	 * We don't support synchronous mappings for non-DAX files. At least
> -	 * until someone comes with a sensible use case.
> +	struct dax_device *dax_dev = xfs_find_daxdev_for_inode
> +						(file_inode(filp));
> +
> +	/* We don't support synchronous mappings for non-DAX files and
> +	 * for DAX files if underneath dax_device is not synchronous.
>  	 */

	/*
	 * This is the correct multi-line comment format. Please
	 * update the patch to maintain the existing comment format.
	 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
