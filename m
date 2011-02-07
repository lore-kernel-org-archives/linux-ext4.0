From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/5] mballoc: trivial code cleanup
Date: Mon, 7 Feb 2011 22:59:54 +0200
Message-ID: <AANLkTimOaQSdJa9aXEs_UM0pAO92S0_zGT5w7kU33etk@mail.gmail.com>
References: <4D4E294E.4080507@coly.li>
	<AANLkTimT3i1oOSh02oTtvN_OmHcYwhNOABLV4cT7VV5p@mail.gmail.com>
	<20110207174125.GB3457@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: i@coly.li, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42002 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab1BGU7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Feb 2011 15:59:54 -0500
Received: by yxt3 with SMTP id 3so1908136yxt.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Feb 2011 12:59:54 -0800 (PST)
In-Reply-To: <20110207174125.GB3457@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 7, 2011 at 7:41 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Feb 06, 2011 at 10:43:58AM +0200, Amir Goldstein wrote:
>> When looking at alloc_sem, I realized that it is only needed to avoi=
d
>> race with adjacent group buddy initialization.
>
> Actually, alloc_sem is used to protect all of the block group specifi=
c
> data structures; the buddy bitmap counters, adjusting the buddy bitma=
p
> itself, the largest free order in a block group, etc. =A0So even in t=
he
> case where block_size =3D=3D page_size, alloc_sem is still needed!
>

This was my assumption by the name of the lock itself, but when I searc=
hed where
down_write(alloc_sem) is called, I saw that it is called by 3 functions=
:
mb_init_group - for lazy init of buddy cache, once per mount per blockg=
roup,
before any alloc routines can access that blockgroup.
add_groupblocks - for online resize, even before lazy init of buddy cac=
he.
init_inode_table - for lazy init of inode table, once per mkfs, per blo=
ckgroup.

it seems to me like down_write(alloc_sem) may be taken in mb_init_group=
()
*only* in case EXT4_MB_GRP_NEED_INIT(grp) and that all down_read(alloc_=
sem)
calls in mballoc.c serve no purpose when block_size =3D=3D page_size.
I concluded that from the comment in mb_load_buddy():

/* Take the read lock on the group alloc
 * sem. This would make sure a parallel
 * ext4_mb_init_group happening on other
 * groups mapped by the page is blocked
 * till we are done with allocation
 */

it says alloc_sem protects against lazy init of adjacent groups
and says nothing about protecting block group specific data structures.=
=2E.

what am I missing???

what am I missing here???
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
