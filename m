From: a3at.mail@gmail.com
Subject: Re: [PATCH] ext4: initialize multi-block allocator before checking
 block descriptors
Date: Tue, 25 Mar 2014 10:24:10 +0400
Message-ID: <20140325062405.GA25115@azat>
References: <CAG5DWoj0pYD8O17qw_-MK+JX_hsFj04ReUPztShmKWzz45gRbQ@mail.gmail.com>
 <20140316023841.GA902@thunk.org>
 <CAG5DWog0BDHTh1edtQ+457SmJeL_0MacgZ1gYeNL4sY4yEqZWw@mail.gmail.com>
 <20140316161637.GA19885@azat>
 <20140316184634.GA14162@thunk.org>
 <20140316205659.GC19885@azat>
 <20140317020029.GC14162@thunk.org>
 <CAG5DWogdTPBOfccVa3xGciLaRedPC1memAmjxnG2uEwSVV64DA@mail.gmail.com>
 <20140317175302.GD19885@azat>
 <20140325001700.GC13535@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:47246 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaCYGYP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Mar 2014 02:24:15 -0400
Received: by mail-lb0-f171.google.com with SMTP id w7so11906lbi.2
        for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2014 23:24:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140325001700.GC13535@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 24, 2014 at 08:17:00PM -0400, tytso@mit.edu wrote:
> On Mon, Mar 17, 2014 at 09:53:02PM +0400, a3at.mail@gmail.com wrote:
> > I was wrong, I've just tested on i386, and got the same errors as you.
> 
> I assume you will resubmit this patch once you figure out how to avoid
> the error on 32-bit x86 systems?

Yes, sure, thanks.
(I just don't have enough free time right now for this.)

BTW now I have this errors on x86_64 too.

> 
> 						- Ted

-- 
Respectfully
Azat Khuzhin
