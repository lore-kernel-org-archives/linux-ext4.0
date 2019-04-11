Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77356C10F13
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 16:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 462B021872
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 16:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="OExIW2rN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfDKQJR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Apr 2019 12:09:17 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41643 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfDKQJQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2019 12:09:16 -0400
Received: by mail-ot1-f66.google.com with SMTP id 64so5699399otb.8
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2019 09:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6e0pYzlyJULDAsD9P9xF/AncqgDFrFc74lsbm2pp/Hs=;
        b=OExIW2rNOO/AH8PIKD7PW7F27aEB3OXEbjCq6Q6tNZhacP/yTFe/CceQjwK6DhN3wH
         oSYVIYB+W1CWVwUu39E04NAG7rs/ZW1gmqb4pY9Use2kIavWy+EhYD9dN5hnfiBUSXa7
         j3w2WgxABB/9K4yxGHWnWJWZyy+R14QZMxpiaHZKWxzjUW5L8YPQy+TwoIA6GuQM7Hb/
         kuBcj3LTC3SIBPEhfvER2+1uq20CVu/8H3CWzdcmbXQ/4j4zE6By8oEOImglUSPjMCEC
         oSiyhWkjCY5wdaVgflK3PeIX2XQ3v/2wgv8tCDV4u4PMImHPgHDdehpn60Hs6bvMuDdZ
         3Pgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6e0pYzlyJULDAsD9P9xF/AncqgDFrFc74lsbm2pp/Hs=;
        b=F4qHu7nqzAoPnXtbWsAPiSoZy4Ptc+8IllCVT1eGo39JVHhZ7qH7jL3lp9ebJKMZMN
         6WjtXr6PrjipYtsAUk7qMDLE+obFJAmi91hU1PvaOMeWbxcBmUC8867KH3YJ/31KmiUK
         U1Cyk1PMiFSvFkK61EyzaQfri17ZYy5pwJ6HLP2ebtJrdMV8IY0gFns1ccHVruEEFM+C
         /lzPMEdQArQoF2Giiv1Bh0nXmP+rg0rEPCikb66b41IEvh2SPndpRy/h8kAcB5q9H4Ft
         TY9q69QN+goU+TNCck5MWdXY0Fah1xuJX/cZUZ5wbh5O9X8oLJuX5ZYUr9+2VSpuUEgE
         kwaQ==
X-Gm-Message-State: APjAAAVvzr8hY7/QLDoUi4mJV9BzjI087YntI6UzGeqjDhkprPa8mo5Z
        EbvWPYUs3TXOpFnlAgMOsV1R9pIKH/ziaHvXXgo9XQ==
X-Google-Smtp-Source: APXvYqxPfOYC3NUb5uxj6NsGBnQ6+dcHno8VW5WX9/9Ht+h/wnavf1GeLxLM1YyYYr5MU1loEyoELAeRjex0dJAYDmc=
X-Received: by 2002:a9d:5c86:: with SMTP id a6mr31770148oti.118.1554998955333;
 Thu, 11 Apr 2019 09:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190410040826.24371-1-pagupta@redhat.com> <20190410040826.24371-2-pagupta@redhat.com>
 <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com> <1463291806.21158433.1554998258746.JavaMail.zimbra@redhat.com>
In-Reply-To: <1463291806.21158433.1554998258746.JavaMail.zimbra@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 11 Apr 2019 09:09:03 -0700
Message-ID: <CAPcyv4gOPtgmVyk+zayRBtkbSivEvBNn1tyKL2ycT_q_nTHUUA@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH v5 1/6] libnvdimm: nd_region flush callback support
To:     Pankaj Gupta <pagupta@redhat.com>
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
        "Theodore Ts'o" <tytso@mit.edu>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Igor Mammedov <imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 11, 2019 at 9:02 AM Pankaj Gupta <pagupta@redhat.com> wrote:
>
>
>
> > >
> > > This patch adds functionality to perform flush from guest
> > > to host over VIRTIO. We are registering a callback based
> > > on 'nd_region' type. virtio_pmem driver requires this special
> > > flush function. For rest of the region types we are registering
> > > existing flush function. Report error returned by host fsync
> > > failure to userspace.
> > >
> > > This also handles asynchronous flush requests from the block layer
> > > by creating a child bio and chaining it with parent bio.
> > >
> > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > ---bio_chain Dan williams
> > [..]
> > > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> > > index b4ef7d9ff22e..fb1041ab32a6 100644
> > > --- a/drivers/nvdimm/region_devs.c
> > > +++ b/drivers/nvdimm/region_devs.c
> > > @@ -295,7 +295,9 @@ static ssize_t deep_flush_store(struct device *dev,
> > > struct device_attribute *att
> > >                 return rc;
> > >         if (!flush)
> > >                 return -EINVAL;
> > > -       nvdimm_flush(nd_region);
> > > +       rc = nvdimm_flush(nd_region, NULL, false);
> > > +       if (rc)
> > > +               return rc;
> > >
> > >         return len;
> > >  }
> > > @@ -1085,6 +1087,11 @@ static struct nd_region *nd_region_create(struct
> > > nvdimm_bus *nvdimm_bus,
> > >         dev->of_node = ndr_desc->of_node;
> > >         nd_region->ndr_size = resource_size(ndr_desc->res);
> > >         nd_region->ndr_start = ndr_desc->res->start;
> > > +       if (ndr_desc->flush)
> > > +               nd_region->flush = ndr_desc->flush;
> > > +       else
> > > +               nd_region->flush = generic_nvdimm_flush;
> > > +
> > >         nd_device_register(dev);
> > >
> > >         return nd_region;
> > > @@ -1125,11 +1132,36 @@ struct nd_region
> > > *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
> > >  }
> > >  EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
> > >
> > > +int nvdimm_flush(struct nd_region *nd_region, struct bio *bio, bool async)
> > > +{
> >
> > I don't quite see the point of the 'async' argument. All the usages of
> > this routine are either
> >
> > nvdimm_flush(nd_region, bio, true)
> > ...or:
> > nvdimm_flush(nd_region, NULL, false)
>
> Agree.
>
> >
> > ...so why not gate async behavior on the presence of the 'bio' argument?
>
> Sure.
>
> >
> >
> > > +       int rc = 0;
> > > +
> > > +       /* Create child bio for asynchronous flush and chain with
> > > +        * parent bio. Otherwise directly call nd_region flush.
> > > +        */
> > > +       if (async && bio->bi_iter.bi_sector != -1) {
> > > +
> > > +               struct bio *child = bio_alloc(GFP_ATOMIC, 0);
> > > +
> > > +               if (!child)
> > > +                       return -ENOMEM;
> > > +               bio_copy_dev(child, bio);
> > > +               child->bi_opf = REQ_PREFLUSH;
> > > +               child->bi_iter.bi_sector = -1;
> > > +               bio_chain(child, bio);
> > > +               submit_bio(child);
> >
> > I understand how this works, but it's a bit too "magical" for my
> > taste. I would prefer that all flush implementations take an optional
> > 'bio' argument rather than rely on the make_request implementation to
> > stash the bio away on a driver specific list.
>
> I did this to make use of "bio_chain" for chaining child bio for async flush
> suggested [1]. Are you saying to remove this and just call "flush" based on
> bio argument? Or I implemented the 'bio_chain' request entirely wrong?

No, I think you implemented it correctly. I'm just asking for the
chaining to be performed internal to the ->flush() callback rather
than in the common nvdimm_flush() front-end.
