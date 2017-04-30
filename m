From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: rename ext4_xattr_check_names() to
 ext4_xattr_check_entries()
Date: Sun, 30 Apr 2017 00:00:23 -0400
Message-ID: <20170430040023.7o55x2kpwa3vi56g@thunk.org>
References: <20170315045057.18837-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33556 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbdD3EA0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Apr 2017 00:00:26 -0400
Content-Disposition: inline
In-Reply-To: <20170315045057.18837-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 14, 2017 at 09:50:55PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> ext4_xattr_check_names() actually validates both the xattr names and
> values, not just the names.  So rename it to ext4_xattr_check_entries()
> to avoid confusion.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
