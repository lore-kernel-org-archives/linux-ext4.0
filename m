From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Problem mounting ext2 using ext3?
Date: Tue, 6 May 2008 13:20:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805061319390.10091@anakin>
References: <Pine.LNX.4.64.0805052304280.3160@anakin> <20080505222623.GA8357@mit.edu>
 <20080506100216.GB1409@duck.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from monty.telenet-ops.be ([195.130.132.56]:48895 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYEFLUa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 May 2008 07:20:30 -0400
In-Reply-To: <20080506100216.GB1409@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 May 2008, Jan Kara wrote:
>   Thanks Ted for looking into this. Yes, the problem is caused by my
> modifications to quota code... The patch below fixes it for me and I've
> also added a comment so that someone does not remove the check again in
> future ;).

I'll try to give it a try this evening...

> +	 * Skip everything if there's nothing to do. We have to do this becase
                                                                        ^^^^^^
									because

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
