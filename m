From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix memory leak when symlink decryption fails
Date: Thu, 15 Sep 2016 13:16:16 -0400
Message-ID: <20160915171616.zuh3cqimgdtjqm3n@thunk.org>
References: <1473707806-37537-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56292 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750878AbcIORQ5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Sep 2016 13:16:57 -0400
Content-Disposition: inline
In-Reply-To: <1473707806-37537-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 12, 2016 at 12:16:46PM -0700, Eric Biggers wrote:
> This bug was introduced in v4.8-rc1.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

						- Ted
