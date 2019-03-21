Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0214C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 10:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70840218AE
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 10:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfCUKP3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 06:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56578 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfCUKP3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Mar 2019 06:15:29 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85B962026E;
        Thu, 21 Mar 2019 10:15:28 +0000 (UTC)
Received: from work (ovpn-204-90.brq.redhat.com [10.40.204.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 93C28608A4;
        Thu, 21 Mar 2019 10:15:26 +0000 (UTC)
Date:   Thu, 21 Mar 2019 11:15:21 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH] e2scrub_all: refactor device probe loop
Message-ID: <20190321101521.pej52dcrvf635gt2@work>
References: <20190319001732.GB4916@magnolia>
 <20190319105824.apzsygxgl5dt3fq6@work>
 <20190320161708.GA32021@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320161708.GA32021@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 21 Mar 2019 10:15:28 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 12:17:08PM -0400, Theodore Ts'o wrote:
> On Tue, Mar 19, 2019 at 11:58:24AM +0100, Lukas Czerner wrote:
> > >  # Find scrub targets, make sure we only do this once.
> > > -ls_scrub_targets() {
> > > -	lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n | while read vars; do
> > > +ls_scan_targets() {
> > > +	lvs --name-prefixes -o vg_name,lv_name,lv_path \
> > > +			-S lv_active=active,lv_role=public --noheadings | \
> > 
> > You're not using vg_name, nor lv_name so you can drop it maybe ? Also
> > you're missing lv_role since you're checking it later, however you can
> > do this instead
> > 
> > 	-S lv_active=active,lv_role=public -S lv_role!=snapshot
> 
> We don't need to check lv_role at all, since the command already
> included:
> 
> 	-S lv_active=active,lv_role=public

You actually need to check the lv_role for snapshot, because snapshot can
be "public" as well.

> 
> And we need to do lv_role=public and not lv_role!=snapshot, since we
> need to also exclude thinpools.

No, you need to check both if you want to exclude snapshots.


I think that specifying -S twice tricked you, sorry about that. But
again you can do:

	-S lv_active=active,lv_role=public,lv_role!=snapshot

Thanks!
-Lukas
