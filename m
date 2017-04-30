From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: merge ext4_xattr_list() into ext4_listxattr()
Date: Sat, 29 Apr 2017 23:53:48 -0400
Message-ID: <20170430035348.hpzablqp2bgwubtf@thunk.org>
References: <20170315043325.6764-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33538 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423888AbdD3Dxu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Apr 2017 23:53:50 -0400
Content-Disposition: inline
In-Reply-To: <20170315043325.6764-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 14, 2017 at 09:33:25PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> There's no difference between ext4_xattr_list() and ext4_listxattr(), so
> merge them together and just have ext4_listxattr().  Some years ago they
> took different arguments, but that's no longer the case.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
