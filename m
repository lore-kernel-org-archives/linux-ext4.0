Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B203EC10F13
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 15:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A3DB2133D
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 15:57:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfDKP5l (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Apr 2019 11:57:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbfDKP5l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 11 Apr 2019 11:57:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D429D30671F5;
        Thu, 11 Apr 2019 15:57:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B249B69183;
        Thu, 11 Apr 2019 15:57:39 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 17B693FB10;
        Thu, 11 Apr 2019 15:57:39 +0000 (UTC)
Date:   Thu, 11 Apr 2019 11:57:38 -0400 (EDT)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     cohuck@redhat.com, Jan Kara <jack@suse.cz>,
        KVM list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        virtualization@lists.linux-foundation.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Ross Zwisler <zwisler@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        jmoyer <jmoyer@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, kilobyte@angband.pl,
        Rik van Riel <riel@surriel.com>,
        yuval shaia <yuval.shaia@oracle.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        Kevin Wolf <kwolf@redhat.com>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Igor Mammedov <imammedo@redhat.com>
Message-ID: <1463291806.21158433.1554998258746.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
References: <20190410040826.24371-1-pagupta@redhat.com> <20190410040826.24371-2-pagupta@redhat.com> <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH v5 1/6] libnvdimm: nd_region flush callback
 support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.116.71, 10.4.195.2]
Thread-Topic: libnvdimm: nd_region flush callback support
Thread-Index: GJ8qWIgyQ5yOMTJqnF06RrwSs6tgyQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 11 Apr 2019 15:57:40 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org



> >
> > This patch adds functionality to perform flush from guest
> > to host over VIRTIO. We are registering a callback based
> > on 'nd_region' type. virtio_pmem driver requires this special
> > flush function. For rest of the region types we are registering
> > existing flush function. Report error returned by host fsync
> > failure to userspace.
> >
> > This also handles asynchronous flush requests from the block layer
> > by creating a child bio and chaining it with parent bio.
> >
> > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > ---bio_chain Dan williams
> [..]
> > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> > index b4ef7d9ff22e..fb1041ab32a6 100644
> > --- a/drivers/nvdimm/region_devs.c
> > +++ b/drivers/nvdimm/region_devs.c
> > @@ -295,7 +295,9 @@ static ssize_t deep_flush_store(struct device *dev,
> > struct device_attribute *att
> >                 return rc;
> >         if (!flush)
> >                 return -EINVAL;
> > -       nvdimm_flush(nd_region);
> > +       rc = nvdimm_flush(nd_region, NULL, false);
> > +       if (rc)
> > +               return rc;
> >
> >         return len;
> >  }
> > @@ -1085,6 +1087,11 @@ static struct nd_region *nd_region_create(struct
> > nvdimm_bus *nvdimm_bus,
> >         dev->of_node = ndr_desc->of_node;
> >         nd_region->ndr_size = resource_size(ndr_desc->res);
> >         nd_region->ndr_start = ndr_desc->res->start;
> > +       if (ndr_desc->flush)
> > +               nd_region->flush = ndr_desc->flush;
> > +       else
> > +               nd_region->flush = generic_nvdimm_flush;
> > +
> >         nd_device_register(dev);
> >
> >         return nd_region;
> > @@ -1125,11 +1132,36 @@ struct nd_region
> > *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
> >  }
> >  EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
> >
> > +int nvdimm_flush(struct nd_region *nd_region, struct bio *bio, bool async)
> > +{
> 
> I don't quite see the point of the 'async' argument. All the usages of
> this routine are either
> 
> nvdimm_flush(nd_region, bio, true)
> ...or:
> nvdimm_flush(nd_region, NULL, false)

Agree.

> 
> ...so why not gate async behavior on the presence of the 'bio' argument?

Sure.

> 
> 
> > +       int rc = 0;
> > +
> > +       /* Create child bio for asynchronous flush and chain with
> > +        * parent bio. Otherwise directly call nd_region flush.
> > +        */
> > +       if (async && bio->bi_iter.bi_sector != -1) {
> > +
> > +               struct bio *child = bio_alloc(GFP_ATOMIC, 0);
> > +
> > +               if (!child)
> > +                       return -ENOMEM;
> > +               bio_copy_dev(child, bio);
> > +               child->bi_opf = REQ_PREFLUSH;
> > +               child->bi_iter.bi_sector = -1;
> > +               bio_chain(child, bio);
> > +               submit_bio(child);
> 
> I understand how this works, but it's a bit too "magical" for my
> taste. I would prefer that all flush implementations take an optional
> 'bio' argument rather than rely on the make_request implementation to
> stash the bio away on a driver specific list.

I did this to make use of "bio_chain" for chaining child bio for async flush
suggested [1]. Are you saying to remove this and just call "flush" based on 
bio argument? Or I implemented the 'bio_chain' request entirely wrong?

[1] https://lkml.org/lkml/2018/9/27/1028

> 
> > +       } else {
> > +               if (nd_region->flush(nd_region))
> > +                       rc = -EIO;
> 
> Given the common case wants to be fast and synchronous I think we
> should try to avoid retpoline overhead by default. So something like
> this:
> 
> if (nd_region->flush == generic_nvdimm_flush)
>     rc = generic_nvdimm_flush(...);

Sure.

Thanks,
Pankaj
> 
> 
