Return-Path: <SRS0=eYnO=RX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9CAC43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Mar 2019 16:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5A8F2183E
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Mar 2019 16:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfCTQRc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Mar 2019 12:17:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45662 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726803AbfCTQRc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Mar 2019 12:17:32 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2KGH97Z032395
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Mar 2019 12:17:10 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D6BD7420AA8; Wed, 20 Mar 2019 12:17:08 -0400 (EDT)
Date:   Wed, 20 Mar 2019 12:17:08 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH] e2scrub_all: refactor device probe loop
Message-ID: <20190320161708.GA32021@mit.edu>
References: <20190319001732.GB4916@magnolia>
 <20190319105824.apzsygxgl5dt3fq6@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319105824.apzsygxgl5dt3fq6@work>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 19, 2019 at 11:58:24AM +0100, Lukas Czerner wrote:
> >  # Find scrub targets, make sure we only do this once.
> > -ls_scrub_targets() {
> > -	lsblk -o NAME,FSTYPE,MOUNTPOINT -p -P -n | while read vars; do
> > +ls_scan_targets() {
> > +	lvs --name-prefixes -o vg_name,lv_name,lv_path \
> > +			-S lv_active=active,lv_role=public --noheadings | \
> 
> You're not using vg_name, nor lv_name so you can drop it maybe ? Also
> you're missing lv_role since you're checking it later, however you can
> do this instead
> 
> 	-S lv_active=active,lv_role=public -S lv_role!=snapshot

We don't need to check lv_role at all, since the command already
included:

	-S lv_active=active,lv_role=public

And we need to do lv_role=public and not lv_role!=snapshot, since we
need to also exclude thinpools.

Speaking of thinpools, although we *can* take a thick snapshot of a
thinp volume, in the future we might want to add support for taking a
thinp snapshot.  (Although that will make the check which I've been
working on to make sure there's enough free space a bit more
complicated.)

I have some other patches queued for e2scrub, so I'll take a whack and
trying to make a reivison of this patch, and then send out a stack of
patches against e2scrub for folks to look at.

			    	     	  - Ted
