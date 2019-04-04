Return-Path: <SRS0=e1E2=SG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B844C4360F
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 15:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3F6C2064A
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 15:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ybeh2wJW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbfDDPBW (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 Apr 2019 11:01:22 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44910 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfDDPBW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Apr 2019 11:01:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x34ExEKE024282;
        Thu, 4 Apr 2019 15:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=WH5zE9cKGgysgnsdcyxllmCvvGi9zvG4Io7MRx/+GBM=;
 b=Ybeh2wJWH3+Uw7ocz4NX9KswiMdi6JbU2T9QRlsQxqXy6L34ERkLIDmdJQi9xcQ+r+TP
 2bxV4d7idSs0glNpg2TKsQsMhCXjlsDswE4/1jxmWq7Ml8GXvaadxjjpwbED/zWm6hrR
 /GnCJDgEownvBxuMapn/E9XbepfLRflGKhSmJV4bHspHmR5edDhbGYCVul3OR39h9iin
 QOi2Eou2bOaNIMBuMhlB+SpG0FGtp6Xwf+y0cqpRSeNtxx0KSxNv/vSKfhPb79dwi4tK
 8J4zwwzdERVVtdT66nzkgV8lYyRpay1olI1BOG+fnDPwLbvgXINDIkD/PwBn3XwSOHAE eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2rhwydfu2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Apr 2019 15:00:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x34Exg5n073296;
        Thu, 4 Apr 2019 15:00:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2rm8f6qpwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Apr 2019 15:00:35 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x34F0Vij027167;
        Thu, 4 Apr 2019 15:00:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Apr 2019 08:00:30 -0700
Date:   Thu, 4 Apr 2019 08:00:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        cohuck@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
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
Subject: Re: [Qemu-devel] [PATCH v4 5/5] xfs: disable map_sync for async flush
Message-ID: <20190404150025.GN5147@magnolia>
References: <20190403104018.23947-1-pagupta@redhat.com>
 <20190403104018.23947-6-pagupta@redhat.com>
 <20190403220912.GB26298@dastard>
 <20190403223921.GM5147@magnolia>
 <1508883801.17367965.1554358418550.JavaMail.zimbra@redhat.com>
 <651986267.17402634.1554368950178.JavaMail.zimbra@redhat.com>
 <20190404094029.GD16131@quack2.suse.cz>
 <527416483.17415178.1554372524196.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527416483.17415178.1554372524196.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904040097
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904040097
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 04, 2019 at 06:08:44AM -0400, Pankaj Gupta wrote:
> 
> > On Thu 04-04-19 05:09:10, Pankaj Gupta wrote:
> > > 
> > > > > On Thu, Apr 04, 2019 at 09:09:12AM +1100, Dave Chinner wrote:
> > > > > > On Wed, Apr 03, 2019 at 04:10:18PM +0530, Pankaj Gupta wrote:
> > > > > > > Virtio pmem provides asynchronous host page cache flush
> > > > > > > mechanism. we don't support 'MAP_SYNC' with virtio pmem
> > > > > > > and xfs.
> > > > > > > 
> > > > > > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > > > > > ---
> > > > > > >  fs/xfs/xfs_file.c | 8 ++++++++
> > > > > > >  1 file changed, 8 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > > > > > index 1f2e2845eb76..dced2eb8c91a 100644
> > > > > > > --- a/fs/xfs/xfs_file.c
> > > > > > > +++ b/fs/xfs/xfs_file.c
> > > > > > > @@ -1203,6 +1203,14 @@ xfs_file_mmap(
> > > > > > >  	if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
> > > > > > >  		return -EOPNOTSUPP;
> > > > > > >  
> > > > > > > +	/* We don't support synchronous mappings with DAX files if
> > > > > > > +	 * dax_device is not synchronous.
> > > > > > > +	 */
> > > > > > > +	if (IS_DAX(file_inode(filp)) && !dax_synchronous(
> > > > > > > +		xfs_find_daxdev_for_inode(file_inode(filp))) &&
> > > > > > > +					(vma->vm_flags & VM_SYNC))
> > > > > > > +		return -EOPNOTSUPP;
> > > > > > > +
> > > > > > >  	file_accessed(filp);
> > > > > > >  	vma->vm_ops = &xfs_file_vm_ops;
> > > > > > >  	if (IS_DAX(file_inode(filp)))
> > > > > > 
> > > > > > All this ad hoc IS_DAX conditional logic is getting pretty nasty.
> > > > > > 
> > > > > > xfs_file_mmap(
> > > > > > ....
> > > > > > {
> > > > > > 	struct inode	*inode = file_inode(filp);
> > > > > > 
> > > > > > 	if (vma->vm_flags & VM_SYNC) {
> > > > > > 		if (!IS_DAX(inode))
> > > > > > 			return -EOPNOTSUPP;
> > > > > > 		if (!dax_synchronous(xfs_find_daxdev_for_inode(inode))
> > > > > > 			return -EOPNOTSUPP;
> > > > > > 	}
> > > > > > 
> > > > > > 	file_accessed(filp);
> > > > > > 	vma->vm_ops = &xfs_file_vm_ops;
> > > > > > 	if (IS_DAX(inode))
> > > > > > 		vma->vm_flags |= VM_HUGEPAGE;
> > > > > > 	return 0;
> > > > > > }
> > > > > > 
> > > > > > 
> > > > > > Even better, factor out all the "MAP_SYNC supported" checks into a
> > > > > > helper so that the filesystem code just doesn't have to care about
> > > > > > the details of checking for DAX+MAP_SYNC support....
> > > > > 
> > > > > Seconded, since ext4 has nearly the same flag validation logic.
> > > > 
> > > 
> > > Only issue with this I see is we need the helper function only for
> > > supported
> > > filesystems ext4 & xfs (right now). If I create the function in "fs.h" it
> > > will be compiled for every filesystem, even for those don't need it.
> > > 
> > > Sample patch below, does below patch is near to what you have in mind?
> > 
> > So I would put the helper in include/linux/dax.h and have it like:
> > 
> > bool daxdev_mapping_supported(struct vm_area_struct *vma,

Should this be static inline if you're putting it in the header file?

A comment ought to be added to describe what this predicate function
does.

> > 			      struct dax_device *dax_dev)
> > {
> > 	if (!(vma->vm_flags & VM_SYNC))
> > 		return true;
> > 	if (!IS_DAX(file_inode(vma->vm_file)))
> > 		return false;
> > 	return dax_synchronous(dax_dev);
> > }
> 
> Sure. This is much better. I was also not sure what to name the helper function.
> I will go ahead with this unless 'Dave' & 'Darrick' have anything to add.

Jan's approach (modulo that one comment) looks good to me.

--D

> Thank you very much.
> 
> Best regards,
> Pankaj 
> 
> > 
> > 								Honza
> > > 
> > > =================
> > > 
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index 1f2e2845eb76..614995170cac 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -1196,12 +1196,17 @@ xfs_file_mmap(
> > >         struct file     *filp,
> > >         struct vm_area_struct *vma)
> > >  {
> > > +       struct dax_device *dax_dev =
> > > xfs_find_daxdev_for_inode(file_inode(filp));
> > > +
> > >         /*
> > > -        * We don't support synchronous mappings for non-DAX files. At
> > > least
> > > -        * until someone comes with a sensible use case.
> > > +        * We don't support synchronous mappings for non-DAX files and
> > > +        * for DAX files if underneath dax_device is not synchronous.
> > >          */
> > > -       if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
> > > -               return -EOPNOTSUPP;
> > > +       if (vma->vm_flags & VM_SYNC) {
> > > +               int err = is_synchronous(filp, dax_dev);
> > > +               if (err)
> > > +                       return err;
> > > +       }
> > >  
> > >         file_accessed(filp);
> > >         vma->vm_ops = &xfs_file_vm_ops;
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index 8b42df09b04c..add017de3dd7 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -2162,6 +2162,20 @@ static inline void file_accessed(struct file *file)
> > >                 touch_atime(&file->f_path);
> > >  }
> > >  
> > > +struct dax_device;
> > > +extern bool dax_synchronous(struct dax_device *dax_dev);
> > > +static inline int is_synchronous(struct file *filp, struct dax_device
> > > *dax_dev)
> > > +{
> > > +       struct inode *inode = file_inode(filp);
> > > +
> > > +       if (!IS_DAX(inode))
> > > +               return -EOPNOTSUPP;
> > > +       if (!dax_synchronous(dax_dev))
> > > +               return -EOPNOTSUPP;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > >  int sync_inode(struct inode *inode, struct writeback_control *wbc);
> > >  int sync_inode_metadata(struct inode *inode, int wait);
> > >  
> > > ---------
> > > 
> > > Thanks,
> > > Pankaj
> > > 
> > > 
> > > 
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
> > 
> > 
