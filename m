Return-Path: <SRS0=f4LO=SY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D238C282CE
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 20:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60709204EC
	for <linux-ext4@archiver.kernel.org>; Mon, 22 Apr 2019 20:06:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="MZnMJSvs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbfDVUGS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:06:18 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39826 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729487AbfDVToc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Apr 2019 15:44:32 -0400
Received: by mail-oi1-f193.google.com with SMTP id n187so9377326oih.6
        for <linux-ext4@vger.kernel.org>; Mon, 22 Apr 2019 12:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=be6f2f0XIlqFU7RHgEDNHdFLaZKAoDs5ON2xf3GreVs=;
        b=MZnMJSvszGOJ69yW2f92BRR2//4YgYRkKKac5Gqy7Awh1bsWzu6rOOSWtZwJtx/tcG
         eDw1eDkllfmunatVZlfYdB6E/H0sEhYx56nkD9/3BTyiQhK1cK3ohxtnncyN808QU9Ip
         EHjb1faIflXV5qJO4U85TcW+zBgo6JUqMcJpYrNghYuo1YIWP/jnyZ0my2UTfw52gR0p
         0x1xVJYtgpLLMZiiVV2/R/giaXcjlq2VvA7Z8shcCNAngnJ6VI6G+ScfLPtwzKJEy1HA
         MzWZ1/YUvj5/eXdhJA+Ieta7O8ADe/tnz1YT0d9DikYe3aJrHMlfOTBTM/lY7uViDVxI
         lLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=be6f2f0XIlqFU7RHgEDNHdFLaZKAoDs5ON2xf3GreVs=;
        b=AWhRRievlhBC/RND9Xe2h5k5JDYJjPXfGDzHv2U39IUOwqwQVIEwrjOdoVuTH2viwG
         au+JoM+m5hAvOL7XjkqynhsPVm7zigMMZuW+8z/Y0n69y35FDgyJSYlx1Yv/ZF8LNo2Y
         bwkBFrsoX6uoO9nNApUxnyTXMZzerxk7p3J/vg4Te7KB69jE0x7cN/KS4Z7SR8T4lvBm
         nc+CvBU15mMlF9KlkK/l6pyswL8N7m1XP/Zt9RcVeUGYUc/e/WMXBl99f6pmelWZy1pX
         n9bm4BmpvbyH/wKmo8idENISNsMql8gajcREeWvBj4jIE/irPZ0DZ7IyaGUMy0bKcX03
         ps/w==
X-Gm-Message-State: APjAAAVi2gTrn1YFAekKXnyUuyIXyAUJinE2emMisow0p+ifTxHzZdvM
        Fu4VeofvB6G7BovmeVgL7UyxhYMd33xLNS2FujFhEg==
X-Google-Smtp-Source: APXvYqy9oEwsfMU6Hmi4yVBnW8LZ4gUZmwS+KAWSnUmv484C2kN850KPfxFBG55AG8ix9yht3mk81r/aARykAzdCsRE=
X-Received: by 2002:aca:f581:: with SMTP id t123mr11818692oih.0.1555962272101;
 Mon, 22 Apr 2019 12:44:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190410040826.24371-1-pagupta@redhat.com> <20190410040826.24371-2-pagupta@redhat.com>
 <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
 <20190412083230.GA29850@quack2.suse.cz> <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jrNHqW3FuGkeo==ZoJr7LKahCv4_esnokfy7enek8=2Q@mail.gmail.com>
 <20190418161833.GA22970@infradead.org> <CAPcyv4jPOF_+R6U17J_+88+X8LC-LSPCugA6gbKxuphuuFB2gg@mail.gmail.com>
 <x497ebm82d4.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x497ebm82d4.fsf@segfault.boston.devel.redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 22 Apr 2019 12:44:21 -0700
Message-ID: <CAPcyv4gGmN2LLMPy6BzWpYhRyV7fFNVgh=xAWSAdnnAWu5APtg@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] libnvdimm: nd_region flush callback support
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
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

On Mon, Apr 22, 2019 at 8:59 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > On Thu, Apr 18, 2019 at 9:18 AM Christoph Hellwig <hch@infradead.org> wrote:
> >>
> >> On Thu, Apr 18, 2019 at 09:05:05AM -0700, Dan Williams wrote:
> >> > > > I'd either add a comment about avoiding retpoline overhead here or just
> >> > > > make ->flush == NULL mean generic_nvdimm_flush(). Just so that people don't
> >> > > > get confused by the code.
> >> > >
> >> > > Isn't this premature optimization?  I really don't like adding things
> >> > > like this without some numbers to show it's worth it.
> >> >
> >> > I don't think it's premature given this optimization technique is
> >> > already being deployed elsewhere, see:
> >> >
> >> > https://lwn.net/Articles/774347/
> >>
> >> For one this one was backed by numbers, and second after feedback
> >> from Linux we switched to the NULL pointer check instead.
> >
> > Ok I should have noticed the switch to NULL pointer check. However,
> > the question still stands do we want everyone to run numbers to
> > justify this optimization, or make it a new common kernel coding
> > practice to do:
> >
> >     if (!object->op)
> >         generic_op(object);
> >     else
> >         object->op(object);
> >
> > ...in hot paths?
>
> I don't think nvdimm_flush is a hot path.  Numbers of some
> representative workload would prove one of us right.

I'd rather say that the if "if (!op) do_generic()" pattern is more
readable in the general case, saves grepping for who set the op in the
common case. The fact that it has the potential to be faster is gravy
at that point.
