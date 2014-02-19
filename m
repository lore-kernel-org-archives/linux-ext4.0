From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: remove local sync_file_range and fallocate
Date: Tue, 18 Feb 2014 20:05:22 -0500
Message-ID: <20140219010522.GF7339@thunk.org>
References: <f2848e6c0e067d62a4ee672f18364b20d4c901d9.1389083392.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59818 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaBSBGo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Feb 2014 20:06:44 -0500
Content-Disposition: inline
In-Reply-To: <f2848e6c0e067d62a4ee672f18364b20d4c901d9.1389083392.git.baruch@tkos.co.il>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 07, 2014 at 10:29:52AM +0200, Baruch Siach wrote:
> The locally defined versions of both sync_file_range and fallocate are broken
> on 32bit systems. On these systems two 32bit registers are needed for each
> 64bit parameter. Also, sync_file_range on MIPS32 needs a dummy parameters
> after the fd parameter. Just leave all these subtleties to the C library.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Thanks, applied.

Apologies for the delay.

						- Ted
