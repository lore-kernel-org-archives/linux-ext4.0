Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC68C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 22:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D1A22080F
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 22:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfBKW3M (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 17:29:12 -0500
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:21674 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726751AbfBKW3M (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 17:29:12 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail01.adl2.internode.on.net with ESMTP; 12 Feb 2019 08:59:08 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gtK4Z-0002IS-MO; Tue, 12 Feb 2019 09:29:07 +1100
Date:   Tue, 12 Feb 2019 09:29:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, dchinner@redhat.com,
        jack@suse.cz, kvm@vger.kernel.org, david@redhat.com,
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
        pbonzini@redhat.com
Subject: Re: [Qemu-devel] security implications of caching with virtio pmem
 (was Re: [PATCH v3 0/5] kvm "virtio pmem" device)
Message-ID: <20190211222907.GR14116@dastard>
References: <20190109144736.17452-1-pagupta@redhat.com>
 <20190204170515-mutt-send-email-mst@kernel.org>
 <888328358.132676.1549870186945.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <888328358.132676.1549870186945.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 11, 2019 at 02:29:46AM -0500, Pankaj Gupta wrote:
> Hello Dave,
> Are we okay with this?

Sure.

I'm not sure I agree with all the analysis presented, but, well, I
haven't looked any deeper because I'm tired of being shouted at and
being called argumentative for daring to ask hard questions about
this topic....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
