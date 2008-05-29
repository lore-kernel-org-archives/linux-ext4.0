From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: ext4 still busted on ext4
Date: Thu, 29 May 2008 16:40:42 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805291638390.2696@anakin>
References: <20080522235441.1d1a495b.akpm@linux-foundation.org>
 <20080529140718.GB1180@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from edna.telenet-ops.be ([195.130.132.58]:57069 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYE2Okq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 May 2008 10:40:46 -0400
In-Reply-To: <20080529140718.GB1180@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 29 May 2008, Jan Kara wrote:
> > /usr/src/devel/fs/ext4/mballoc.c: In function 'mb_find_next_bit':
> > /usr/src/devel/fs/ext4/mballoc.c:399: error: implicit declaration of function 'generic_find_next_le_bit'
> > 
> > This has been happening for months.
>   Is there anything wrong with the obvious fix (below)? I don't have a
> way to even compile-test this...

Yes. Including the header only provides the prototype of
generic_find_next_le_bit(), not the actual implementation. So it will
still fail at link time.

There exists a patch to fix it, but I haven't tested it yet. Will do (when
time permits), hopefully before 2.6.26...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
