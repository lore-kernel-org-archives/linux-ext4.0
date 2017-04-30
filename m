From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: make ext4_shutdown() static
Date: Sun, 30 Apr 2017 00:41:33 -0400
Message-ID: <20170430044132.yiqubaildmr4tvgv@thunk.org>
References: <20170419054825.9880-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33654 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754346AbdD3Elf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Apr 2017 00:41:35 -0400
Content-Disposition: inline
In-Reply-To: <20170419054825.9880-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 18, 2017 at 10:48:25PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Make the ext4_shutdown() function static, as suggested by running sparse
> ('make C=2 fs/ext4/').  This was the only such warning in fs/ext4/.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
