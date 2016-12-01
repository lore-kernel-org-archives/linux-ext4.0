From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: get rid of ext4_sb_has_crypto()
Date: Thu, 1 Dec 2016 11:54:50 -0500
Message-ID: <20161201165450.6otvukps245vv2zb@thunk.org>
References: <1479774132-11457-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50678 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759053AbcLAQyz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 1 Dec 2016 11:54:55 -0500
Content-Disposition: inline
In-Reply-To: <1479774132-11457-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 21, 2016 at 04:22:12PM -0800, Eric Biggers wrote:
> ext4_sb_has_crypto() just called through to ext4_has_feature_encrypt(),
> and all callers except one were already using the latter.  So remove it
> and switch its one caller to ext4_has_feature_encrypt().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
