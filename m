Return-Path: <SRS0=VzNY=SO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9009CC10F0E
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Apr 2019 08:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 604DA2084D
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Apr 2019 08:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfDLIce (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:32:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:52270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbfDLIce (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Apr 2019 04:32:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5FDCAECB;
        Fri, 12 Apr 2019 08:32:31 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id EBF6F1E429B; Fri, 12 Apr 2019 10:32:30 +0200 (CEST)
Date:   Fri, 12 Apr 2019 10:32:30 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Pankaj Gupta <pagupta@redhat.com>,
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
        Paolo Bonzini <pbonzini@redhat.com>, kilobyte@angband.pl,
        yuval.shaia@oracle.com
Subject: Re: [PATCH v5 1/6] libnvdimm: nd_region flush callback support
Message-ID: <20190412083230.GA29850@quack2.suse.cz>
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-2-pagupta@redhat.com>
 <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 11-04-19 07:51:48, Dan Williams wrote:
> On Tue, Apr 9, 2019 at 9:09 PM Pankaj Gupta <pagupta@redhat.com> wrote:
> > +       } else {
> > +               if (nd_region->flush(nd_region))
> > +                       rc = -EIO;
> 
> Given the common case wants to be fast and synchronous I think we
> should try to avoid retpoline overhead by default. So something like
> this:
> 
> if (nd_region->flush == generic_nvdimm_flush)
>     rc = generic_nvdimm_flush(...);

I'd either add a comment about avoiding retpoline overhead here or just
make ->flush == NULL mean generic_nvdimm_flush(). Just so that people don't
get confused by the code.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
