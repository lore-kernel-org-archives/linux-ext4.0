From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Oops in ext3_block_to_path.isra.40+0x26/0x11b
Date: Fri, 16 Mar 2012 14:09:32 -0700
Message-ID: <CA+55aFwDrh_ODr_3+zEL8f=yJV4_D1sKTStpi8R+fZaxB78VYQ@mail.gmail.com>
References: <alpine.LNX.2.00.1203161623130.18356@pobox.suse.cz> <20120316210446.2198.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jkosina@suse.cz, jack@suse.cz, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44872 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2CPVJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Mar 2012 17:09:54 -0400
In-Reply-To: <20120316210446.2198.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 16, 2012 at 2:04 PM, George Spelvin <linux@horizon.com> wro=
te:
>
> Unfortunately, this is the only time it's happened to me with kernel
> modesetting *on*. =A0Would repeated checksums of a kernel tree be a g=
ood
> way to detect random memory stomping?

Yes, doing filesystem checksums tends to be a good way to find memory
corruption, since a lot of memory tends to be caches.

Another approach is to have a stupid program that allocates an array
of say about half the physical memory, and writes some nicely
recognizable pattern to it. Then, every minute or two, re-check the
pattern.

The advantage of the pattern approach is that it makes it possible to
show things like "these X bytes at offset Y in the page changed",
which can give hints about the source of corruption. The full virtual
address is obviously useless, but the "offset within page" can be
quite useful for figuring out corruption patterns even if you can't
necessarily see which physical page it actually is.

                     Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
