From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: constify static data that is never modified
Date: Sat, 29 Apr 2017 23:48:49 -0400
Message-ID: <20170430034849.6thuo2zxxaybhiqw@thunk.org>
References: <20170315050300.26516-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33518 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164562AbdD3Dsv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Apr 2017 23:48:51 -0400
Content-Disposition: inline
In-Reply-To: <20170315050300.26516-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 14, 2017 at 10:03:00PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Constify static data in ext4 that is never (intentionally) modified so
> that it is placed in .rodata and benefits from memory protection.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
