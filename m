From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] fscrypt: add a documentation file for
 filesystem-level encryption
Date: Sun, 29 Oct 2017 06:24:06 -0400
Message-ID: <20171029102406.hc6zzeepgbntwesx@thunk.org>
References: <20170909001512.72431-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40554 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751310AbdJ2KYS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 29 Oct 2017 06:24:18 -0400
Content-Disposition: inline
In-Reply-To: <20170909001512.72431-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 08, 2017 at 05:15:12PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Perhaps long overdue, add a documentation file for filesystem-level
> encryption, a.k.a. fscrypt or fs/crypto/, to the Documentation
> directory.  The new file is based loosely on the latest version of the
> "EXT4 Encryption Design Document (public version)" Google Doc, but with
> many improvements made, including:
> 
> - Reflect the reality that it is not specific to ext4 anymore.
> - More thoroughly document the design and user-visible API/behavior.
> - Replace outdated information, such as the outdated explanation of how
>   encrypted filenames are hashed for indexed directories and how
>   encrypted filenames are presented to userspace without the key.
>   (This was changed just before release.)
> 
> For now the focus is on the design and user-visible API/behavior, not on
> how to add encryption support to a filesystem --- since the internal API
> is still pretty messy and any standalone documentation for it would
> become outdated as things get refactored over time.
> 
> Reviewed-by: Michael Halcrow <mhalcrow@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied, thanks.

					- Ted
