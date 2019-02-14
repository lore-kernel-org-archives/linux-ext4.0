Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CF9C10F04
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 19:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1FC8222D0
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 19:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405684AbfBNTKR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 14:10:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388100AbfBNTKR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Feb 2019 14:10:17 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8A4A25EC9;
        Thu, 14 Feb 2019 19:10:16 +0000 (UTC)
Received: from redhat.com (unknown [10.20.6.236])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE82260A9C;
        Thu, 14 Feb 2019 19:10:15 +0000 (UTC)
Date:   Thu, 14 Feb 2019 14:10:14 -0500
From:   Jerome Glisse <jglisse@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Michal Hocko <mhocko@kernel.org>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
Message-ID: <20190214191013.GA3420@redhat.com>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz>
 <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
User-Agent: Mutt/1.10.0 (2018-05-17)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 14 Feb 2019 19:10:16 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 14, 2019 at 10:25:07AM -0800, Dan Williams wrote:
> On Thu, Feb 14, 2019 at 5:46 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Wed 06-02-19 13:12:59, Dan Williams wrote:
> > [...]
> > > * Userfaultfd for file-backed mappings and DAX
> >
> > I assume that other topics are meant to be FS track but this one is MM,
> > right?
> 
> Yes, but I think it is the lowest priority of all the noted sub-topics
> in this proposal. The DAX-reflink discussion, where a given
> physical-page may need to be mapped into multiple inodes at different
> offsets, might be more fruitful to have as a joint discussion with MM.

Note that my generic page write protection work can be use for that ie
having a single page correspond to multiple different mapping with also
different offset within each mapping. While in my patchset i only solve
the mapping aliasing issue, the index can be solve in much the same way
because same thinking apply. Namely that when you work on a file you
know the mapping and file offset and thus the index and when you work on
the vma you know the mapping and offset within the vma which translate
to offset within the file. They are only few places that do not have the
informations available and those do not care about it.

I am just again working on my struct page mapping patchset as well as
the generic page write protection that sits on top. I hope to be able
to post the v2 in couple weeks. You can always look at my posting last
year to see more details.

Cheers,
Jérôme
