From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: make online defrag error reporting consistent
Date: Sun, 21 Jun 2015 21:43:54 -0400
Message-ID: <20150622014354.GS29480@thunk.org>
References: <20150617164035.GA1746@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47657 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbbFVBn4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jun 2015 21:43:56 -0400
Content-Disposition: inline
In-Reply-To: <20150617164035.GA1746@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 17, 2015 at 12:40:35PM -0400, Eric Whitney wrote:
> Make the error reporting behavior resulting from the unsupported use
> of online defrag on files with data journaling enabled consistent with
> that implemented for bigalloc file systems. Difference found with
> ext4/308.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
