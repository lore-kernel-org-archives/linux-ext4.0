Return-Path: <SRS0=e1E2=SG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2956C4360F
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 10:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8654E21734
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 10:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfDDKIp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 Apr 2019 06:08:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728728AbfDDKIp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 Apr 2019 06:08:45 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D3C730B4AC7;
        Thu,  4 Apr 2019 10:08:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 77BA3983B;
        Thu,  4 Apr 2019 10:08:44 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 430A51819AFA;
        Thu,  4 Apr 2019 10:08:44 +0000 (UTC)
Date:   Thu, 4 Apr 2019 06:08:44 -0400 (EDT)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com, Dave Chinner <david@fromorbit.com>,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org,
        aarcange@redhat.com, dave jiang <dave.jiang@intel.com>,
        linux-nvdimm@lists.01.org,
        vishal l verma <vishal.l.verma@intel.com>, david@redhat.com,
        willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org,
        jmoyer@redhat.com, linux-ext4@vger.kernel.org, lenb@kernel.org,
        riel@surriel.com, stefanha@redhat.com,
        dan j williams <dan.j.williams@intel.com>,
        lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com,
        tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        imammedo@redhat.com
Message-ID: <527416483.17415178.1554372524196.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190404094029.GD16131@quack2.suse.cz>
References: <20190403104018.23947-1-pagupta@redhat.com> <20190403104018.23947-6-pagupta@redhat.com> <20190403220912.GB26298@dastard> <20190403223921.GM5147@magnolia> <1508883801.17367965.1554358418550.JavaMail.zimbra@redhat.com> <651986267.17402634.1554368950178.JavaMail.zimbra@redhat.com> <20190404094029.GD16131@quack2.suse.cz>
Subject: Re: [Qemu-devel] [PATCH v4 5/5] xfs: disable map_sync for async
 flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.116.146, 10.4.195.18]
Thread-Topic: disable map_sync for async flush
Thread-Index: vR1AEl9E2RamNqVZ7jOkEfJYDPUHJg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 04 Apr 2019 10:08:44 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


> On Thu 04-04-19 05:09:10, Pankaj Gupta wrote:
> > 
> > > > On Thu, Apr 04, 2019 at 09:09:12AM +1100, Dave Chinner wrote:
> > > > > On Wed, Apr 03, 2019 at 04:10:18PM +0530, Pankaj Gupta wrote:
> > > > > > Virtio pmem provides asynchronous host page cache flush
> > > > > > mechanism. we don't support 'MAP_SYNC' with virtio pmem
> > > > > > and xfs.
> > > > > > 
> > > > > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > > > > ---
> > > > > >  fs/xfs/xfs_file.c | 8 ++++++++
> > > > > >  1 file changed, 8 insertions(+)
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > > > index 1f2e2845eb76..dced2eb8c91a 100644
> > > > > > --- a/fs/xfs/xfs_file.c
> > > > > > +++ b/fs/xfs/xfs_file.c
> > > > > > @@ -1203,6 +1203,14 @@ xfs_file_mmap(
> > > > > >  	if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
> > > > > >  		return -EOPNOTSUPP;
> > > > > >  
> > > > > > +	/* We don't support synchronous mappings with DAX files if
> > > > > > +	 * dax_device is not synchronous.
> > > > > > +	 */
> > > > > > +	if (IS_DAX(file_inode(filp)) && !dax_synchronous(
> > > > > > +		xfs_find_daxdev_for_inode(file_inode(filp))) &&
> > > > > > +					(vma->vm_flags & VM_SYNC))
> > > > > > +		return -EOPNOTSUPP;
> > > > > > +
> > > > > >  	file_accessed(filp);
> > > > > >  	vma->vm_ops = &xfs_file_vm_ops;
> > > > > >  	if (IS_DAX(file_inode(filp)))
> > > > > 
> > > > > All this ad hoc IS_DAX conditional logic is getting pretty nasty.
> > > > > 
> > > > > xfs_file_mmap(
> > > > > ....
> > > > > {
> > > > > 	struct inode	*inode = file_inode(filp);
> > > > > 
> > > > > 	if (vma->vm_flags & VM_SYNC) {
> > > > > 		if (!IS_DAX(inode))
> > > > > 			return -EOPNOTSUPP;
> > > > > 		if (!dax_synchronous(xfs_find_daxdev_for_inode(inode))
> > > > > 			return -EOPNOTSUPP;
> > > > > 	}
> > > > > 
> > > > > 	file_accessed(filp);
> > > > > 	vma->vm_ops = &xfs_file_vm_ops;
> > > > > 	if (IS_DAX(inode))
> > > > > 		vma->vm_flags |= VM_HUGEPAGE;
> > > > > 	return 0;
> > > > > }
> > > > > 
> > > > > 
> > > > > Even better, factor out all the "MAP_SYNC supported" checks into a
> > > > > helper so that the filesystem code just doesn't have to care about
> > > > > the details of checking for DAX+MAP_SYNC support....
> > > > 
> > > > Seconded, since ext4 has nearly the same flag validation logic.
> > > 
> > 
> > Only issue with this I see is we need the helper function only for
> > supported
> > filesystems ext4 & xfs (right now). If I create the function in "fs.h" it
> > will be compiled for every filesystem, even for those don't need it.
> > 
> > Sample patch below, does below patch is near to what you have in mind?
> 
> So I would put the helper in include/linux/dax.h and have it like:
> 
> bool daxdev_mapping_supported(struct vm_area_struct *vma,
> 			      struct dax_device *dax_dev)
> {
> 	if (!(vma->vm_flags & VM_SYNC))
> 		return true;
> 	if (!IS_DAX(file_inode(vma->vm_file)))
> 		return false;
> 	return dax_synchronous(dax_dev);
> }

Sure. This is much better. I was also not sure what to name the helper function.
I will go ahead with this unless 'Dave' & 'Darrick' have anything to add.

Thank you very much.

Best regards,
Pankaj 

> 
> 								Honza
> > 
> > =================
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 1f2e2845eb76..614995170cac 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1196,12 +1196,17 @@ xfs_file_mmap(
> >         struct file     *filp,
> >         struct vm_area_struct *vma)
> >  {
> > +       struct dax_device *dax_dev =
> > xfs_find_daxdev_for_inode(file_inode(filp));
> > +
> >         /*
> > -        * We don't support synchronous mappings for non-DAX files. At
> > least
> > -        * until someone comes with a sensible use case.
> > +        * We don't support synchronous mappings for non-DAX files and
> > +        * for DAX files if underneath dax_device is not synchronous.
> >          */
> > -       if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
> > -               return -EOPNOTSUPP;
> > +       if (vma->vm_flags & VM_SYNC) {
> > +               int err = is_synchronous(filp, dax_dev);
> > +               if (err)
> > +                       return err;
> > +       }
> >  
> >         file_accessed(filp);
> >         vma->vm_ops = &xfs_file_vm_ops;
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 8b42df09b04c..add017de3dd7 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2162,6 +2162,20 @@ static inline void file_accessed(struct file *file)
> >                 touch_atime(&file->f_path);
> >  }
> >  
> > +struct dax_device;
> > +extern bool dax_synchronous(struct dax_device *dax_dev);
> > +static inline int is_synchronous(struct file *filp, struct dax_device
> > *dax_dev)
> > +{
> > +       struct inode *inode = file_inode(filp);
> > +
> > +       if (!IS_DAX(inode))
> > +               return -EOPNOTSUPP;
> > +       if (!dax_synchronous(dax_dev))
> > +               return -EOPNOTSUPP;
> > +
> > +       return 0;
> > +}
> > +
> >  int sync_inode(struct inode *inode, struct writeback_control *wbc);
> >  int sync_inode_metadata(struct inode *inode, int wait);
> >  
> > ---------
> > 
> > Thanks,
> > Pankaj
> > 
> > 
> > 
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 
> 
