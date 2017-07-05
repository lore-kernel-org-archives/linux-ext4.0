From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix compile errors/warnings
Date: Wed, 5 Jul 2017 00:50:35 -0400
Message-ID: <20170705045035.nccg6b3r6turno7q@thunk.org>
References: <20170630041932.5424-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Li Xi <lixi@ddn.com>,
        Wang Shilong <wshilong@ddn.com>, linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47792 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752115AbdGEEui (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 5 Jul 2017 00:50:38 -0400
Content-Disposition: inline
In-Reply-To: <20170630041932.5424-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 29, 2017 at 09:19:32PM -0700, Tahsin Erdogan wrote:
> Defining DEBUG_QUOTA reveals a few compile errors. Fix these.
> Also fix format string type mismatches in a couple of log_debug()
> calls.
> 
> Fixes: 2d2d799c7261 ("Clean up codes for adding new quota type")
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied onto the maint branch.

				- Ted
