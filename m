From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: fix tst_badblocks buffer overrun
Date: Mon, 30 Nov 2015 12:10:36 -0500
Message-ID: <20151130171036.GD4316@thunk.org>
References: <1448401810-90675-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57928 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbbK3RKi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 12:10:38 -0500
Content-Disposition: inline
In-Reply-To: <1448401810-90675-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 24, 2015 at 02:50:10PM -0700, Andreas Dilger wrote:
> The test2[] array is not 0-terminated and the create_test_list() for
> loop does not terminate properly at the end of this array, but
> continues until it hits the 0 at the end of test3[].
> 
> Reported-by: Hanno Boeck <hanno@hboeck.de>
> Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=104311
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
