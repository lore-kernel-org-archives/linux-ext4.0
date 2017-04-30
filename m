From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: trim return value and 'dir' argument from
 ext4_insert_dentry()
Date: Sat, 29 Apr 2017 23:29:37 -0400
Message-ID: <20170430032937.fypbv4hqfmjwvshi@thunk.org>
References: <20170404213011.108267-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33490 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969694AbdD3D3l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Apr 2017 23:29:41 -0400
Content-Disposition: inline
In-Reply-To: <20170404213011.108267-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 04, 2017 at 02:30:11PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In the initial implementation of ext4 encryption, the filename was
> encrypted in ext4_insert_dentry(), which could fail and also required
> access to the 'dir' inode.  Since then ext4 filename encryption has been
> changed to encrypt the filename earlier, so we can revert the additions
> to ext4_insert_dentry().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
