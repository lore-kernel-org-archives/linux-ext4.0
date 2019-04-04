Return-Path: <SRS0=e1E2=SG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 705E4C10F0C
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 15:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F452082E
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 15:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfDDPuF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 Apr 2019 11:50:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfDDPuF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 Apr 2019 11:50:05 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAFD0F74A7;
        Thu,  4 Apr 2019 15:50:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AC8D84DBB;
        Thu,  4 Apr 2019 15:50:04 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2172941F3C;
        Thu,  4 Apr 2019 15:50:03 +0000 (UTC)
Date:   Thu, 4 Apr 2019 11:50:02 -0400 (EDT)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Jan Kara <jack@suse.cz>, kvm@vger.kernel.org, mst@redhat.com,
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
        cohuck@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        imammedo@redhat.com
Message-ID: <846216210.17971239.1554393002566.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190404150025.GN5147@magnolia>
References: <20190403104018.23947-1-pagupta@redhat.com> <20190403220912.GB26298@dastard> <20190403223921.GM5147@magnolia> <1508883801.17367965.1554358418550.JavaMail.zimbra@redhat.com> <651986267.17402634.1554368950178.JavaMail.zimbra@redhat.com> <20190404094029.GD16131@quack2.suse.cz> <527416483.17415178.1554372524196.JavaMail.zimbra@redhat.com> <20190404150025.GN5147@magnolia>
Subject: Re: [Qemu-devel] [PATCH v4 5/5] xfs: disable map_sync for async
 flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.116.57, 10.4.195.2]
Thread-Topic: disable map_sync for async flush
Thread-Index: 45nNyk/dhs+S+Tyhd4Ieg+M6TOhpwQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 04 Apr 2019 15:50:05 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


> > > 
> > > So I would put the helper in include/linux/dax.h and have it like:
> > > 
> > > bool daxdev_mapping_supported(struct vm_area_struct *vma,
> 
> Should this be static inline if you're putting it in the header file?

yes. Thanks.

> 
> A comment ought to be added to describe what this predicate function
> does.

Sure, will add a comment describing the function.

> 
> > > 			      struct dax_device *dax_dev)
> > > {
> > > 	if (!(vma->vm_flags & VM_SYNC))
> > > 		return true;
> > > 	if (!IS_DAX(file_inode(vma->vm_file)))
> > > 		return false;
> > > 	return dax_synchronous(dax_dev);
> > > }
> > 
> > Sure. This is much better. I was also not sure what to name the helper
> > function.
> > I will go ahead with this unless 'Dave' & 'Darrick' have anything to add.
> 
> Jan's approach (modulo that one comment) looks good to me.

Sure. Thank you.

Best regards,
Pankaj

> 
> --D
> 
