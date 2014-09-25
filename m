From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 5/10] ext4: Add DX_HASH_SIPHASH24 support
Date: Wed, 24 Sep 2014 22:36:47 -0400
Message-ID: <20140925023647.GA4592@thunk.org>
References: <20140924153531.GK17784@thunk.org>
 <20140924233113.22784.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47540 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbaIYCgx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Sep 2014 22:36:53 -0400
Content-Disposition: inline
In-Reply-To: <20140924233113.22784.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 24, 2014 at 07:31:13PM -0400, George Spelvin wrote:
> Another option I thought of I'd like to get formally rejected would be
> to consider all future hashes unsigned, so there's a +3 offset between
> the on-disk value and the ext2fs_dirhash parameter.

I'm fine with considering all future hashes to be unsigned; let's see
how messy it actually makes the source code.

Cheers,

						- Ted
