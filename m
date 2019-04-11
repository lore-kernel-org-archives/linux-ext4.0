Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192F4C282CE
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 14:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDAC02077C
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 14:52:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="zi4I18XM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfDKOwB (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Apr 2019 10:52:01 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44382 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfDKOwA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2019 10:52:00 -0400
Received: by mail-ot1-f68.google.com with SMTP id d24so5441299otl.11
        for <linux-ext4@vger.kernel.org>; Thu, 11 Apr 2019 07:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HrHI1yUQh4ijcB7YHVwA9JPy3wKlBzvWJG6Efesd/f0=;
        b=zi4I18XMGtYXeCFOI7IgUdbB0EOZdbnJeoa3l20X2Gqlcl0YR55UhU5luYmUa6cHU5
         EqcmShYr64nYFlNtn7Rd+1lIJH9XABBmZCQPUOavNMLs+0n9I8m1OuY2+KD0JtN93YcX
         3rvvNLyeug/w5aNDC5fj4CjwQPXARfaplfRzq12KFQ4x2cbAHrzA+mENqSKh1c617RSg
         xlJAToPXjpLqe1zcSJodjCgmY5dhUdHQiVkQchFEI36jgwV1c+a/Zf73ibOfskPgdlC8
         PjhIrDB/UX3hLAtfZ9Gz/P0KisQxQ6VH57FKrSFjl+UerDKSD8YHx1TPbaLhBc3i7fUT
         dpzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HrHI1yUQh4ijcB7YHVwA9JPy3wKlBzvWJG6Efesd/f0=;
        b=eTX6qUVH13zhSIgP8ilk2Kl0r4ie1jLmug1X6e+zyVt4IyRv0QlgtsO9mJDEu/9EsC
         8Z5Z4wBZ/rB18B6PLMEseaGJL9zZCIwccojEOeIOPkDu3RMBhhXShxys02deXPypryV5
         8ndw+OQW7qGxwW2dA2rkAWVlVKdfUKX3dYa6+R+mdd8IthvKjncCLgOousIRwZ3NtS5J
         vz5M16W2CNgPs5ceDQP5wNpnPH20SLB5OuRYdgbJhH1tcfJHi8CuN7ajG8yIK1f5ufgn
         sx7tFP5O4KIDk+zrL3RB4B2mTMzx4oShQATH42coa++IvvTFP0DSbOYi//iGKBSTKPOZ
         X70w==
X-Gm-Message-State: APjAAAWzTqYBX78ICiWOVtz8meBX7wvXhkfNUz7GHavsxl2nv2JMKdPa
        PikolfWbEqmeztUai8mSqmbHk6ar4pQN5WMOiK4/Lg==
X-Google-Smtp-Source: APXvYqzmftlTRUTwhQDYzvgypbDnyLvMFUn2U/nKPouHN/rEyYp+JGo6QjH+KjaSpQBo5LMn3j6ZwzdKIOwlKbwUyTU=
X-Received: by 2002:a9d:3f4b:: with SMTP id m69mr32615377otc.246.1554994319729;
 Thu, 11 Apr 2019 07:51:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190410040826.24371-1-pagupta@redhat.com> <20190410040826.24371-2-pagupta@redhat.com>
In-Reply-To: <20190410040826.24371-2-pagupta@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 11 Apr 2019 07:51:48 -0700
Message-ID: <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] libnvdimm: nd_region flush callback support
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM list <kvm@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Ross Zwisler <zwisler@kernel.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Christoph Hellwig <hch@infradead.org>,
        Len Brown <lenb@kernel.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        jmoyer <jmoyer@redhat.com>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        david <david@fromorbit.com>, cohuck@redhat.com,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kilobyte@angband.pl,
        yuval.shaia@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 9, 2019 at 9:09 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>
> This patch adds functionality to perform flush from guest
> to host over VIRTIO. We are registering a callback based
> on 'nd_region' type. virtio_pmem driver requires this special
> flush function. For rest of the region types we are registering
> existing flush function. Report error returned by host fsync
> failure to userspace.
>
> This also handles asynchronous flush requests from the block layer
> by creating a child bio and chaining it with parent bio.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
[..]
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index b4ef7d9ff22e..fb1041ab32a6 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -295,7 +295,9 @@ static ssize_t deep_flush_store(struct device *dev, struct device_attribute *att
>                 return rc;
>         if (!flush)
>                 return -EINVAL;
> -       nvdimm_flush(nd_region);
> +       rc = nvdimm_flush(nd_region, NULL, false);
> +       if (rc)
> +               return rc;
>
>         return len;
>  }
> @@ -1085,6 +1087,11 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>         dev->of_node = ndr_desc->of_node;
>         nd_region->ndr_size = resource_size(ndr_desc->res);
>         nd_region->ndr_start = ndr_desc->res->start;
> +       if (ndr_desc->flush)
> +               nd_region->flush = ndr_desc->flush;
> +       else
> +               nd_region->flush = generic_nvdimm_flush;
> +
>         nd_device_register(dev);
>
>         return nd_region;
> @@ -1125,11 +1132,36 @@ struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
>  }
>  EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
>
> +int nvdimm_flush(struct nd_region *nd_region, struct bio *bio, bool async)
> +{

I don't quite see the point of the 'async' argument. All the usages of
this routine are either

nvdimm_flush(nd_region, bio, true)
...or:
nvdimm_flush(nd_region, NULL, false)

...so why not gate async behavior on the presence of the 'bio' argument?


> +       int rc = 0;
> +
> +       /* Create child bio for asynchronous flush and chain with
> +        * parent bio. Otherwise directly call nd_region flush.
> +        */
> +       if (async && bio->bi_iter.bi_sector != -1) {
> +
> +               struct bio *child = bio_alloc(GFP_ATOMIC, 0);
> +
> +               if (!child)
> +                       return -ENOMEM;
> +               bio_copy_dev(child, bio);
> +               child->bi_opf = REQ_PREFLUSH;
> +               child->bi_iter.bi_sector = -1;
> +               bio_chain(child, bio);
> +               submit_bio(child);

I understand how this works, but it's a bit too "magical" for my
taste. I would prefer that all flush implementations take an optional
'bio' argument rather than rely on the make_request implementation to
stash the bio away on a driver specific list.

> +       } else {
> +               if (nd_region->flush(nd_region))
> +                       rc = -EIO;

Given the common case wants to be fast and synchronous I think we
should try to avoid retpoline overhead by default. So something like
this:

if (nd_region->flush == generic_nvdimm_flush)
    rc = generic_nvdimm_flush(...);
