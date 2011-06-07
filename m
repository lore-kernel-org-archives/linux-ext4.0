From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH RFC 01/30] ext4: EXT4 snapshots (Experimental)
Date: Tue, 7 Jun 2011 12:42:14 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106071232070.4754@dhcp-27-109.brq.redhat.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <1304959308-11122-2-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106061512490.3934@dhcp-27-109.brq.redhat.com>
 <BANLkTi=i_42H4mDWRyg325TFw=Z-bVnFqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-174576539-1307443338=:4754"
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab1FGKm1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jun 2011 06:42:27 -0400
In-Reply-To: <BANLkTi=i_42H4mDWRyg325TFw=Z-bVnFqQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-174576539-1307443338=:4754
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 7 Jun 2011, Amir G. wrote:

> >> +config EXT4_FS_SNAPSHOT
> >> +     bool "EXT4 snapshots (Experimental)"
> >> +     depends on EXT4_FS && EXPERIMENTAL
> >> +     default n
> >> +     help
> >> +       Built-in snapshots support for ext4.
> >> +       Requires that the filesystem has the has_snapshot and exclude_bitmap
> >> +       features and that block size is equal to system page size.
> >> +       Snapshots are not supported with 64bit and meta_bg features and the
> >> +       filesystem must be mounted with ordered data mode.
> >
> > What exactly do you mean by not supported with 64bit feature ? Maybe I
> > am being dense, but I do not get it.
> 
> I mean snapshots and 64bit features are mutually exclusive.
> Is that what you got or do I need to make it more clear?

Oh, I did not notice that it belongs to the "feature" word. Thats
probably just my English:)

> 
> >>
> >>  #define outside(b, first, last)      ((b) < (first) || (b) >= (last))
> >>  #define inside(b, first, last)       ((b) >= (first) && (b) < (last))
> >> diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
> >> new file mode 100644
> >> index 0000000..a927090
> >> --- /dev/null
> >> +++ b/fs/ext4/snapshot.h
> >> @@ -0,0 +1,193 @@
> >> +/*
> >> + * linux/fs/ext4/snapshot.h
> >> + *
> >> + * Written by Amir Goldstein <amir73il@users.sf.net>, 2008
> >> + *
> >> + * Copyright (C) 2008-2011 CTERA Networks
> >> + *
> >> + * This file is part of the Linux kernel and is made available under
> >> + * the terms of the GNU General Public License, version 2, or at your
> >> + * option, any later version, incorporated herein by reference.
> >> + *
> >> + * Ext4 snapshot extensions.
> >
> > This is great place to write more about snapshot design and
> > implementation. If it is added later in a different file, then ignore it
> > :).
> 
> the inline documentation is scattered among several patches.
> I should probably also add Documentation/ext4_snapshots.txt
> with some design and overview information.
> And perhaps insert a short short version of it here ;-)

Documentation/filesystems/ext4_snapshots.txt would be the most welcome,
thanks.

> 
> >
> >> + */
> >> +
> >> +#ifndef _LINUX_EXT4_SNAPSHOT_H
> >> +#define _LINUX_EXT4_SNAPSHOT_H
> >> +
> >> +#include <linux/version.h>
> >> +#include <linux/delay.h>
> >> +#include "ext4.h"
> >> +
> >> +
> >> +/*
> >> + * use signed 64bit for snapshot image addresses
> >> + * negative addresses are used to reference snapshot meta blocks
> >> + */
> >> +#define ext4_snapblk_t long long
> >
> > typedef signed long long int ext4_snapblk_t maybe ?
> 
> 1. checkpatch doesn't like adding new typedef to the kernel

Yes, I suppose that the reason is so that people does not add new
typedefs like crazy, but when it is well reasoned I do not think it is a
problem.

> 2. I am in th process of removing that define altogether

And use what instead ? ext4 typedefs helped people to realize what type
to use for what operation and if this type is used often enough and does
make sense (which I do not know since I have not seen the whole series
yet), it can help as well.

> >
> >> +#define SNAPSHOT_IND_PER_BLOCK_GROUP_BITS                    \
> >> +     (SNAPSHOT_BLOCKS_PER_GROUP_BITS-SNAPSHOT_ADDR_PER_BLOCK_BITS)
> >> +#define SNAPSHOT_IND_PER_BLOCK_GROUP                         \
> >> +     (1<<SNAPSHOT_IND_PER_BLOCK_GROUP_BITS) /* 32 */
> >> +#define SNAPSHOT_DIND_BLOCK_GROUPS_BITS                              \
> >> +     (SNAPSHOT_ADDR_PER_BLOCK_BITS-SNAPSHOT_IND_PER_BLOCK_GROUP_BITS)
> >> +#define SNAPSHOT_DIND_BLOCK_GROUPS                           \
> >> +     (1<<SNAPSHOT_DIND_BLOCK_GROUPS_BITS)
> >
> > formating
> 
> ?

#define SNAPSHOT_IND_PER_BLOCK_GROUP_BITS				   \
	(SNAPSHOT_BLOCKS_PER_GROUP_BITS - SNAPSHOT_ADDR_PER_BLOCK_BITS)
#define SNAPSHOT_IND_PER_BLOCK_GROUP					   \
	(1 << SNAPSHOT_IND_PER_BLOCK_GROUP_BITS) /* 32 */ <- 32 what ?
#define SNAPSHOT_DIND_BLOCK_GROUPS_BITS					   \
	(SNAPSHOT_ADDR_PER_BLOCK_BITS - SNAPSHOT_IND_PER_BLOCK_GROUP_BITS)
#define SNAPSHOT_DIND_BLOCK_GROUPS					   \
	(1 << SNAPSHOT_DIND_BLOCK_GROUPS_BITS)

> 
> >
> >> +
> >> +#define SNAPSHOT_BLOCK_OFFSET                                        \
> >> +     (SNAPSHOT_DIR_BLOCKS+SNAPSHOT_IND_BLOCKS)
> >> +#define SNAPSHOT_BLOCK(iblock)                                       \
> >> +     ((ext4_snapblk_t)(iblock) - SNAPSHOT_BLOCK_OFFSET)
> >> +#define SNAPSHOT_IBLOCK(block)                                       \
> >> +     (ext4_fsblk_t)((block) + SNAPSHOT_BLOCK_OFFSET)
> >
> > I do not see SNAPSHOT_BLOCK() defined anywhere.
> >
> 
> Do you mean you don't see it used anywhere?
> It is used by later patches, but I do need to document it's meaning here.

I have missed the define before SNAPSHOT_IBLOCK sorry.

Thanks!
-Lukas
--8323328-174576539-1307443338=:4754--
