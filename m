From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] ext4: init pagevec in ext4_da_block_invalidatepages
Date: Tue, 13 Nov 2012 00:14:58 -0500
Message-ID: <20121113051458.GB11524@thunk.org>
References: <50A019AE.7090907@redhat.com>
 <50A01DAD.4080607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60765 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab2KMFPE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2012 00:15:04 -0500
Content-Disposition: inline
In-Reply-To: <50A01DAD.4080607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 11, 2012 at 03:50:37PM -0600, Eric Sandeen wrote:
> ext4_da_block_invalidatepages is missing a pagevec_init(),
> which means that pvec->cold contains random garbage.
> 
> This affects whether the page goes to the front or
> back of the LRU when ->cold makes it to
> free_hot_cold_page()
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Cc: stable@vger.kernel.org

Applied, thanks.

					- Ted
