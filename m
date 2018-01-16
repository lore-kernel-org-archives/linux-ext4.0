From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v2 00/11] fscrypt: symlink helpers and fscrypt.h cleanup
Date: Tue, 16 Jan 2018 15:46:57 -0800
Message-ID: <20180116234657.GA22224@jaegeuk-macbookpro.roam.corp.google.com>
References: <20180105184502.48473-1-ebiggers3@gmail.com>
 <20180112043338.GA8249@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750830AbeAPXq6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Jan 2018 18:46:58 -0500
Content-Disposition: inline
In-Reply-To: <20180112043338.GA8249@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/11, Theodore Ts'o wrote:
> I've taken the v2 version of this series, plus the ext4-specific
> patches to use the new symlink helpers (from the v1 patch series).
> After testing and validating them, I included the patches to convert
> f2fs and ubifs to use the symlink helpers, so I could also grab the
> cleanup patches from the V1 series.
> 
> Jaeguk, Richard, please let me know if you are OK with my taking the
> f2fs and ubifs changes in the fscrypt tree.  It seems like it would
> keep things simpler if we did that.

I'm fine with that.
Thanks,

> 
> Cheers,
> 
> 						- Ted
