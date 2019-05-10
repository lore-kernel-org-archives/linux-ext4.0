Return-Path: <SRS0=F0j0=TK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23A7C04A6B
	for <linux-ext4@archiver.kernel.org>; Fri, 10 May 2019 23:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D265217F5
	for <linux-ext4@archiver.kernel.org>; Fri, 10 May 2019 23:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfEJXdG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 10 May 2019 19:33:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbfEJXdG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 10 May 2019 19:33:06 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5778B81DEB;
        Fri, 10 May 2019 23:33:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C15C86013A;
        Fri, 10 May 2019 23:33:04 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id E768741F56;
        Fri, 10 May 2019 23:33:03 +0000 (UTC)
Date:   Fri, 10 May 2019 19:33:03 -0400 (EDT)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
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
        Theodore Ts'o <tytso@mit.edu>,
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
        Paolo Bonzini <pbonzini@redhat.com>,
        Adam Borowski <kilobyte@angband.pl>,
        yuval shaia <yuval.shaia@oracle.com>, jstaron@google.com
Message-ID: <1909759746.28039539.1557531183427.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAPcyv4joEZaePvzc__N9Q3nozoHgQn7hNFPjBVo5BP6cc4rkEA@mail.gmail.com>
References: <20190510155202.14737-1-pagupta@redhat.com> <CAPcyv4joEZaePvzc__N9Q3nozoHgQn7hNFPjBVo5BP6cc4rkEA@mail.gmail.com>
Subject: Re: [PATCH v8 0/6] virtio pmem driver
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.116.14, 10.4.195.9]
Thread-Topic: virtio pmem driver
Thread-Index: rsQ5JHWz0G3j576+ZiuD0XgeGIYzZQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 10 May 2019 23:33:05 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


> >
> >  Hi Michael & Dan,
> >
> >  Please review/ack the patch series from LIBNVDIMM & VIRTIO side.
> >  We have ack on ext4, xfs patches(4, 5 & 6) patch 2. Still need
> >  your ack on nvdimm patches(1 & 3) & virtio patch 2.
> 
> I was planning to merge these via the nvdimm tree, not ack them. Did
> you have another maintainer lined up to take these patches?

Sorry! for not being clear on this. I wanted to say same.

Proposed the patch series to be merged via nvdimm tree as kindly agreed
by you. We only need an ack on virtio patch 2 from Micahel.

Thank you for all your help.

Best regards,
Pankaj Gupta

> 
