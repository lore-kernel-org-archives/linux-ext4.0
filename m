Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7556FC10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 16:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5181B21479
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 16:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388775AbfDRQLA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 12:11:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbfDRQLA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Apr 2019 12:11:00 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 042CB306C3EC;
        Thu, 18 Apr 2019 16:11:00 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 024235C206;
        Thu, 18 Apr 2019 16:10:45 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jan Kara <jack@suse.cz>, Pankaj Gupta <pagupta@redhat.com>,
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
Subject: Re: [PATCH v5 1/6] libnvdimm: nd_region flush callback support
References: <20190410040826.24371-1-pagupta@redhat.com>
        <20190410040826.24371-2-pagupta@redhat.com>
        <CAPcyv4i1FjBzfcWtzeCvj-giHa9xaX0dMQ==q4LZC_L8VEqkHg@mail.gmail.com>
        <20190412083230.GA29850@quack2.suse.cz>
        <x494l73z7th.fsf@segfault.boston.devel.redhat.com>
        <CAPcyv4jrNHqW3FuGkeo==ZoJr7LKahCv4_esnokfy7enek8=2Q@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 18 Apr 2019 12:10:44 -0400
In-Reply-To: <CAPcyv4jrNHqW3FuGkeo==ZoJr7LKahCv4_esnokfy7enek8=2Q@mail.gmail.com>
        (Dan Williams's message of "Thu, 18 Apr 2019 09:05:05 -0700")
Message-ID: <x49lg07cn0b.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 18 Apr 2019 16:11:00 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

> On Fri, Apr 12, 2019 at 6:12 AM Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> Jan Kara <jack@suse.cz> writes:
>>
>> > On Thu 11-04-19 07:51:48, Dan Williams wrote:
>> >> On Tue, Apr 9, 2019 at 9:09 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>> >> > +       } else {
>> >> > +               if (nd_region->flush(nd_region))
>> >> > +                       rc = -EIO;
>> >>
>> >> Given the common case wants to be fast and synchronous I think we
>> >> should try to avoid retpoline overhead by default. So something like
>> >> this:
>> >>
>> >> if (nd_region->flush == generic_nvdimm_flush)
>> >>     rc = generic_nvdimm_flush(...);
>> >
>> > I'd either add a comment about avoiding retpoline overhead here or just
>> > make ->flush == NULL mean generic_nvdimm_flush(). Just so that people don't
>> > get confused by the code.
>>
>> Isn't this premature optimization?  I really don't like adding things
>> like this without some numbers to show it's worth it.
>
> I don't think it's premature given this optimization technique is
> already being deployed elsewhere, see:
>
> https://lwn.net/Articles/774347/

The technique is fine, but that doesn't mean it should be applied
everywhere.  Is *this* code path really going to benefit from the
optimization?

-Jeff
