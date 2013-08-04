From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] EXT4: LazyInit Mount Bug Fix
Date: Sat, 3 Aug 2013 20:49:04 -0400
Message-ID: <20130804004904.GB19781@thunk.org>
References: <CAOprVPLa0-xmKE9_vBddR06-RS3WHUGHH5J4pb28L32jHFOFoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Manish Sharma <manishrma@gmail.com>,
	kapil upadhayay <Kapil.48@gmail.com>
To: Nitin Singla <nitin.akshainie@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39067 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab3HDBoZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Aug 2013 21:44:25 -0400
Content-Disposition: inline
In-Reply-To: <CAOprVPLa0-xmKE9_vBddR06-RS3WHUGHH5J4pb28L32jHFOFoQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 15, 2013 at 12:14:18PM +0530, Nitin Singla wrote:
> -    sbi->s_itb_per_group = sbi->s_inodes_per_group /
> -                    sbi->s_inodes_per_block;
> +    sbi->s_itb_per_group = DIV_ROUND_UP(sbi->s_inodes_per_group,
> +                    sbi->s_inodes_per_block);

This would only matter if s_inodes_per_group is not a multiple of
s_inodes_per_block.  Which is never supposed to happen; mke2fs doesn't
create file systems like this.

Ancient Android build systems, before the bug was fixed, did do this
in the past, but that was a long time ago.  Where did this file system
come from?

I could apply this patch, but you should be warned that there may be
other bugs hiding here for file systems like this, both in the kernel
and in e2fsprogs.

					- Ted
