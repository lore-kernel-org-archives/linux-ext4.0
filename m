From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V7 03/23] ext4: Add the basic function for inline data
 support.
Date: Sun, 2 Dec 2012 20:48:23 -0500
Message-ID: <20121203014823.GA5507@thunk.org>
References: <1351047002-4723-1-git-send-email-tm@tao.ma>
 <1351047338-4963-1-git-send-email-tm@tao.ma>
 <1351047338-4963-3-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36411 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab2LCDdX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Dec 2012 22:33:23 -0500
Content-Disposition: inline
In-Reply-To: <1351047338-4963-3-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 24, 2012 at 10:55:18AM +0800, Tao Ma wrote:
> +	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */

Can you write a paragraph or two about exactly what the semantics are
of this state flag --- what it means, when it should be set, and when
it should be cleared, etc.?

I'm not entirely sure I understand why you test
EXT4_STATE_MAY_INLINE_DATA versus simply calling
ext4_has_inline_data() in various places.

Thanks!!

					- Ted
