Return-Path: <SRS0=U68d=Y6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E1FC5DF63
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Nov 2019 17:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52DB5217F5
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Nov 2019 17:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbfKFRXE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Nov 2019 12:23:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:48946 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729259AbfKFRXE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 6 Nov 2019 12:23:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5790B498;
        Wed,  6 Nov 2019 17:23:02 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 546B61E4353; Wed,  6 Nov 2019 18:23:02 +0100 (CET)
Date:   Wed, 6 Nov 2019 18:23:02 +0100
From:   Jan Kara <jack@suse.cz>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     tytso@mit.edu, jack@suse.cz, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, mbobrowski@mbobrowski.org
Subject: Re: [RFC 0/5] Ext4: Add support for blocksize < pagesize for
 dioread_nolock
Message-ID: <20191106172302.GE12685@quack2.suse.cz>
References: <20191016073711.4141-1-riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016073711.4141-1-riteshh@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 16-10-19 13:07:06, Ritesh Harjani wrote:
> This patch series adds the support for blocksize < pagesize for
> dioread_nolock feature.
> 
> Since in case of blocksize < pagesize, we can have multiple
> small buffers of page as unwritten extents, we need to
> maintain a vector of these unwritten extents which needs
> the conversion after the IO is complete. Thus, we maintain
> a list of tuple <offset, size> pair (io_end_vec) for this &
> traverse this list to do the unwritten to written conversion.
> 
> Appreciate any reviews/comments on this patches.

I know Ted has merged the patches already so this is just informational but
I've read the patches and they look fine to me. Thanks for the work! I was
just thinking that we could actually make the vector tracking more
efficient because the io_end always looks like:

one-big-extent-to-fully-write + whatever it takes to fully write out the
last page

So your vectors could be also expressed as "extent to write" + bitmap of
blocks written in the last page. And 64-bits are enough for the bitmap for
anything ext4 supports so we could easily save allocation of ioend_vec etc.
Just a suggestion.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
