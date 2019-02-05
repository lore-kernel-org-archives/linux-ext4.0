Return-Path: <SRS0=Sz5y=QM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C368C282CB
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 07:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4456720811
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 07:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfBEH3l (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Feb 2019 02:29:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbfBEH3k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 5 Feb 2019 02:29:40 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8362537E88;
        Tue,  5 Feb 2019 07:29:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B825C5C3FD;
        Tue,  5 Feb 2019 07:29:38 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id A3D631803399;
        Tue,  5 Feb 2019 07:29:37 +0000 (UTC)
Date:   Tue, 5 Feb 2019 02:29:37 -0500 (EST)
From:   Pankaj Gupta <pagupta@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jack@suse.cz, kvm@vger.kernel.org, david@redhat.com,
        linux-nvdimm@ml01.01.org, jasowang@redhat.com,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        dave jiang <dave.jiang@intel.com>,
        darrick wong <darrick.wong@oracle.com>,
        vishal l verma <vishal.l.verma@intel.com>,
        willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org,
        jmoyer@redhat.com, nilal@redhat.com, riel@surriel.com,
        stefanha@redhat.com, imammedo@redhat.com,
        dan j williams <dan.j.williams@intel.com>,
        lcapitulino@redhat.com, kwolf@redhat.com,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        xiaoguangrong eric <xiaoguangrong.eric@gmail.com>,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        pbonzini@redhat.com, david@fromorbit.com
Message-ID: <1689233487.69735950.1549351777236.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190204170515-mutt-send-email-mst@kernel.org>
References: <20190109144736.17452-1-pagupta@redhat.com> <20190204170515-mutt-send-email-mst@kernel.org>
Subject: Re: [Qemu-devel] security implications of caching with virtio pmem
 (was Re: [PATCH v3 0/5] kvm "virtio pmem" device)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.116.71, 10.4.195.4]
Thread-Topic: security implications of caching with virtio pmem (was Re: [PATCH v3 0/5] kvm "virtio pmem" device)
Thread-Index: PE0lJFO2AR8pBz0yufGpS4zVxO9J8A==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 05 Feb 2019 07:29:40 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


+CC [Dave Chinner], to maintain updated CC list  

> >  This patch series has implementation for "virtio pmem".
> >  "virtio pmem" is fake persistent memory(nvdimm) in guest
> >  which allows to bypass the guest page cache. This also
> >  implements a VIRTIO based asynchronous flush mechanism.
> 
> 
> At Pankaj's request I looked at information leak implications of virtio
> pmem in light of the recent page cache side channels paper
> (https://arxiv.org/pdf/1901.01161.pdf) - to see what
> kind of side channels it might create if any.  TLDR - I think that
> depending on the host side implementation there could be some, but this
> might be addressable by better documentation in both code and spec.
> The fake dax approach backing the guest memory by a host page cache
> does seem to have potential issues.
> 
> For clarity: we are talking about leaking information either to a VM, or
> within a VM (I did not look into leaks to hypervisor in configurations
> such as SEV) through host page cache.
> 
> Leaks into a VM: It seems clear that while pmem allows memory accesses
> versus read/write with e.g. a block device, from host page cache point
> of view this doesn't matter much: reads populate cache in the same way
> as memory faults.  Thus ignoring presence of information leaks (which is
> an interesting question e.g. in light of recent discard support) pmem
> doesn't seem to be any better or worse for leaking information into a
> VM.
> 
> Leaks within VM: Right now pmem seems to bypass the guest page cache
> completely.  Whether pmem memory is then resident in a page cache would
> be up to the device/host. Assuming that it is, the "Preventing
> Efficient Eviction while Increasing the System Performance"
> countermeasure for the page cache side channel attack would appear to
> become ineffective with pmem. What is suggested is a per-process
> management of the page cache, and host does not have visibility of
> processes within a VM. Another possible countermeasure - not discussed
> in the paper - could be modify the applications to lock the security
> relevant pages in memory.  Again this becomes impractical with pmem as
> host does not have visibility into that. However note that as long
> as the only countermeasure linux uses is "Privileged Access"
> (i.e. blocking mincore) nothing can be done as guest page cache
> remains as vulnerable as host page cache.
> 
> 
> Countermeasures: which host-side countermeasures can be designed would
> depend on which countermeasures are used guest-side - we would need to
> make sure they are not broken by pmem.  For "Preventing Efficient
> Eviction while Increasing the System Performance" modifying the host
> implementation to ensure that pmem device bypasses the host page cache
> would seem to address the security problem.Similarly, ensuring that a
> real memory device (e.g. DAX, RAM such as hugetlbfs, pmem for nested
> virt) is used for pmem would make the memory locking countermeasure
> work.  Whether with such limitations the device is still useful
> performance wise is an open question.  These questions probably should
> be addressed in the documentation, spec and possible qemu code.
> 
> 
> 
> Severity of the security implications: some people argue that the
> security implications of the page cache leaks are minor.  I do not have
> an opinion on this: the severity would seem to depend on the specific
> configuration.
> 
> 
> Other security implications: recent discussion seems to suggest there
> are other concerns around e.g. resource management and thus DOS
> potential. If that's so, it's a matter for a separate discussion
> as I didn't look into that in depth.
> 
> Some or all of the above might be based on a misunderstanding of the
> current pmem code, the whitepaper and linux page cache in general.
> If so I apologise, do not hesitate to call out any mistakes.
> 
> Thanks!
> 
> --
> MST
> 
> 
