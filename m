Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8DCC10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 18:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B051D20675
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 18:15:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="ktsdaFbH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404127AbfDRSPO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 14:15:14 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33898 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391146AbfDRSPM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2019 14:15:12 -0400
Received: by mail-ot1-f66.google.com with SMTP id k21so2491830otf.1
        for <linux-ext4@vger.kernel.org>; Thu, 18 Apr 2019 11:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNvcYTnY3+vvHUTxTkoLoLivaNOP88tmLELkxGdG9NU=;
        b=ktsdaFbHHTTd3R9uOez0tgfH91piu1Xl5DlUQg9AdDFLkPBDJI5BaCJt8wdik0yC9L
         dH1VUAIEKpMOG3eMgmYm1jbHjjxODglk6p70vY9qXowThleT7Q0gQUDAJS9MA3j7Y9lF
         v8ZxpajT9Rk0mPmn47Onvt24QMYIumY0g4+EJAIXZlXQcKxDlrzTO/b2iH+eG5vkZQVH
         ouopY1EtaMEeFiq04GySGtlZKge2N6IsV7o1pM7Je/rREB1BqCRPzbORKPO8w/0MElm/
         Opf6d01RSEY9uEf/J9C9GZzgTb2wZrkTq4GMtT+Dl+3EhN2pMqMJwWjbjUxgrKq+DhMm
         CmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNvcYTnY3+vvHUTxTkoLoLivaNOP88tmLELkxGdG9NU=;
        b=c5BGOCn9uF6VQkYaja0TmCfU98aJH/MbbIQ9I0xZYCgQlIbtFPIOTSM4M7pDv1Qt+s
         j4Bpq2jLgl+M1hsoIsErxcF+yqQdsy2B0XyJYJBQkCfnpIM1larmdOYjTC0qRIClddgI
         Gko/mlQ2FbTrGDsfpHTu+X6pdIHFv9iVPpgPTrk3xyy885S/KU4eY21Uc30ehLtVVg3F
         3LSHJIozvgKtv/0mCuWKirbczqbV+BKaPzXEAXdkq3yVj30yoIhNqpdwxRE08rjFOegz
         zwNx15/gp4zaUEzlVRCLIDY+gZc6zrmQhotLN7xOVfdN2AhfmHAAQrAzrWb9HgYdbEoV
         HbiA==
X-Gm-Message-State: APjAAAXc+WZxFRMlXcNVFecRNuv47t9y99ixdzz0Nt1lFmhBFK5tk448
        ST7JJ0Komph8jyJXIpyNt2P5bjzoxbiLn3BeYdrSzQ==
X-Google-Smtp-Source: APXvYqw+Y0/Df9bqsKP+vBWmJnbCdRcBlSHVgj/brP9uo3QhMkPjrQhjEhP/44UfrxTt+scRqmIZz03SqgCzRGRlQNI=
X-Received: by 2002:a05:6830:15d4:: with SMTP id j20mr4679415otr.367.1555611312059;
 Thu, 18 Apr 2019 11:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190410040826.24371-1-pagupta@redhat.com> <20190410040826.24371-2-pagupta@redhat.com>
 <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
 <20190412083230.GA29850@quack2.suse.cz> <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jrNHqW3FuGkeo==ZoJr7LKahCv4_esnokfy7enek8=2Q@mail.gmail.com> <20190418161833.GA22970@infradead.org>
In-Reply-To: <20190418161833.GA22970@infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 18 Apr 2019 11:14:59 -0700
Message-ID: <CAPcyv4jPOF_+R6U17J_+88+X8LC-LSPCugA6gbKxuphuuFB2gg@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] libnvdimm: nd_region flush callback support
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>,
        Pankaj Gupta <pagupta@redhat.com>,
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

On Thu, Apr 18, 2019 at 9:18 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Apr 18, 2019 at 09:05:05AM -0700, Dan Williams wrote:
> > > > I'd either add a comment about avoiding retpoline overhead here or just
> > > > make ->flush == NULL mean generic_nvdimm_flush(). Just so that people don't
> > > > get confused by the code.
> > >
> > > Isn't this premature optimization?  I really don't like adding things
> > > like this without some numbers to show it's worth it.
> >
> > I don't think it's premature given this optimization technique is
> > already being deployed elsewhere, see:
> >
> > https://lwn.net/Articles/774347/
>
> For one this one was backed by numbers, and second after feedback
> from Linux we switched to the NULL pointer check instead.

Ok I should have noticed the switch to NULL pointer check. However,
the question still stands do we want everyone to run numbers to
justify this optimization, or make it a new common kernel coding
practice to do:

    if (!object->op)
        generic_op(object);
    else
        object->op(object);

...in hot paths? I agree with not doing premature optimization in
principle, but this hack is minimally intrusive from a readability
perspective similar to likely()/unlikely() usage which also don't come
with numbers on a per patch basis.
