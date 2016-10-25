From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: plausible: fix compilation on RHEL 5.x due to missing magic
 define
Date: Tue, 25 Oct 2016 13:23:21 -0400
Message-ID: <20161025172321.ntnqqnvrjdctwsui@thunk.org>
References: <1476948305-563-1-git-send-email-patrickdepinguin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
To: Thomas De Schampheleire <patrickdepinguin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41966 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933170AbcJYRXX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Oct 2016 13:23:23 -0400
Content-Disposition: inline
In-Reply-To: <1476948305-563-1-git-send-email-patrickdepinguin@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 20, 2016 at 09:25:05AM +0200, Thomas De Schampheleire wrote:
> From: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
> 
> RHEL 5.x does have magic.h, but it does not define all expected symbols. In
> particular, the NO_CHECK symbols were only added in file 4.20 and RHEL 5.x
> is using 4.17.
> 
> Add substitute defines to allow continued usage of magic but without the
> requested exclude checks.
> 
> Signed-off-by: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>

Thanks, applied.

					- Ted
