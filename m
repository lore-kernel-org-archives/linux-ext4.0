From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 5/10] ext4: Add DX_HASH_SIPHASH24 support
Date: Tue, 23 Sep 2014 21:47:44 -0400
Message-ID: <20140924014744.GJ17784@thunk.org>
References: <0765A511-D5E2-4F00-8F2F-F5A8E76C0B03@dilger.ca>
 <20140923204527.20932.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44650 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbaIXBru (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 21:47:50 -0400
Content-Disposition: inline
In-Reply-To: <20140923204527.20932.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 23, 2014 at 04:45:27PM -0400, George Spelvin wrote:
> 
> Er... I'll let Ted tell me if I screwed up, but I went through
> the code quite carefully figuring out what value to use, and
> DX_HASH_LEGACY_UNSIGNED is *not* an on-disk encoding.

You're right, but it would probably be safer to have a hole in the
on-disk numbering.  That's because changing the numbering of
EXT2_HASH_*_UNSIGNED will change the ABI of ext2fs_dirhash().  While
we don't officially support a mismatch between the version of e2fsck
and libext2fs, and it's unlikely that other programs would be trying
to use ext2fs_dirhash.

Still, it would probably simpler to not try to assign
DX_HASH_SIPHASH24 to be 6, and to leave better comments about how the
hash values are used.

Cheers,

					- Ted
