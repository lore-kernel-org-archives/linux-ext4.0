Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0E7C5519F
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Nov 2020 03:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 916A220728
	for <linux-ext4@archiver.kernel.org>; Fri, 20 Nov 2020 03:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgKTDmL (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:42:11 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:53212 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726118AbgKTDmL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2020 22:42:11 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0AK3fuIX029669
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 22:41:56 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 34843420107; Thu, 19 Nov 2020 22:41:56 -0500 (EST)
Date:   Thu, 19 Nov 2020 22:41:56 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix bogus warning in ext4_update_dx_flag()
Message-ID: <20201120034156.GC695373@mit.edu>
References: <20201118153032.17281-1-jack@suse.cz>
 <X7WXxl4gQEuvLxyO@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X7WXxl4gQEuvLxyO@sol.localdomain>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Nov 18, 2020 at 01:53:10PM -0800, Eric Biggers wrote:
> On Wed, Nov 18, 2020 at 04:30:32PM +0100, Jan Kara wrote:
> > The idea of the warning in ext4_update_dx_flag() is that we should warn
> > when we are clearing EXT4_INODE_INDEX on a filesystem with metadata
> > checksums enabled since after clearing the flag, checksums for internal
> > htree nodes will become invalid. So there's no need to warn (or actually
> > do anything) when EXT4_INODE_INDEX is not set.
> > 
> > Reported-by: Eric Biggers <ebiggers@kernel.org>
> > Fixes: 48a34311953d ("ext4: fix checksum errors with indexed dirs")
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Looks good,
> 
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Applied, thanks.

					- Ted
