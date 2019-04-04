Return-Path: <SRS0=e1E2=SG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C76C4360F
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 06:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1DCD20882
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 06:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfDDGMe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfDDGMd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 Apr 2019 02:12:33 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D47A330B4B0B;
        Thu,  4 Apr 2019 06:12:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BCC9219C65;
        Thu,  4 Apr 2019 06:12:31 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1F91C1819AFA;
        Thu,  4 Apr 2019 06:12:31 +0000 (UTC)
Date:   Thu, 4 Apr 2019 02:12:30 -0400 (EDT)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     Dave Chinner <david@fromorbit.com>,
        darrick wong <darrick.wong@oracle.com>
Cc:     linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org,
        qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        dan j williams <dan.j.williams@intel.com>,
        zwisler@kernel.org, vishal l verma <vishal.l.verma@intel.com>,
        dave jiang <dave.jiang@intel.com>, mst@redhat.com,
        jasowang@redhat.com, willy@infradead.org, rjw@rjwysocki.net,
        hch@infradead.org, lenb@kernel.org, jack@suse.cz, tytso@mit.edu,
        adilger kernel <adilger.kernel@dilger.ca>,
        darrick wong <darrick.wong@oracle.com>, lcapitulino@redhat.com,
        kwolf@redhat.com, imammedo@redhat.com, jmoyer@redhat.com,
        nilal@redhat.com, riel@surriel.com, stefanha@redhat.com,
        aarcange@redhat.com, david@redhat.com, cohuck@redhat.com,
        xiaoguangrong eric <xiaoguangrong.eric@gmail.com>
Message-ID: <1518295599.17367903.1554358350929.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190403220912.GB26298@dastard>
References: <20190403104018.23947-1-pagupta@redhat.com> <20190403104018.23947-6-pagupta@redhat.com> <20190403220912.GB26298@dastard>
Subject: Re: [PATCH v4 5/5] xfs: disable map_sync for async flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.161.59, 10.4.195.15]
Thread-Topic: disable map_sync for async flush
Thread-Index: J+RJHDScgLJaLjtnWiZpNkW9g4HxJg==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 04 Apr 2019 06:12:33 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


Hi Dave,

> > Virtio pmem provides asynchronous host page cache flush
> > mechanism. we don't support 'MAP_SYNC' with virtio pmem
> > and xfs.
> > 
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---
> >  fs/xfs/xfs_file.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 1f2e2845eb76..dced2eb8c91a 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1203,6 +1203,14 @@ xfs_file_mmap(
> >  	if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
> >  		return -EOPNOTSUPP;
> >  
> > +	/* We don't support synchronous mappings with DAX files if
> > +	 * dax_device is not synchronous.
> > +	 */
> > +	if (IS_DAX(file_inode(filp)) && !dax_synchronous(
> > +		xfs_find_daxdev_for_inode(file_inode(filp))) &&
> > +					(vma->vm_flags & VM_SYNC))
> > +		return -EOPNOTSUPP;
> > +
> >  	file_accessed(filp);
> >  	vma->vm_ops = &xfs_file_vm_ops;
> >  	if (IS_DAX(file_inode(filp)))
> 
> All this ad hoc IS_DAX conditional logic is getting pretty nasty.
> 
> xfs_file_mmap(
> ....
> {
> 	struct inode	*inode = file_inode(filp);
> 
> 	if (vma->vm_flags & VM_SYNC) {
> 		if (!IS_DAX(inode))
> 			return -EOPNOTSUPP;
> 		if (!dax_synchronous(xfs_find_daxdev_for_inode(inode))
> 			return -EOPNOTSUPP;
> 	}
> 
> 	file_accessed(filp);
> 	vma->vm_ops = &xfs_file_vm_ops;
> 	if (IS_DAX(inode))
> 		vma->vm_flags |= VM_HUGEPAGE;
> 	return 0;
> }

Sure, this is better.

> 
> 
> Even better, factor out all the "MAP_SYNC supported" checks into a
> helper so that the filesystem code just doesn't have to care about
> the details of checking for DAX+MAP_SYNC support....

o.k. Will add one common helper function for both ext4 & xfs filesystems.

Thanks for the suggestion.

Best regards,
Pankaj

> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 
