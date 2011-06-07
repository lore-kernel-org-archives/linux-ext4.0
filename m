From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 01/30] ext4: EXT4 snapshots (Experimental)
Date: Tue, 7 Jun 2011 16:20:53 +0300
Message-ID: <BANLkTi=JQfmpJBuxKxNM61FqN3=x66_qgQ@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<1304959308-11122-2-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106061512490.3934@dhcp-27-109.brq.redhat.com>
	<BANLkTi=i_42H4mDWRyg325TFw=Z-bVnFqQ@mail.gmail.com>
	<alpine.LFD.2.00.1106071232070.4754@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50974 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab1FGNUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 09:20:54 -0400
Received: by wwa36 with SMTP id 36so4921282wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 06:20:53 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1106071232070.4754@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 7, 2011 at 1:42 PM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> On Tue, 7 Jun 2011, Amir G. wrote:
>
>> >> +config EXT4_FS_SNAPSHOT
>> >> + =A0 =A0 bool "EXT4 snapshots (Experimental)"
>> >> + =A0 =A0 depends on EXT4_FS && EXPERIMENTAL
>> >> + =A0 =A0 default n
>> >> + =A0 =A0 help
>> >> + =A0 =A0 =A0 Built-in snapshots support for ext4.
>> >> + =A0 =A0 =A0 Requires that the filesystem has the has_snapshot a=
nd exclude_bitmap
>> >> + =A0 =A0 =A0 features and that block size is equal to system pag=
e size.
>> >> + =A0 =A0 =A0 Snapshots are not supported with 64bit and meta_bg =
features and the
>> >> + =A0 =A0 =A0 filesystem must be mounted with ordered data mode.
>> >
>> > What exactly do you mean by not supported with 64bit feature ? May=
be I
>> > am being dense, but I do not get it.
>>
>> I mean snapshots and 64bit features are mutually exclusive.
>> Is that what you got or do I need to make it more clear?
>
> Oh, I did not notice that it belongs to the "feature" word. Thats
> probably just my English:)

Or a combination of our 'Englishes' ;-)

>
>>
>> >>
>> >> =A0#define outside(b, first, last) =A0 =A0 =A0((b) < (first) || (=
b) >=3D (last))
>> >> =A0#define inside(b, first, last) =A0 =A0 =A0 ((b) >=3D (first) &=
& (b) < (last))
>> >> diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
>> >> new file mode 100644
>> >> index 0000000..a927090
>> >> --- /dev/null
>> >> +++ b/fs/ext4/snapshot.h
>> >> @@ -0,0 +1,193 @@
>> >> +/*
>> >> + * linux/fs/ext4/snapshot.h
>> >> + *
>> >> + * Written by Amir Goldstein <amir73il@users.sf.net>, 2008
>> >> + *
>> >> + * Copyright (C) 2008-2011 CTERA Networks
>> >> + *
>> >> + * This file is part of the Linux kernel and is made available u=
nder
>> >> + * the terms of the GNU General Public License, version 2, or at=
 your
>> >> + * option, any later version, incorporated herein by reference.
>> >> + *
>> >> + * Ext4 snapshot extensions.
>> >
>> > This is great place to write more about snapshot design and
>> > implementation. If it is added later in a different file, then ign=
ore it
>> > :).
>>
>> the inline documentation is scattered among several patches.
>> I should probably also add Documentation/ext4_snapshots.txt
>> with some design and overview information.
>> And perhaps insert a short short version of it here ;-)
>
> Documentation/filesystems/ext4_snapshots.txt would be the most welcom=
e,
> thanks.

I though I'd just drop the Technical_Overview wiki as ext4_snapshots.tx=
t:
http://sourceforge.net/apps/mediawiki/next3/index.php?title=3DTechnical=
_overview
it seems like a good start, which can be completed by diving into the c=
ode.
would you agree with that statement?

>
>>
>> >
>> >> + */
>> >> +
>> >> +#ifndef _LINUX_EXT4_SNAPSHOT_H
>> >> +#define _LINUX_EXT4_SNAPSHOT_H
>> >> +
>> >> +#include <linux/version.h>
>> >> +#include <linux/delay.h>
>> >> +#include "ext4.h"
>> >> +
>> >> +
>> >> +/*
>> >> + * use signed 64bit for snapshot image addresses
>> >> + * negative addresses are used to reference snapshot meta blocks
>> >> + */
>> >> +#define ext4_snapblk_t long long
>> >
>> > typedef signed long long int ext4_snapblk_t maybe ?
>>
>> 1. checkpatch doesn't like adding new typedef to the kernel
>
> Yes, I suppose that the reason is so that people does not add new
> typedefs like crazy, but when it is well reasoned I do not think it i=
s a
> problem.
>
>> 2. I am in th process of removing that define altogether
>
> And use what instead ? ext4 typedefs helped people to realize what ty=
pe
> to use for what operation and if this type is used often enough and d=
oes
> make sense (which I do not know since I have not seen the whole serie=
s
> yet), it can help as well.
>

I found a bug last week with accessing the last 4M of a 16TB snapshot f=
ile.
it was caused by conversion from ext4_snapblk_t to ext4_lblk_t in
ext4_blk_to_path(),
so I am dropping the different offset type approach and going handle
the snapshot
file offset translation inside ext4_blk_to_path().
I won't get into it here. You will see it on the next (full) patch
series I will post.

>> >
>> >> +#define SNAPSHOT_IND_PER_BLOCK_GROUP_BITS =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0\
>> >> + =A0 =A0 (SNAPSHOT_BLOCKS_PER_GROUP_BITS-SNAPSHOT_ADDR_PER_BLOCK=
_BITS)
>> >> +#define SNAPSHOT_IND_PER_BLOCK_GROUP =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 \
>> >> + =A0 =A0 (1<<SNAPSHOT_IND_PER_BLOCK_GROUP_BITS) /* 32 */
>> >> +#define SNAPSHOT_DIND_BLOCK_GROUPS_BITS =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> >> + =A0 =A0 (SNAPSHOT_ADDR_PER_BLOCK_BITS-SNAPSHOT_IND_PER_BLOCK_GR=
OUP_BITS)
>> >> +#define SNAPSHOT_DIND_BLOCK_GROUPS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 \
>> >> + =A0 =A0 (1<<SNAPSHOT_DIND_BLOCK_GROUPS_BITS)
>> >
>> > formating
>>
>> ?
>
> #define SNAPSHOT_IND_PER_BLOCK_GROUP_BITS =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0(SNAPSHOT_BLOCKS_PER_GROUP_BITS - SNAPSHOT_ADDR_PER_BL=
OCK_BITS)
> #define SNAPSHOT_IND_PER_BLOCK_GROUP =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> =A0 =A0 =A0 =A0(1 << SNAPSHOT_IND_PER_BLOCK_GROUP_BITS) /* 32 */ <- 3=
2 what ?
> #define SNAPSHOT_DIND_BLOCK_GROUPS_BITS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> =A0 =A0 =A0 =A0(SNAPSHOT_ADDR_PER_BLOCK_BITS - SNAPSHOT_IND_PER_BLOCK=
_GROUP_BITS)
> #define SNAPSHOT_DIND_BLOCK_GROUPS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
> =A0 =A0 =A0 =A0(1 << SNAPSHOT_DIND_BLOCK_GROUPS_BITS)
>

OK. thanks.

>>
>> >
>> >> +
>> >> +#define SNAPSHOT_BLOCK_OFFSET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> >> + =A0 =A0 (SNAPSHOT_DIR_BLOCKS+SNAPSHOT_IND_BLOCKS)
>> >> +#define SNAPSHOT_BLOCK(iblock) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> >> + =A0 =A0 ((ext4_snapblk_t)(iblock) - SNAPSHOT_BLOCK_OFFSET)
>> >> +#define SNAPSHOT_IBLOCK(block) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> >> + =A0 =A0 (ext4_fsblk_t)((block) + SNAPSHOT_BLOCK_OFFSET)
>> >
>> > I do not see SNAPSHOT_BLOCK() defined anywhere.
>> >
>>
>> Do you mean you don't see it used anywhere?
>> It is used by later patches, but I do need to document it's meaning =
here.
>
> I have missed the define before SNAPSHOT_IBLOCK sorry.
>
> Thanks!
> -Lukas
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
