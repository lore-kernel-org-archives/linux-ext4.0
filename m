Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55896C07E98
	for <linux-ext4@archiver.kernel.org>; Sun,  4 Jul 2021 00:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EE4061480
	for <linux-ext4@archiver.kernel.org>; Sun,  4 Jul 2021 00:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhGDBAp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 3 Jul 2021 21:00:45 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49657 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229557AbhGDBAp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Jul 2021 21:00:45 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1640w2GV025380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 3 Jul 2021 20:58:02 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 2BB1915C3CEB; Sat,  3 Jul 2021 20:58:02 -0400 (EDT)
Date:   Sat, 3 Jul 2021 20:58:02 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Tahsin Erdogan <trdgn@amazon.com>
Cc:     Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: eliminate bogus error in
 ext4_data_block_valid_rcu()
Message-ID: <YOEHmjjY9facxtIY@mit.edu>
References: <20210703230555.4093-1-trdgn@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703230555.4093-1-trdgn@amazon.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Jul 03, 2021 at 04:05:55PM -0700, Tahsin Erdogan wrote:
> Mainline commit ce9f24cccdc0 ("ext4: check journal inode extents more carefully")
> enabled validity checks for journal inode's data blocks. This change got
> ported to stable branches, but the backport for 4.19 has a bug where it will
> flag an error even when system block entry's inode number matches journal
> inode.

Tahsin,

If I understand the commit description, this patch is only intended
for the 4.19 stable kernel.  If this is the case, I'd suggest using
the Subject prefix [PATCH 4.19] for future patches.  This is more
likely to be clearer (via a quick glance at the Subject line) for
subsystem maintainers, as well as for stable kernel maintainers, that
this is meant for the stable kernel.  It would perhaps also be useful
if you could indicate whether a similar fix is needed for 4.14, and
other older LTS kernels, or whether the only stable backport which had
this bug was 4.19.

Cheers,

					- Ted

P.S.  Great to see you've landed at Amazon!  It's been a while; if I
have a chance to make it out to Seattle, one of these days, it would
be great to catch up.
