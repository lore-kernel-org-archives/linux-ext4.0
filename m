From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: Use filemap_write_and_wait_range() correctly
 in collapse range
Date: Fri, 18 Apr 2014 10:42:42 -0400
Message-ID: <20140418144242.GB19131@thunk.org>
References: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linkinjeon@gmail.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48213 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbaDROmo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 10:42:44 -0400
Content-Disposition: inline
In-Reply-To: <1397673182-5326-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 16, 2014 at 08:32:58PM +0200, Lukas Czerner wrote:
> Currently we're passing -1 as lend argumnet for
> filemap_write_and_wait_range() which is wrong since lend is signed type
> so it would cause some confusion and we might not write_and_wait for the
> entire range we're expecting to write.
> 
> Fix it by using LLONG_MAX instead.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
