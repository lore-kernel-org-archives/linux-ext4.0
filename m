Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F68BC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 14:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E489A218E2
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 14:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfCUOci (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 10:32:38 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45907 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727934AbfCUOci (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 10:32:38 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LEWQOL018590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 10:32:27 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 1A8D4420AA8; Thu, 21 Mar 2019 10:32:26 -0400 (EDT)
Date:   Thu, 21 Mar 2019 10:32:26 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 5/9] e2fscrub: add the -n option which shows what
 commands e2scrub would execute
Message-ID: <20190321143225.GC9434@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-5-tytso@mit.edu>
 <20190321105751.l7vlfhzmufgu3dfn@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321105751.l7vlfhzmufgu3dfn@work>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 11:57:51AM +0100, Lukas Czerner wrote:
> On Wed, Mar 20, 2019 at 10:02:14PM -0400, Theodore Ts'o wrote:
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > ---
> >  scrub/e2scrub.8.in | 5 +++++
> >  scrub/e2scrub.in   | 6 ++++--
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/scrub/e2scrub.8.in b/scrub/e2scrub.8.in
> > index ff03523e3..7342876a3 100644
> > --- a/scrub/e2scrub.8.in
> > +++ b/scrub/e2scrub.8.in
> > @@ -38,6 +38,11 @@ If the filesystem is not repaired,
> >  will be run before the next mount.
> >  .SH OPTIONS
> >  .TP
> > +\fB-n\fR
> > +Print what commands
> > +.B e2scrub
> > +would execute (but don't actually execute them).
> 
> We should be a bit more clear that it's not all the commands that will
> be printed but not executed. Some of commands, like lsblk and lvs will
> actually be executed so it's not like you can run this without proper
> privledges.
> 
> It sounds nit-picky, and obvious to us, but I am sure someone will
> complaing about this.

Good point, I'll fix this.

					- Ted
