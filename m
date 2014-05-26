From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: fix wrong assert in ext4_mb_normalize_request()
Date: Mon, 26 May 2014 12:42:31 -0400
Message-ID: <20140526164231.GM22284@thunk.org>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com>
 <1393855228-13592-2-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca
To: Maurizio Lombardi <mlombard@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33201 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaEZQmf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2014 12:42:35 -0400
Content-Disposition: inline
In-Reply-To: <1393855228-13592-2-git-send-email-mlombard@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 03, 2014 at 03:00:27PM +0100, Maurizio Lombardi wrote:
> the variable "size" is expressed as number of blocks and not as
> number of clusters, this could trigger a kernel panic when using
> ext4 with the size of a cluster different from the size of a block.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Thanks, applied.

					- Ted
