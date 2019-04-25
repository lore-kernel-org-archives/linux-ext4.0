Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D897C43218
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C46982077C
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbfDYPtM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:49:12 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42854 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726402AbfDYPtM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 11:49:12 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3PFmnsc002484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Apr 2019 11:48:51 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id A496D420EEC; Thu, 25 Apr 2019 11:48:49 -0400 (EDT)
Date:   Thu, 25 Apr 2019 11:48:49 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Pan Bian <bianpan2016@163.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ext4: avoid drop reference to iloc.bh twice
Message-ID: <20190425154849.GA4739@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Pan Bian <bianpan2016@163.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1555576278-3917-1-git-send-email-bianpan2016@163.com>
 <20190418123519.GJ28541@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418123519.GJ28541@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 18, 2019 at 02:35:19PM +0200, Jan Kara wrote:
> On Thu 18-04-19 16:31:18, Pan Bian wrote:
> > The reference to iloc.bh has been dropped in ext4_mark_iloc_dirty.
> > However, the reference is dropped again if error occurs during
> > ext4_handle_dirty_metadata, which may result in use-after-free bugs.
> > 
> > Fixes: fb265c9cb49e("ext4: add ext4_sb_bread() to disambiguate ENOMEM
> > cases")
> > 
> > Signed-off-by: Pan Bian <bianpan2016@163.com>
> 
> Thanks for the patch! Good spotting. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

> I'm just wondering: Ted, shouldn't we make ext4_mark_iloc_dirty() clear the
> iloc.bh pointer on it's own? I believe this is not the first time we had a
> bug like this and it would also catch possible use-after-free issues in
> case someone tried to use iloc.bh after the reference has been dropped.
> 
> Generally the scheme around ext4_get_inode_loc() and
> ext4_mark_iloc_dirty() seems to be somewhat error prone. E.g. a quick audit
> shows that there's bh leak in ext4_orphan_del() in one of the error paths.
> I'll send patches.

Good suggestion!

I agree, the interface is error-prone.  Clearing inode.bh afterwards
makes sense.

After we do this, we should also scan the call sites, since there are
some places where we have been calling get_bh(iloc.bh) before-hand, so
that the brelse(iloc.bh) in the cleanup path will work.  Other call
paths add iloc.bh = NULL afterwards so that the brelse() will work
correctly.  So we'll be able to clean up all of this afterwards.

		       	     	     - Ted
