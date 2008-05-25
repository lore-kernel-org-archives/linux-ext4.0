From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: bh_count undeclared
Date: Sun, 25 May 2008 19:38:09 -0400
Message-ID: <20080525233809.GG5970@mit.edu>
References: <alpine.DEB.1.10.0805251727040.4890@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64801 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbYEYXid (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 May 2008 19:38:33 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0805251727040.4890@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 25, 2008 at 05:35:12PM +0200, Christian Kujau wrote:
> Hi,
>
> while trying to build the current e2fsprogs.pu git tree, I got:
>
> journal.c: In function =E2=80=98getblk=E2=80=99:
> journal.c:76: error: =E2=80=98bh_count=E2=80=99 undeclared (first use=
 in this function)
>
> When looking at journal.c I see 'bh_count' declared within an #ifdef,=
 but=20
> even when compiling with --enable-jfs-debug the error persists. Right=
 now I=20
> just removed the #ifdef so that the build succeeds.
>
> But, what's the real issue here?

Whoops, my bad.  I was compiling with --enable-jfs-debug, and I didn't
notice the change I made broke things without that configuration
option.

The right fix is just to surround the bh_count reference with an
#ifdef CONFIG_JBD_DEBUG.

It's part of a quickie mechanism for detecting buffer head leaks,
which (for example) was how I detected a problem in ext4's journal
checksum recovery code.  I had made some changes to how it worked
while I was tracking down the problem, and accidentally introduced
that compile time bug.  My bad, I'll fix it.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
