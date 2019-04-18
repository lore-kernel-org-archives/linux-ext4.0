Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BB3C10F14
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 16:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A71320693
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 16:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="ATWDxkO+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389495AbfDRQFS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 12:05:18 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42032 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388819AbfDRQFS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2019 12:05:18 -0400
Received: by mail-oi1-f194.google.com with SMTP id w139so1997544oie.9
        for <linux-ext4@vger.kernel.org>; Thu, 18 Apr 2019 09:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9656FNKKp4cUVga3XUcreKMqWUBjOMnkCExkfsBvcE0=;
        b=ATWDxkO+EzohN5YWedA5OnfOl7z0C5wosAmTrDF5hxxtYtjNdCK/9PHgnZhYETJJ8t
         vacr+rHkJxxNGOmeI1vTif1Vl4SIwdCSz21szdtTalMtQ8a/1Obxe+VdKwZnY8xrFtd+
         ciBIJxCm9FZlAQVPiOTKZr8Xdghbnp/hQTXS/ucudKTmB79U11kjETh4fqNlfW3T1gK0
         Zu87he2RHQTC+AM19urSAzmn3PITVUqT2oXHTybHWlpO7u1bFfMxyXZLHVTzCvZ6mXjc
         bD19cp4gsnL0R2s/7Y3bFqcAI2a5/xvDNGJEJYE3ed3iSmhC+ui2TozfrYHnQqDdah3m
         ZD3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9656FNKKp4cUVga3XUcreKMqWUBjOMnkCExkfsBvcE0=;
        b=lcTZh0oggvTAnqhJNcCIZbAZRyayZ5uzRV7meUBHaaHkOxjGP1oO82c6GHBkY7ZRYI
         cjvC5bnjWKNC80RX6BTGInAiZyretVh2qV1uo1HiHapi/R6MEt4e71rVKlYNX7JBYzJi
         3iT4PLMbbMc+xBkfyXv9ooGzi2H2Q8+HOwnAb4HxEf7RoKvogrYqhNFtNXJ6MCz4zCEe
         NU3RXKl5t4e9r1kRV6vNn8n0g13DnjM0LbADUBI4SYS9H44RAGByRThDTmAyJZWY5SpF
         gRd7KeIDlZpsIRYBmAya5YqFfs28w0m9c4RM3ihxv1UvQBkd5jlJWPnOoXW906dyzcFx
         qDfw==
X-Gm-Message-State: APjAAAW5jwq2cXUAVOTZGbMMaSczx+TUyP8thWKBC9B7O3MKDkLJoRhg
        Anv6d21IT41oIxBtv1rcn5+qhAeVfypHpAZVKntXuw==
X-Google-Smtp-Source: APXvYqzTGVz9ejtUV0liyJEyYqaIHrUyuHEbCYPG5pgMNrA7E3qjZWVF7XUM3SvNiTSOlLSiE2pi4l5w04d9dnUuvxA=
X-Received: by 2002:aca:ed88:: with SMTP id l130mr2422676oih.70.1555603517276;
 Thu, 18 Apr 2019 09:05:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190410040826.24371-1-pagupta@redhat.com> <20190410040826.24371-2-pagupta@redhat.com>
 <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
 <20190412083230.GA29850@quack2.suse.cz> <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 18 Apr 2019 09:05:05 -0700
Message-ID: <CAPcyv4jrNHqW3FuGkeo==ZoJr7LKahCv4_esnokfy7enek8=2Q@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] libnvdimm: nd_region flush callback support
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     Jan Kara <jack@suse.cz>, Pankaj Gupta <pagupta@redhat.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
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
        Len Brown <lenb@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        david <david@fromorbit.com>, cohuck@redhat.com,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kilobyte@angband.pl,
        yuval shaia <yuval.shaia@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Apr 12, 2019 at 6:12 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Jan Kara <jack@suse.cz> writes:
>
> > On Thu 11-04-19 07:51:48, Dan Williams wrote:
> >> On Tue, Apr 9, 2019 at 9:09 PM Pankaj Gupta <pagupta@redhat.com> wrote:
> >> > +       } else {
> >> > +               if (nd_region->flush(nd_region))
> >> > +                       rc = -EIO;
> >>
> >> Given the common case wants to be fast and synchronous I think we
> >> should try to avoid retpoline overhead by default. So something like
> >> this:
> >>
> >> if (nd_region->flush == generic_nvdimm_flush)
> >>     rc = generic_nvdimm_flush(...);
> >
> > I'd either add a comment about avoiding retpoline overhead here or just
> > make ->flush == NULL mean generic_nvdimm_flush(). Just so that people don't
> > get confused by the code.
>
> Isn't this premature optimization?  I really don't like adding things
> like this without some numbers to show it's worth it.

I don't think it's premature given this optimization technique is
already being deployed elsewhere, see:

https://lwn.net/Articles/774347/
