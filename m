From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fscrypto: remove unnecessary includes
Date: Thu, 15 Sep 2016 16:48:00 -0400
Message-ID: <20160915204800.nkkshw5ypdkftno3@thunk.org>
References: <1473886634-24627-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57058 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752986AbcIOUs3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Sep 2016 16:48:29 -0400
Content-Disposition: inline
In-Reply-To: <1473886634-24627-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2016 at 01:57:12PM -0700, Eric Biggers wrote:
> This patch removes some #includes that are clearly not needed, such as a
> reference to ecryptfs, which is unrelated to the new filesystem
> encryption code.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
