From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs, ext4: Fix potential memory leak in ext4_fill_super
Date: Tue, 27 Jul 2010 09:31:46 -0400
Message-ID: <20100727133146.GA18966@thunk.org>
References: <20100616153332.GA6751@lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51112 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab0G0Nbn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 09:31:43 -0400
Content-Disposition: inline
In-Reply-To: <20100616153332.GA6751@lenovo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 16, 2010 at 07:33:32PM +0400, Cyrill Gorcunov wrote:
> Under heavy memory pressure we may hit out of memory
> situation and as result kstrdup'ed options will not be
> freed. Fix it.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thanks, I've added this to the ext4 tree.

						- Ted
