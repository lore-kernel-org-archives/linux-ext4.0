From: tytso@mit.edu
Subject: Re: [PATCH 3/3]ext4: move_extent_per_page() cleanup
Date: Tue, 24 Nov 2009 10:32:33 -0500
Message-ID: <20091124153233.GL2183@thunk.org>
References: <4B03A197.5030605@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42722 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051AbZKXPca (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Nov 2009 10:32:30 -0500
Content-Disposition: inline
In-Reply-To: <4B03A197.5030605@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 18, 2009 at 04:26:15PM +0900, Akira Fujita wrote:
> ext4: move_extent_per_page() cleanup
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> This is a cleanup patch.
> Integrate duplicate lines (acquire/release semaphore
> and invalidate extent cache in move_extent_per_page())
> into mext_replace_branches(),
> so this change leads to the code size reduction.

Applied to the ext4 patch queue with the following rewording of the
commit description:

ext4: move_extent_per_page() cleanup

From: Akira Fujita <a-fujita@rs.jp.nec.com>

Integrate duplicate lines (acquire/release semaphore and invalidate
extent cache in move_extent_per_page()) into mext_replace_branches(),
to reduce source and object code size.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						 - Ted
