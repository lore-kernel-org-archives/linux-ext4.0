Return-Path: <SRS0=aCZM=QN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B41C4151A
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Feb 2019 14:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB0A820844
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Feb 2019 14:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbfBFOAm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Feb 2019 09:00:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfBFOAm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 6 Feb 2019 09:00:42 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 473DE89AE4;
        Wed,  6 Feb 2019 14:00:40 +0000 (UTC)
Received: from [10.36.117.191] (ovpn-117-191.ams2.redhat.com [10.36.117.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D04527065;
        Wed,  6 Feb 2019 14:00:27 +0000 (UTC)
Subject: Re: security implications of caching with virtio pmem (was Re: [PATCH
 v3 0/5] kvm "virtio pmem" device)
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-nvdimm@ml01.01.org,
        linux-fsdevel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, jack@suse.cz, stefanha@redhat.com,
        dan.j.williams@intel.com, riel@surriel.com, nilal@redhat.com,
        kwolf@redhat.com, pbonzini@redhat.com, zwisler@kernel.org,
        vishal.l.verma@intel.com, dave.jiang@intel.com, jmoyer@redhat.com,
        xiaoguangrong.eric@gmail.com, hch@infradead.org,
        jasowang@redhat.com, lcapitulino@redhat.com, imammedo@redhat.com,
        eblake@redhat.com, willy@infradead.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, darrick.wong@oracle.com,
        rjw@rjwysocki.net, Andrea Arcangeli <aarcange@redhat.com>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <20190204170515-mutt-send-email-mst@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <5b8a06a7-be44-698f-f319-6b2cbcf1eb8a@redhat.com>
Date:   Wed, 6 Feb 2019 15:00:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190204170515-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 06 Feb 2019 14:00:41 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 04.02.19 23:56, Michael S. Tsirkin wrote:
> 
> On Wed, Jan 09, 2019 at 08:17:31PM +0530, Pankaj Gupta wrote:
>>  This patch series has implementation for "virtio pmem". 
>>  "virtio pmem" is fake persistent memory(nvdimm) in guest 
>>  which allows to bypass the guest page cache. This also
>>  implements a VIRTIO based asynchronous flush mechanism.  
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

+1, just a different way to access that cache.

Conceptually a virtio-pmem devices is from the guest view a "device with
a managed buffer". Some accesses might be faster than others. There are
no guarantees on how fast a certain access is. And yes, actions on other
guests can result in accesses being slower but not faster.

Also other storage devices have caches like that (well, the caches size
depends on the device) - thinking especially about storage systems -
which would in my opinion, also allow similar leaks. How are such
security concerns handled there? Are they different (besides eventually
access speed)?

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

This sounds very use-case specific. If I run a VM only with a very
specific workload (say, a container running one application), I usually
don't care about leaks within the VM. At least not leaks between
applications ;)

In contrast, to running different applications (e.g. containers from
different customers) on one system, I really care about leaks within a VM.

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
I also want to note that using a disk/file as memory backend with
NVDIMMs in QEMU essentially results in the exact same questions we have
with virtio-pmem.

E.g. kata-containers use nvdimms for the rootfile system (read-only) as
far as I am aware.

Conceptually, a virtio-pmem device is just an emulated nvdimm device
with a flush interface. And the nice thing is, that it is designed to
also work on architectures that don't speak "nvdimm".

> 
> Severity of the security implications: some people argue that the
> security implications of the page cache leaks are minor.  I do not have
> an opinion on this: the severity would seem to depend on the specific
> configuration.

I guess configuration and use case.

Nice summary, thanks for looking into this Michael!


-- 

Thanks,

David / dhildenb
