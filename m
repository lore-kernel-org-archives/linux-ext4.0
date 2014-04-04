From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Dirty ext4 blocks system startup
Date: Fri, 4 Apr 2014 11:20:20 -0700
Message-ID: <20140404182020.GA8888@birch.djwong.org>
References: <1459400.cqhC1n3S74@f209>
 <4785109.JJCKTTZWOe@f209>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Markus <M4rkusXXL@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48332 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbaDDSUY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2014 14:20:24 -0400
Content-Disposition: inline
In-Reply-To: <4785109.JJCKTTZWOe@f209>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 04, 2014 at 12:35:45PM +0200, Markus wrote:
> Hi!
> 
> I have a dirty ext4 volume. The system just hangs at startup. After removing that volume from fstab the system starts.
> 
> Mount and e2fsck just flood with "Invalid checksum recovering block 1152 in log" messages.
> 
> (Mounting with ro,noload let me access most files.)
> 
> I also tried the e2fsck from current git.
> 
> debugfs just fails with "Block bitmap checksum does not match bitmap while reading block bitmap". (catastrophic mode does work)
> 
> Three points:
> - e2fsck should not get into an endless loop, blocking the system.
> - mount should not get into an endless loop, blocking the system and flooding the system log.
> - At least e2fsck should fix the filesystem.
> 
> 
> Any help or hints?

Hmm, that's probably a bug in the journal replay code. :(

Can you send me the output of "e2image -r /dev/sdXX - | bzip2 > hd.e2i.bz2" if
it's not too huge?  The exact error messages (if you can capture/photograph
them) would also be useful.

I'm guessing you have metadata_csum enabled...

PS: lkml.org is dead; I'm assuming the URL referenced the discussion "Ext4
Recovery: Invalid checksum recovering block # in log" but it's hard to tell
since there was no subject line provided with that URL.

--D
> 
> 
> Thanks,
> Markus
> 
> 
> PS: Original lkml-mail:
> https://lkml.org/lkml/2014/4/1/467
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
