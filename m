Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5D5C10F14
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 16:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C4A0206B6
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 16:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UQuK3DBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389726AbfDRQSl (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 12:18:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389016AbfDRQSl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2019 12:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oSiywyWZOOkDew8YDIRL2lgfYPRWYKSt6r/K8nAvB38=; b=UQuK3DBWUvS3ekW0bjE1qVo6+
        MJzsQy6sTGxK00p7qVJ4VFtC1fWyQ7xuIglmmJFdYRHtDzE+aNGMdNRLf3HLnPAOBrQLtgfLLqXkV
        roN4AQhtKnlTNAuwf8sTOFq6GZl/ptQS0UKstolaRecDOv644T1QMJ8t9ODMIMUpcOjuj03JuDO2M
        1AG97LDrgEDRf5sUoXXV25MqNc5qhJpMQ2DK1Hb9Na19ziCgs8b4jrtYlU/QZ65chrvNKLIkN25d5
        G1A3jBOm1AnpyhDDKhTNYMIfJFehyF56uHA5kl+sfAvNUyUKy4MQiZcM5LNHgtyUhIbKJDR3z9iiu
        BnpM8rboA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hH9kA-0006UQ-C7; Thu, 18 Apr 2019 16:18:34 +0000
Date:   Thu, 18 Apr 2019 09:18:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
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
        Christoph Hellwig <hch@infradead.org>,
        Len Brown <lenb@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
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
Subject: Re: [PATCH v5 1/6] libnvdimm: nd_region flush callback support
Message-ID: <20190418161833.GA22970@infradead.org>
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-2-pagupta@redhat.com>
 <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
 <20190412083230.GA29850@quack2.suse.cz>
 <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jrNHqW3FuGkeo==ZoJr7LKahCv4_esnokfy7enek8=2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jrNHqW3FuGkeo==ZoJr7LKahCv4_esnokfy7enek8=2Q@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 18, 2019 at 09:05:05AM -0700, Dan Williams wrote:
> > > I'd either add a comment about avoiding retpoline overhead here or just
> > > make ->flush == NULL mean generic_nvdimm_flush(). Just so that people don't
> > > get confused by the code.
> >
> > Isn't this premature optimization?  I really don't like adding things
> > like this without some numbers to show it's worth it.
> 
> I don't think it's premature given this optimization technique is
> already being deployed elsewhere, see:
> 
> https://lwn.net/Articles/774347/

For one this one was backed by numbers, and second after feedback
from Linux we switched to the NULL pointer check instead.
