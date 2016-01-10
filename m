From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/7] mbcache2: Reimplement mbcache
Date: Sun, 10 Jan 2016 12:14:46 -0700
Message-ID: <3342D7D7-C5A2-421D-9CB0-B7A4DD0A1200@dilger.ca>
References: <1450285224-1525-1-git-send-email-jack@suse.cz> <1450285224-1525-2-git-send-email-jack@suse.cz> <CAHpGcMKzJhsfAFitZEmvbs=C-X=PjmFN5rDSuq-RavZGqOxdGg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	Laurent GUERBY <laurent@guerby.net>, linux-ext4@vger.kernel.org
To: =?utf-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:34804 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314AbcAJTOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Jan 2016 14:14:50 -0500
Received: by mail-ig0-f196.google.com with SMTP id ik10so11656604igb.1
        for <linux-ext4@vger.kernel.org>; Sun, 10 Jan 2016 11:14:50 -0800 (PST)
In-Reply-To: <CAHpGcMKzJhsfAFitZEmvbs=C-X=PjmFN5rDSuq-RavZGqOxdGg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 9, 2016, at 05:11, Andreas Gr=C3=BCnbacher <andreas.gruenbacher@=
gmail.com> wrote:
>=20
> 2015-12-16 18:00 GMT+01:00 Jan Kara <jack@suse.cz>:
>> Original mbcache was designed to have more features than what ext?
>> filesystems ended up using. It supported entry being in more hashes,=
 it
>> had a home-grown rwlocking of each entry, and one cache could cache
>> entries from multiple filesystems. This genericity also resulted in =
more
>> complex locking, larger cache entries, and generally more code
>> complexity.
>>=20
>> This is reimplementation of the mbcache functionality to exactly fit=
 the
>> purpose ext? filesystems use it for. Cache entries are now considera=
bly
>> smaller (7 instead of 13 longs), the code is considerably smaller as
>> well (414 vs 913 lines of code), and IMO also simpler. The new code =
is
>> also much more lightweight.
>>=20
>> I have measured the speed using artificial xattr-bench benchmark, wh=
ich
>> spawns P processes, each process sets xattr for F different files, a=
nd
>> the value of xattr is randomly chosen from a pool of V values. Avera=
ges
>> of runtimes for 5 runs for various combinations of parameters are be=
low.
>> The first value in each cell is old mbache, the second value is the =
new
>> mbcache.
>>=20
>> V=3D10
>> F\P     1               2               4               8           =
    16              32              64
>> 10      0.158,0.157     0.208,0.196     0.500,0.277     0.798,0.400 =
    3.258,0.584     13.807,1.047    61.339,2.803
>> 100     0.172,0.167     0.279,0.222     0.520,0.275     0.825,0.341 =
    2.981,0.505     12.022,1.202    44.641,2.943
>> 1000    0.185,0.174     0.297,0.239     0.445,0.283     0.767,0.340 =
    2.329,0.480     6.342,1.198     16.440,3.888
>>=20
>> V=3D100
>> F\P     1               2               4               8           =
    16              32              64
>> 10      0.162,0.153     0.200,0.186     0.362,0.257     0.671,0.496 =
    1.433,0.943     3.801,1.345     7.938,2.501
>> 100     0.153,0.160     0.221,0.199     0.404,0.264     0.945,0.379 =
    1.556,0.485     3.761,1.156     7.901,2.484
>> 1000    0.215,0.191     0.303,0.246     0.471,0.288     0.960,0.347 =
    1.647,0.479     3.916,1.176     8.058,3.160
>>=20
>> V=3D1000
>> F\P     1               2               4               8           =
    16              32              64
>> 10      0.151,0.129     0.210,0.163     0.326,0.245     0.685,0.521 =
    1.284,0.859     3.087,2.251     6.451,4.801
>> 100     0.154,0.153     0.211,0.191     0.276,0.282     0.687,0.506 =
    1.202,0.877     3.259,1.954     8.738,2.887
>> 1000    0.145,0.179     0.202,0.222     0.449,0.319     0.899,0.333 =
    1.577,0.524     4.221,1.240     9.782,3.579
>>=20
>> V=3D10000
>> F\P     1               2               4               8           =
    16              32              64
>> 10      0.161,0.154     0.198,0.190     0.296,0.256     0.662,0.480 =
    1.192,0.818     2.989,2.200     6.362,4.746
>> 100     0.176,0.174     0.236,0.203     0.326,0.255     0.696,0.511 =
    1.183,0.855     4.205,3.444     19.510,17.760
>> 1000    0.199,0.183     0.240,0.227     1.159,1.014     2.286,2.154 =
    6.023,6.039     ---,10.933      ---,36.620
>>=20
>> V=3D100000
>> F\P     1               2               4               8           =
    16              32              64
>> 10      0.171,0.162     0.204,0.198     0.285,0.230     0.692,0.500 =
    1.225,0.881     2.990,2.243     6.379,4.771
>> 100     0.151,0.171     0.220,0.210     0.295,0.255     0.720,0.518 =
    1.226,0.844     3.423,2.831     19.234,17.544
>> 1000    0.192,0.189     0.249,0.225     1.162,1.043     2.257,2.093 =
    5.853,4.997     ---,10.399      ---,32.198
>>=20
>> We see that the new code is faster in pretty much all the cases and
>> starting from 4 processes there are significant gains with the new c=
ode
>> resulting in upto 20-times shorter runtimes. Also for large numbers =
of
>> cached entries all values for the old code could not be measured as =
the
>> kernel started hitting softlockups and died before the test complete=
d.
>>=20
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>> fs/Makefile              |   2 +-
>> fs/mbcache2.c            | 362 +++++++++++++++++++++++++++++++++++++=
++++++++++
>> include/linux/mbcache2.h |  52 +++++++
>> 3 files changed, 415 insertions(+), 1 deletion(-)
>> create mode 100644 fs/mbcache2.c
>> create mode 100644 include/linux/mbcache2.h
>>=20
>> diff --git a/fs/Makefile b/fs/Makefile
>> index 79f522575cba..15b3d6c4e46a 100644
>> --- a/fs/Makefile
>> +++ b/fs/Makefile
>> @@ -41,7 +41,7 @@ obj-$(CONFIG_COMPAT_BINFMT_ELF)       +=3D compat_=
binfmt_elf.o
>> obj-$(CONFIG_BINFMT_ELF_FDPIC) +=3D binfmt_elf_fdpic.o
>> obj-$(CONFIG_BINFMT_FLAT)      +=3D binfmt_flat.o
>>=20
>> -obj-$(CONFIG_FS_MBCACHE)       +=3D mbcache.o
>> +obj-$(CONFIG_FS_MBCACHE)       +=3D mbcache.o mbcache2.o
>> obj-$(CONFIG_FS_POSIX_ACL)     +=3D posix_acl.o
>> obj-$(CONFIG_NFS_COMMON)       +=3D nfs_common/
>> obj-$(CONFIG_COREDUMP)         +=3D coredump.o
>> diff --git a/fs/mbcache2.c b/fs/mbcache2.c
>> new file mode 100644
>> index 000000000000..283c46e62f5f
>> --- /dev/null
>> +++ b/fs/mbcache2.c
>> @@ -0,0 +1,362 @@
>> +#include <linux/spinlock.h>
>> +#include <linux/slab.h>
>> +#include <linux/list.h>
>> +#include <linux/list_bl.h>
>> +#include <linux/module.h>
>> +#include <linux/sched.h>
>> +#include <linux/mbcache2.h>
>> +
>> +/*
>> + * Mbcache is a simple key-value store. Keys need not be unique, ho=
wever
>> + * key-value pairs are expected to be unique (we use this fact in
>> + * mb2_cache_entry_delete_block()).
>> + *
>> + * Ext2 and ext4 use this cache for deduplication of extended attri=
bute blocks.
>=20
> The term deduplication usually refers to removing existing duplicates=
;
> here we're trying to avoid creating duplicates in the first place
> though.

It can be either. Online deduplication avoids creating duplicate blocks=
 in the first place, offline deduplication is removing duplicates after=
 the fact.=20

Cheers, Andreas--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
