Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EDBC282CE
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 23:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAE322082F
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 23:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfBKXHR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 18:07:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbfBKXHQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 18:07:16 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FABB1B9C;
        Mon, 11 Feb 2019 23:07:16 +0000 (UTC)
Received: from redhat.com (ovpn-121-111.rdu2.redhat.com [10.10.121.111])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6B065101961F;
        Mon, 11 Feb 2019 23:07:02 +0000 (UTC)
Date:   Mon, 11 Feb 2019 18:07:02 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Pankaj Gupta <pagupta@redhat.com>, dchinner@redhat.com,
        jack@suse.cz, kvm@vger.kernel.org, linux-nvdimm@ml01.01.org,
        jasowang@redhat.com, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
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
        pbonzini@redhat.com
Subject: Re: [Qemu-devel] security implications of caching with virtio pmem
 (was Re: [PATCH v3 0/5] kvm "virtio pmem" device)
Message-ID: <20190211180449-mutt-send-email-mst@kernel.org>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <20190204170515-mutt-send-email-mst@kernel.org>
 <888328358.132676.1549870186945.JavaMail.zimbra@redhat.com>
 <20190211222907.GR14116@dastard>
 <b2be7796-9dee-b9fd-87e5-1ae570aa7db6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2be7796-9dee-b9fd-87e5-1ae570aa7db6@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 11 Feb 2019 23:07:16 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 11, 2019 at 11:58:15PM +0100, David Hildenbrand wrote:
> On 11.02.19 23:29, Dave Chinner wrote:
> > On Mon, Feb 11, 2019 at 02:29:46AM -0500, Pankaj Gupta wrote:
> >> Hello Dave,
> >> Are we okay with this?
> > 
> > Sure.
> > 
> > I'm not sure I agree with all the analysis presented, but, well, I
> > haven't looked any deeper because I'm tired of being shouted at and
> > being called argumentative for daring to ask hard questions about
> > this topic....
> 
> I think if you have concerns, they should definitely be discussed.
> Making people frustrated that review code is not what we want. Not at all.
> 
> I suggest that Pankaj properly documents what we found out so far about
> security concerns and properly describes intended use cases and answers
> other questions you had in the cover letter / documentation of the
> follow up series.
> 
> Thanks Dave!

Right. Also, there's an open question that you posed:
	Also other storage devices have caches like that (well, the caches size
	depends on the device) - thinking especially about storage systems -
	which would in my opinion, also allow similar leaks. How are such
	security concerns handled there? Are they different (besides eventually
	access speed)?
and that needs some looking into, and reporting on.


> > 
> > Cheers,
> > 
> > Dave.
> > 
> 
> 
> -- 
> 
> Thanks,
> 
> David / dhildenb
