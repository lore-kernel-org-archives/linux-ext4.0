Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45A2C10F14
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 14:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAEC320850
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 14:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbfDJOcO (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 10:32:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732287AbfDJOcO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 10:32:14 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E98103082E0F;
        Wed, 10 Apr 2019 14:32:03 +0000 (UTC)
Received: from gondolin (ovpn-204-33.brq.redhat.com [10.40.204.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E921F19C7E;
        Wed, 10 Apr 2019 14:31:43 +0000 (UTC)
Date:   Wed, 10 Apr 2019 16:31:39 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, jack@suse.cz,
        kvm@vger.kernel.org, david@redhat.com, jasowang@redhat.com,
        david@fromorbit.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org,
        aarcange@redhat.com, dave jiang <dave.jiang@intel.com>,
        linux-nvdimm@lists.01.org,
        vishal l verma <vishal.l.verma@intel.com>,
        willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org,
        jmoyer@redhat.com, linux-ext4@vger.kernel.org, lenb@kernel.org,
        kilobyte@angband.pl, riel@surriel.com,
        yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com,
        pbonzini@redhat.com, dan j williams <dan.j.williams@intel.com>,
        lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com,
        tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>,
        darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, imammedo@redhat.com
Subject: Re: [Qemu-devel] [PATCH v5 2/5] virtio-pmem: Add virtio pmem driver
Message-ID: <20190410163139.4a04175e.cohuck@redhat.com>
In-Reply-To: <127904196.20807948.1554904981681.JavaMail.zimbra@redhat.com>
References: <20190410040826.24371-1-pagupta@redhat.com>
        <20190410040826.24371-3-pagupta@redhat.com>
        <20190410091216-mutt-send-email-mst@kernel.org>
        <127904196.20807948.1554904981681.JavaMail.zimbra@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 10 Apr 2019 14:32:14 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, 10 Apr 2019 10:03:01 -0400 (EDT)
Pankaj Gupta <pagupta@redhat.com> wrote:

> > 
> > On Wed, Apr 10, 2019 at 09:38:22AM +0530, Pankaj Gupta wrote:  
> > > This patch adds virtio-pmem driver for KVM guest.
> > > 
> > > Guest reads the persistent memory range information from
> > > Qemu over VIRTIO and registers it on nvdimm_bus. It also
> > > creates a nd_region object with the persistent memory
> > > range information so that existing 'nvdimm/pmem' driver
> > > can reserve this into system memory map. This way
> > > 'virtio-pmem' driver uses existing functionality of pmem
> > > driver to register persistent memory compatible for DAX
> > > capable filesystems.
> > > 
> > > This also provides function to perform guest flush over
> > > VIRTIO from 'pmem' driver when userspace performs flush
> > > on DAX memory range.
> > > 
> > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>

> > > diff --git a/include/uapi/linux/virtio_ids.h
> > > b/include/uapi/linux/virtio_ids.h
> > > index 6d5c3b2d4f4d..346389565ac1 100644
> > > --- a/include/uapi/linux/virtio_ids.h
> > > +++ b/include/uapi/linux/virtio_ids.h
> > > @@ -43,5 +43,6 @@
> > >  #define VIRTIO_ID_INPUT        18 /* virtio input */
> > >  #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
> > >  #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
> > > +#define VIRTIO_ID_PMEM         25 /* virtio pmem */
> > >  
> > >  #endif /* _LINUX_VIRTIO_IDS_H */  
> > 
> > Didn't Paolo point out someone is using 25 for audio?  
> 
> 
> Sorry! I did not notice this.
> 
> > 
> > Please, reserve an ID with the Virtio TC before using it.  
> 
> I thought I requested[1] ID 25.
> 
> [1] https://github.com/oasis-tcs/virtio-spec/issues/38
> [2] https://lists.oasis-open.org/archives/virtio-dev/201805/threads.html
> 
> In that case I will send request for next available ID i.e 26?

Have the folks using this for audio sent a reservation request as well?
If not, I'd say the first requester should get the id...

(And yes, we need to be quicker with voting on/applying id
reservations :/)
