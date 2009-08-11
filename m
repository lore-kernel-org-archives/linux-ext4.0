From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove redundant test on unsigned
Date: Mon, 10 Aug 2009 22:48:18 -0400
Message-ID: <20090811024818.GJ1756@mit.edu>
References: <4A400B53.2080903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49838 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZHKNCo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2009 09:02:44 -0400
Content-Disposition: inline
In-Reply-To: <4A400B53.2080903@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 23, 2009 at 12:53:07AM +0200, Roel Kluin wrote:
> unsigned i_block cannot be less than 0.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied, my apologies for the delay.

					- Ted
