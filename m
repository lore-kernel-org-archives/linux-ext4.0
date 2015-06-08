From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 2/3] ext4: Try to initialize all groups we can in case
 of failure on ppc64
Date: Mon, 8 Jun 2015 11:39:21 -0400
Message-ID: <20150608153921.GE19168@thunk.org>
References: <1433266205-24513-1-git-send-email-lczerner@redhat.com>
 <1433266205-24513-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53095 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbbFHPjZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 11:39:25 -0400
Content-Disposition: inline
In-Reply-To: <1433266205-24513-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 02, 2015 at 07:30:04PM +0200, Lukas Czerner wrote:
> Currently on the machines with page size > block size when initializing
> block group buddy cache we initialize it for all the block group bitmaps
> in the page. However in the case of read error, checksum error, or if
> a single bitmap is in any way corrupted we would fail to initialize all
> of the bitmaps. This is problematic because we will not have access to
> the other allocation groups even though those might be perfectly fine
> and usable.
> 
> Fix this by reading all the bitmaps instead of error out on the first
> problem and simply skip the bitmaps which were either not read properly,
> or are not valid.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
