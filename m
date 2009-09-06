From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space
	in failure
Date: Sat, 5 Sep 2009 23:13:55 -0400
Message-ID: <20090906031355.GD3055@mit.edu>
References: <4A9DE3EA.1080602@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36987 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZIFDNy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Sep 2009 23:13:54 -0400
Content-Disposition: inline
In-Reply-To: <4A9DE3EA.1080602@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 02, 2009 at 12:18:02PM +0900, Akira Fujita wrote:
> ext4: Return exchanged blocks count to user space in failure
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> Return exchanged blocks count (moved_len) to user space,
> if ext4_move_extents() failed on the way.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

Added to the ext4 patch queue.

