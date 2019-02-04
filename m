Return-Path: <SRS0=rNbD=QL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F2AC282CC
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Feb 2019 22:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF5952083B
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Feb 2019 22:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbfBDW44 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Feb 2019 17:56:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46510 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbfBDW44 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 4 Feb 2019 17:56:56 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7CA0259440;
        Mon,  4 Feb 2019 22:56:55 +0000 (UTC)
Received: from redhat.com (ovpn-116-138.sin2.redhat.com [10.67.116.138])
        by smtp.corp.redhat.com (Postfix) with SMTP id 857B7451D;
        Mon,  4 Feb 2019 22:56:25 +0000 (UTC)
Date:   Mon, 4 Feb 2019 17:56:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org,
        linux-fsdevel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, jack@suse.cz, stefanha@redhat.com,
        dan.j.williams@intel.com, riel@surriel.com, nilal@redhat.com,
        kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org,
        vishal.l.verma@intel.com, dave.jiang@intel.com, david@redhat.com,
        jmoyer@redhat.com, xiaoguangrong.eric@gmail.com, hch@infradead.org,
        jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com,
        eblake@redhat.com, willy@infradead.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, darrick.wong@oracle.com,
        rjw@rjwysocki.net, Andrea Arcangeli <aarcange@redhat.com>
Subject: security implications of caching with virtio pmem (was Re: [PATCH v3
 0/5] kvm "virtio pmem" device)
Message-ID: <20190204170515-mutt-send-email-mst@kernel.org>
References: <20190109144736.17452-1-pagupta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109144736.17452-1-pagupta@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 04 Feb 2019 22:56:56 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On Wed, Jan 09, 2019 at 08:17:31PM +0530, Pankaj Gupta wrote:
>  This patch series has implementation for "virtio pmem". 
>  "virtio pmem" is fake persistent memory(nvdimm) in guest 
>  which allows to bypass the guest page cache. This also
>  implements a VIRTIO based asynchronous flush mechanism.  


At Pankaj's request I looked at information leak implications of virtio
pmem in light of the recent page cache side channels paper
(https://arxiv.org/pdf/1901.01161.pdf) - to see what
kind of side channels it might create if any.  TLDR - I think that
depending on the host side implementation there could be some, but this
might be addressable by better documentation in both code and spec.
The fake dax approach backing the guest memory by a host page cache
does seem to have potential issues.

For clarity: we are talking about leaking information either to a VM, or
within a VM (I did not look into leaks to hypervisor in configurations
such as SEV) through host page cache.

Leaks into a VM: It seems clear that while pmem allows memory accesses
versus read/write with e.g. a block device, from host page cache point
of view this doesn't matter much: reads populate cache in the same way
as memory faults.  Thus ignoring presence of information leaks (which is
an interesting question e.g. in light of recent discard support) pmem
doesn't seem to be any better or worse for leaking information into a
VM.

Leaks within VM: Right now pmem seems to bypass the guest page cache
completely.  Whether pmem memory is then resident in a page cache would
be up to the device/host. Assuming that it is, the "Preventing
Efficient Eviction while Increasing the System Performance"
countermeasure for the page cache side channel attack would appear to
become ineffective with pmem. What is suggested is a per-process
management of the page cache, and host does not have visibility of
processes within a VM. Another possible countermeasure - not discussed
in the paper - could be modify the applications to lock the security
relevant pages in memory.  Again this becomes impractical with pmem as
host does not have visibility into that. However note that as long
as the only countermeasure linux uses is "Privileged Access"
(i.e. blocking mincore) nothing can be done as guest page cache
remains as vulnerable as host page cache.


Countermeasures: which host-side countermeasures can be designed would
depend on which countermeasures are used guest-side - we would need to
make sure they are not broken by pmem.  For "Preventing Efficient
Eviction while Increasing the System Performance" modifying the host
implementation to ensure that pmem device bypasses the host page cache
would seem to address the security problem.Similarly, ensuring that a
real memory device (e.g. DAX, RAM such as hugetlbfs, pmem for nested
virt) is used for pmem would make the memory locking countermeasure
work.  Whether with such limitations the device is still useful
performance wise is an open question.  These questions probably should
be addressed in the documentation, spec and possible qemu code.



Severity of the security implications: some people argue that the
security implications of the page cache leaks are minor.  I do not have
an opinion on this: the severity would seem to depend on the specific
configuration.


Other security implications: recent discussion seems to suggest there
are other concerns around e.g. resource management and thus DOS
potential. If that's so, it's a matter for a separate discussion
as I didn't look into that in depth.

Some or all of the above might be based on a misunderstanding of the
current pmem code, the whitepaper and linux page cache in general.
If so I apologise, do not hesitate to call out any mistakes.

Thanks!

-- 
MST
