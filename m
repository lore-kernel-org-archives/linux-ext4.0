Return-Path: <SRS0=Jip5=BQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43DBC433E1
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2A3D2086A
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Aug 2020 11:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgHFFLQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Aug 2020 01:11:16 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:46146 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725440AbgHFFLP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2020 01:11:15 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0765B93c025098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 6 Aug 2020 01:11:09 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D4CE1420263; Thu,  6 Aug 2020 01:11:08 -0400 (EDT)
Date:   Thu, 6 Aug 2020 01:11:08 -0400
From:   tytso@mit.edu
To:     Jan Kara <jack@suse.cz>
Cc:     <linux-ext4@vger.kernel.org>, Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v3] ext4: don't BUG on inconsistent journal feature
Message-ID: <20200806051108.GH7657@mit.edu>
References: <20200710140759.18031-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710140759.18031-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Jul 10, 2020 at 04:07:59PM +0200, Jan Kara wrote:
> A customer has reported a BUG_ON in ext4_clear_journal_err() hitting
> during an LTP testing. Either this has been caused by a test setup
> issue where the filesystem was being overwritten while LTP was mounting
> it or the journal replay has overwritten the superblock with invalid
> data. In either case it is preferable we don't take the machine down
> with a BUG_ON. So handle the situation of unexpectedly missing
> has_journal feature more gracefully. We issue warning and fail the mount
> in the cases where the race window is narrow and the failed check is
> most likely a programming error. In cases where fs corruption is more
> likely, we do full ext4_error() handling before failing mount / remount.
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
