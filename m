From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] filefrag: remove useless assignment
Date: Sun, 6 Feb 2011 19:01:42 -0500
Message-ID: <20110207000142.GC10402@thunk.org>
References: <87ei7qp35h.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext <linux-ext4@vger.kernel.org>
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33099 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab1BGABz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Feb 2011 19:01:55 -0500
Content-Disposition: inline
In-Reply-To: <87ei7qp35h.fsf@meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 02, 2011 at 09:55:38PM +0100, Jim Meyering wrote:
> Barely worth posting, but...
> There's no point in setting fiemap->ANYTHING
> when the very next statement zeros the entire buffer.
> The correct initialization is already done after the memset.

Thanks, applied.

					- Ted
