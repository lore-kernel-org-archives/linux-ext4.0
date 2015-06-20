From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: fix alignment warnings on ARM
Date: Fri, 19 Jun 2015 21:38:05 -0400
Message-ID: <20150620013805.GB29480@thunk.org>
References: <1432334451-15863-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46030 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbbFTBiH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Jun 2015 21:38:07 -0400
Content-Disposition: inline
In-Reply-To: <1432334451-15863-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 22, 2015 at 04:40:51PM -0600, Andreas Dilger wrote:
> Some temporary char buffers allocated on the stack are not properly
> aligned when typecast to a structure containing __u32 or __u64 types,
> and this can cause alignment warnings on ARM and other alignment
> sensitive architectures, and potential slowdowns to do fixups.
> 
> Fix the buffer alignment to avoid such issues.
> 
> Addresses: https://bugzilla.redhat.com/show_bug.cgi?id=680090
> 
> Reported-by: Gordan Bobic <gordan.bobic@gmail.com>
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
