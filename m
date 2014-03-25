From: tytso@mit.edu
Subject: Re: [PATCH] ext4: initialize multi-block allocator before checking
 block descriptors
Date: Mon, 24 Mar 2014 20:17:00 -0400
Message-ID: <20140325001700.GC13535@thunk.org>
References: <20140315214029.GA18873@thunk.org>
 <CAG5DWoj0pYD8O17qw_-MK+JX_hsFj04ReUPztShmKWzz45gRbQ@mail.gmail.com>
 <20140316023841.GA902@thunk.org>
 <CAG5DWog0BDHTh1edtQ+457SmJeL_0MacgZ1gYeNL4sY4yEqZWw@mail.gmail.com>
 <20140316161637.GA19885@azat>
 <20140316184634.GA14162@thunk.org>
 <20140316205659.GC19885@azat>
 <20140317020029.GC14162@thunk.org>
 <CAG5DWogdTPBOfccVa3xGciLaRedPC1memAmjxnG2uEwSVV64DA@mail.gmail.com>
 <20140317175302.GD19885@azat>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: a3at.mail@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45499 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaCYARJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2014 20:17:09 -0400
Content-Disposition: inline
In-Reply-To: <20140317175302.GD19885@azat>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 17, 2014 at 09:53:02PM +0400, a3at.mail@gmail.com wrote:
> I was wrong, I've just tested on i386, and got the same errors as you.

I assume you will resubmit this patch once you figure out how to avoid
the error on 32-bit x86 systems?

						- Ted
