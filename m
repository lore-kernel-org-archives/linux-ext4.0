From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs - dirhash.c: remove useless test and assignment in
 strtohash
Date: Thu, 7 Sep 2017 09:39:19 -0400
Message-ID: <20170907133919.r3jg4uhurbecnrkb@thunk.org>
References: <1501188834-4499-1-git-send-email-damien.guibouret@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Damien Guibouret <damien.guibouret@partition-saving.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37416 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754005AbdIGNjW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 7 Sep 2017 09:39:22 -0400
Content-Disposition: inline
In-Reply-To: <1501188834-4499-1-git-send-email-damien.guibouret@partition-saving.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 27, 2017 at 10:53:54PM +0200, Damien Guibouret wrote:
> On transformation of str to hash, computed value is initialised before
> first byte modulo 4. But it is already initialised before entering loop
> and after processing last byte modulo 4. So the corresponding test and
> initialisation could be removed.
> 
> Signed-off-by: Damien Guibouret <damien.guibouret@partition-saving.com>

Thanks, applied.

					- Ted
