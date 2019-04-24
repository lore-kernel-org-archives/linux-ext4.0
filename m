Return-Path: <SRS0=cG1U=S2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BACC282E1
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 05:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FFC7218D2
	for <linux-ext4@archiver.kernel.org>; Wed, 24 Apr 2019 05:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbfDXFVq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 Apr 2019 01:21:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfDXFVp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Apr 2019 01:21:45 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EE0839D51C;
        Wed, 24 Apr 2019 05:21:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D21345D719;
        Wed, 24 Apr 2019 05:21:44 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7A2163FB10;
        Wed, 24 Apr 2019 05:21:44 +0000 (UTC)
Date:   Wed, 24 Apr 2019 01:21:44 -0400 (EDT)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     Jan Kara <jack@suse.cz>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org,
        aarcange@redhat.com, dave jiang <dave.jiang@intel.com>,
        linux-nvdimm@lists.01.org,
        vishal l verma <vishal.l.verma@intel.com>, david@redhat.com,
        willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org,
        jmoyer@redhat.com, linux-ext4@vger.kernel.org, lenb@kernel.org,
        kilobyte@angband.pl, riel@surriel.com,
        yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com,
        pbonzini@redhat.com, dan j williams <dan.j.williams@intel.com>,
        lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com,
        tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>,
        darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, imammedo@redhat.com
Message-ID: <1325148804.23168491.1556083304080.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190423142748.GE9910@quack2.suse.cz>
References: <20190423080612.15361-1-pagupta@redhat.com> <20190423080612.15361-6-pagupta@redhat.com> <20190423142748.GE9910@quack2.suse.cz>
Subject: Re: [Qemu-devel] [PATCH v6 5/6] ext4: disable map_sync for async
 flush
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.16.97, 10.4.195.9]
Thread-Topic: ext4: disable map_sync for async flush
Thread-Index: I6R5hXfMlzDnCoWVf4J0x3p7zay/cA==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 24 Apr 2019 05:21:45 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


> 
> On Tue 23-04-19 13:36:11, Pankaj Gupta wrote:
> > Dont support 'MAP_SYNC' with non-DAX files and DAX files
> > with asynchronous dax_device. Virtio pmem provides
> > asynchronous host page cache flush mechanism. We don't
> > support 'MAP_SYNC' with virtio pmem and ext4.
> > 
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> 
> The patch looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thank you. Will add this.

Best regards,
Pankaj

> 
> 								Honza
> 
> 
> > ---
> >  fs/ext4/file.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index 69d65d49837b..4b2ccaf1932e 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -360,15 +360,16 @@ static const struct vm_operations_struct
> > ext4_file_vm_ops = {
> >  static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
> >  {
> >  	struct inode *inode = file->f_mapping->host;
> > +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> > +	struct dax_device *dax_dev = sbi->s_daxdev;
> >  
> > -	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
> > +	if (unlikely(ext4_forced_shutdown(sbi)))
> >  		return -EIO;
> >  
> > -	/*
> > -	 * We don't support synchronous mappings for non-DAX files. At least
> > -	 * until someone comes with a sensible use case.
> > +	/* We don't support synchronous mappings for non-DAX files and
> > +	 * for DAX files if underneath dax_device is not synchronous.
> >  	 */
> > -	if (!IS_DAX(file_inode(file)) && (vma->vm_flags & VM_SYNC))
> > +	if (!daxdev_mapping_supported(vma, dax_dev))
> >  		return -EOPNOTSUPP;
> >  
> >  	file_accessed(file);
> > --
> > 2.20.1
> > 
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 
> 
