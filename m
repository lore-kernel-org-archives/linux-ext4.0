Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12FAC48BE8
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Jun 2021 12:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C09086128C
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Jun 2021 12:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhFPMYw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 16 Jun 2021 08:24:52 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:43838 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229503AbhFPMYw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jun 2021 08:24:52 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15GCMcHd015943
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Jun 2021 08:22:39 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4E2FA15C3CB8; Wed, 16 Jun 2021 08:22:38 -0400 (EDT)
Date:   Wed, 16 Jun 2021 08:22:38 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 3/3] ext4: Fix overflow in ext4_iomap_alloc()
Message-ID: <YMntDuZjWcHEUokL@mit.edu>
References: <20210412102333.2676-1-jack@suse.cz>
 <20210412102333.2676-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412102333.2676-4-jack@suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 12, 2021 at 12:23:33PM +0200, Jan Kara wrote:
> A code in iomap alloc may overblock block number when converting it to
> byte offset. Luckily this is mostly harmless as we will just use more
> expensive method of writing using unwritten extents even though we are
> writing beyond i_size.
> 
> Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
> Signed-off-by: Jan Kara <jack@suse.cz>

This was part of the patch series "ext4: Fix data corruption when
extending DIO write races with buffered read" but which fixes an
unrelated problem.  The patch series was dropped in favor of a
different approach, but it looks like this patch is still applicable,
so I've applied with a minor typo fix in the commit description.

   		       	     	      - Ted
