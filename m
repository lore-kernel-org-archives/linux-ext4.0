From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: do not perform data journaling when data is
 encrypted.
Date: Sat, 10 Dec 2016 17:56:47 -0500
Message-ID: <20161210225647.2qgrsmdt4wq6zmwl@thunk.org>
References: <1481142152-8666-1-git-send-email-skaramov@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Sergey Karamov <skaramov@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41098 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbcLJW4u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 10 Dec 2016 17:56:50 -0500
Content-Disposition: inline
In-Reply-To: <1481142152-8666-1-git-send-email-skaramov@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 07, 2016 at 12:22:32PM -0800, Sergey Karamov wrote:
> Currently data journalling is incompatible with encryption: enabling both
> at the same time has never been supported by design, and would result in
> unpredictable behavior. However, users are not precluded from turning on
> both features simultaneously. This change programmatically replaces data
> journaling for encrypted regular files with ordered data journaling mode.
> 
> Background:
> Journaling encrypted data has not been supported because it operates on
> buffer heads of the page in the page cache. Namely, when the commit
> happens, which could be up to five seconds after caching, the commit
> thread uses the buffer heads attached to the page to copy the contents of
> the page to the journal. With encryption, it would have been required to
> keep the bounce buffer with ciphertext for up to the aforementioned five
> seconds, since the page cache can only hold plaintext and could not be
> used for journaling. Alternatively, it would be required to setup the
> journal to initiate a callback at the commit time to perform deferred
> encryption - in this case, not only would the data have to be written
> twice, but it would also have to be encrypted twice. This level of
> complexity was not justified for a mode that in practice is very rarely
> used because of the overhead from the data journalling.
> 
> Solution:
> If data=journaled has been set as a mount option for a filesystem, or if
> journaling is enabled on a regular file, do not perform journaling if the
> file is also encrypted, instead fall back to the data=ordered mode for the
> file.
> 
> Rationale:
> The intent is to allow seamless and proper filesystem operation when
> journaling and encryption have both been enabled, and have these two
> conflicting features gracefully resolved by the filesystem.
> 
> Signed-off-by: Sergey Karamov <skaramov@google.com>

Applied, thanks.

						- Ted
