Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A0DC10F00
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 19:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF710218FD
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 19:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbfCUTtG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 15:49:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728541AbfCUTtG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Mar 2019 15:49:06 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C104E309175F;
        Thu, 21 Mar 2019 19:49:05 +0000 (UTC)
Received: from work (ovpn-204-90.brq.redhat.com [10.40.204.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D173919C59;
        Thu, 21 Mar 2019 19:49:04 +0000 (UTC)
Date:   Thu, 21 Mar 2019 20:49:01 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321194901.44eeu6l7mxsd7k4j@work>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
 <20190321102742.k2oos4epoj6fyjao@work>
 <20190321174811.GF9434@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321174811.GF9434@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 21 Mar 2019 19:49:05 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 01:48:11PM -0400, Theodore Ts'o wrote:
> On Thu, Mar 21, 2019 at 11:27:42AM +0100, Lukas Czerner wrote:
> > 
> > Snapshot of a thinspanshot is allowed though, so we might want to
> > include those. Not sure if it's wise to do it by default, but regardless
> > it's probably something for a separate change.
> 
> Yeah, it's definitely a separate change.  One potential design
> question is that for a thin volume, you can do both a thin or a think
> snapshot, and in some cases one might succeed while the other will
> fail.  So do we make this choice be a parameter that we set in the
> config file, or do we try to see if there is sufficient spare
> freespace for a thick snapshot (and then do that), or a thin snapshot
> (and then do that) --- and which should use prefer?

That's a good question. I am not sure it makes sense to allow choice
between thin/thick snapshots of thin volume. Just pick one, ideally it
would be thin snapshot of thin volume.

> 
> The other thing I'll note is that in order for us to tell whether
> something is a thin or thick LV, we're going to to need to ask lvs to
> return multiple parameters, so the optimization of using:
> 
> 	for NAME in $(lvs -o lv_path --noheadings -S...) ; do
> 	    ...
> 	done
> 
> will no longer work.  (Or we end up calling lvs a second time, which
> is less efficient.)

Yeah, however calling lvs twice might still be better then calling
lsblk for every lv ? This can be easily benchmarked.

first it would be for a non-thin volumes so

-S lv_active=active,lv_role=public,lv_role!=snapshot,segtype!=thin

and second for thin volumes and thin snapshots

-S lv_active=active,lv_role=public,segtype=thin

Note that by default thin snapshots are not active so they will not be
checked unless user activated them.

> 
> Just curious --- do we know how commonly thin LV's are being used by
> customers of various distros?  I assume enterprise distro users will
> be the most conservative, but how common is the uptake of thin LV's by
> Fedora and OpenSuSE users?

I wish I knew. I think that for workstation users it's the defaults that
matters the most so I would not expect thin LV's to be used much there.
Qubes OS being most notable exception I think.
I'd think that thin would be mostly used for virtualization and storage
appliances. I'll ask around, Fedora should have some stats.

-Lukas

> 
> 						- Ted
