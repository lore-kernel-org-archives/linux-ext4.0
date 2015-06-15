From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Wait for existing dio workers in
 ext4_alloc_file_blocks()
Date: Mon, 15 Jun 2015 00:25:54 -0400
Message-ID: <20150615042554.GH15793@thunk.org>
References: <1433833126-28575-1-git-send-email-lczerner@redhat.com>
 <1433833126-28575-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35210 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbbFOEZy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jun 2015 00:25:54 -0400
Content-Disposition: inline
In-Reply-To: <1433833126-28575-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 09, 2015 at 08:58:46AM +0200, Lukas Czerner wrote:
> Currently existing dio workers can jump in and potentially increase
> extent tree depth while we're allocating blocks in
> ext4_alloc_file_blocks(). This may cause us to underestimate the number
> of credits needed for the transaction because the extent tree depth can
> change after our estimation.
> 
> Fix this by waiting for all the existing dio workers in the same way as
> we do it in ext4_punch_hole. We've seen errors caused by this in xfstest
> generic/299, however it's really hard to reproduce.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

						- Ted
