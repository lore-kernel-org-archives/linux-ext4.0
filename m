From: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: Problem mounting ext2 using ext3?
Date: Tue, 6 May 2008 09:26:30 +0200
Message-ID: <19f34abd0805060026m138bf3dfo87dbf303362d69ca@mail.gmail.com>
References: <Pine.LNX.4.64.0805052304280.3160@anakin>
	 <20080505222623.GA8357@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@mit.edu>,
	"Geert Uytterhoeven" <geert@linux-m68k.org>,
	linux-ext4@vger.kernel.org,
	"Linux Kernel Development" <linux-kernel@vger.kernel.org>,
	"Linux/m68k" <linu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:13722 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbYEFH0a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 May 2008 03:26:30 -0400
Received: by rv-out-0506.google.com with SMTP id l9so1545600rvb.1
        for <linux-ext4@vger.kernel.org>; Tue, 06 May 2008 00:26:30 -0700 (PDT)
In-Reply-To: <20080505222623.GA8357@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Tue, May 6, 2008 at 12:26 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, May 05, 2008 at 11:11:46PM +0200, Geert Uytterhoeven wrote:
>  > when mounting the root file system, which is ext2 (has_journal is not set).
>  > Apparently it crashes in ext3_sync_fs because EXT3_SB(sb)->s_journal is NULL.
>  >
>  > At first I thought it was an issue with the byteswapped IDE bus on Atari (a
>  > new and different solution to handle this just went into mainline), but if I
>  > disable CONFIG_EXT3 support, it boots up fine.
>  >
>  > Is this a known problem?
>
>  I can confirm this as a regression.  You don't even need to mount it
>  as a root filesystem, or do this on an 68k system.  On my x86 system,
>  using a kernel based off of git commit: afa26be8 (6 commits after
>  2.6.26-rc1), mounting an ext3 filesystem, you can cause an oops by
>  taking an ext2 filesystem and forcing a mount as ext3, "mount -t ext3
>  /dev/closure/textext2fs /mnt").  (see below for my oops).  This does
>  not occur with a kernel based off of 2.6.25, so it's a definite
>  regression.

Hi,

I posted a very similar problem a couple of days ago:
http://www.nabble.com/BUG-in-ext3_sync_fs-td16999997.html

to which I got zero replies. Can I close this in my internal bugzilla
as dup/"not my fault"? The stacktrace looks very similar. This was
also ext2 fs mounted (apparently) by ext3 code.

Thanks.

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
