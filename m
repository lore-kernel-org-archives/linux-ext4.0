From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Kernel 3.7.0: bad header/extent
Date: Sat, 15 Dec 2012 23:08:34 -0700
Message-ID: <75A902DB-8A60-4CF5-982A-C32C5AB83C27@dilger.ca>
References: <kainf9$btc$1@ger.gmane.org> <20121216022753.GD9016@thunk.org> <50cd394d.0153650a.3b8d.ffffb917@mx.google.com> <20121216035150.GA6104@thunk.org> <50cd5e9b.0839650a.221f.ffffc460@mx.google.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: =?utf-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail111c7-2520.megamailservers.com ([69.49.98.21]:57437 "EHLO
	mail111c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750845Ab2LPGIl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Dec 2012 01:08:41 -0500
In-Reply-To: <50cd5e9b.0839650a.221f.ffffc460@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-12-15, at 22:39, D=C3=A2niel Fraga <fragabr@gmail.com> wrote:

> On Sat, 15 Dec 2012 22:51:50 -0500
> Theodore Ts'o <tytso@mit.edu> wrote:
>=20
>> Um, really?  **Exactly** the same error message?  That doesn't make
>> any sense.  The error message you quoted happens when the kernel
>> complains that the block numbers in the inode in question are invali=
d
>> (i.e., are too big for the inode in question, or point at file syste=
m
>> metadata).
>=20
>    Yes. The exact same message before and after:
>=20
> EXT4-fs error (device sda2): ext4_ext_check_inode:462: inode #9311628=
:
> comm less: bad header/extent: invalid extent entries - magic f30a,
> entries 1, max 4(4), depth 0(0)
>=20
>> However, debugfs is not showing any extents --- which would be the
>> case after e2fsck repaired the file system (it would have zapped the
>> extent tree for the inode).
>>=20
>> So (a) you did run e2fsck on an unmounted file system right?
>=20
>    Yes, unmounted.
>=20
>> (b) Can you send me the output of:
>>=20
>>    debugfs -R "extents <9311628>" /dev/sda2
>>=20
>> just to be sure we aren't missing anything.
>=20
>    Here it is:
>=20
> debugfs 1.41.12 (17-May-2010)
> Level Entries       Logical              Physical Length Flags
> 0/ 0   1/  1     0 - 4294967295  37333026 - 4332300321      0=20

This is interesting. The one extent reports it is valid for 2^32-1 bloc=
ks, but this isn't possible with the current on-disk extent format. It =
looks like the extent is actually storing "-1" blocks (which is also in=
valid) but is incorrectly sign extended to 0xffffffff.

So e2fsck is allowing this, because it is theoretically possible, but t=
he kernel can't actually use it.

Cheers, Andreas

>> Also, if you are using a really new kernel such as 3.6.x or 3.7.x, y=
ou
>> ***really*** shouldn't be using an ancient version of e2fsprogs such
>> as 1.41.12.  You really should be using e2fsprogs 1.42.x, preferably
>> the latest e2fsprogs 1.42.6.  I wonder if you are seeing a similar
>> message indicating that the file system had previously found an erro=
r,
>> and which wasn't cleared because you are using an ancient version of
>> e2fsprogs....
>=20
>    Ok. The problem is that I'm trapped. I need to compile the most
> recent version (1.42.6) but the needed file to
> compile (/usr/include/dlfcn.h) isn't available (Input/output error)
> because of this problem.=20
>=20
>    But no problem, because I used e2fsck from "Recovery is
> possible 13.7" cd which uses e2fsck 1.42 version (so you can be sure =
I
> used e2fsck 1.42 version).
>=20
>    Any more suggestions? Thanks!
>=20
> --=20
> Linux 3.7.0: Terrified Chipmunk
> http://www.youtube.com/DanielFragaBR
> http://www.libertarios.org.br
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
