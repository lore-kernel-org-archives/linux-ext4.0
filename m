From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v2] ext4: regression test for wrong assert in ext4_mb_normalize_request()
Date: Wed, 30 Jul 2014 17:26:17 +0800
Message-ID: <53D8BA39.9080205@cn.fujitsu.com>
References: <53CC87A0.1060204@cn.fujitsu.com> <1405913225-1920-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <alpine.LFD.2.00.1407231048490.2207@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <fstests@vger.kernel.org>, <linux-ext4@vger.kernel.org>
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25216 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbaG3J1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2014 05:27:02 -0400
In-Reply-To: <alpine.LFD.2.00.1407231048490.2207@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On 07/23/2014 05:01 PM, Luk=E1=9A Czerner wrote:
> On Mon, 21 Jul 2014, Xiaoguang Wang wrote:
>=20
>>=20
>> +# this test requires the bigalloc feature to be available in mkfs.e=
xt4
>> +#
>> +_require_ext4_mkfs_bigalloc()
>> +{
>> +	_scratch_mkfs_ext4 -O bigalloc >/dev/null 2>&1 \
>> +	   || _notrun "mkfs.ext4 doesn't have bigalloc feature"
>> +}
>> +
>> +# this test requires the ext4 kernel support bigalloc feature
>> +#
>> +_require_ext4_bigalloc()
>> +{
>> +	_scratch_mkfs_ext4 -O bigalloc >/dev/null 2>&1
>> +	_scratch_mount >/dev/null 2>&1 \
>> +	   || _notrun "Ext4 kernel doesn't support bigalloc feature"
>> +	umount $SCRATCH_MNT
>> +}
>=20
> Even though we do not need the distinction here I can see that it
> might be useful when testing mkfs alone, also I can see that xfs is
> doing the same thing so I guess we can be consistent.
>=20
> _scratch_mkfs_ext4 might fail due to incompatible mkfs
> options being passed in with MKFS_OPTIONS. This can be resolved by
> ignoring MKFS_OPTIONS if it fails the first time in
> _scratch_mkfs_ext4() see _scratch_mkfs_xfs().

Got it, new version will be sent soon, thanks!

Regards,
Xiaoguang Wang
>=20
> Also I feel that the same should be done with _scratch_mount because
> again we can have incompatible mount options in MOUNT_OPTIONS, or
> SCRATCH_OPTIONS. But that's a different issue entirely.
>=20
> Thanks!
> -Lukas
>=20
>=20
>> +
>>  # this test requires the finobt feature to be available in mkfs.xfs
>>  #
>>  _require_xfs_mkfs_finobt()
>> diff --git a/tests/ext4/003 b/tests/ext4/003
>> new file mode 100755
>> index 0000000..4ca282f
>> --- /dev/null
>> +++ b/tests/ext4/003
>> @@ -0,0 +1,55 @@
>> +#! /bin/bash
>> +# FS QA Test No. ext4/003
>> +#
>> +# Regression test for commit:
>> +# b5b6077 ext4: fix wrong assert in ext4_mb_normalize_request()
>> +# This testcase checks whether this bug has been fixed.
>> +#
>> +#------------------------------------------------------------------=
-----
>> +# Copyright (c) 2014 Fujitsu.  All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#------------------------------------------------------------------=
-----
>> +
>> +seq=3D`basename $0`
>> +seqres=3D$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +    _scratch_unmount
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +_supported_fs ext4
>> +_supported_os Linux
>> +
>> +_require_scratch
>> +_require_ext4_mkfs_bigalloc
>> +_require_ext4_bigalloc
>> +
>> +rm -f $seqres.full
>> +
>> +yes | mkfs.ext4 -O bigalloc -C 65536  -g 256 $SCRATCH_DEV 512m \
>> +    >> $seqres.full 2>&1
>=20
> Here you should really be using
>=20
> _scratch_mkfs_ext4
>=20
>> +_scratch_mount || _fail "couldn't mount fs"
>> +
>> +dd if=3D/dev/zero of=3D$SCRATCH_MNT/testfile bs=3D1M count=3D256 2>=
&1 | _filter_dd
>> +
>> +echo "Slience is golden"
>> +
>> +status=3D0
>> +exit
>> diff --git a/tests/ext4/003.out b/tests/ext4/003.out
>> new file mode 100644
>> index 0000000..07f245d
>> --- /dev/null
>> +++ b/tests/ext4/003.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 003
>> +Slience is golden
>> diff --git a/tests/ext4/group b/tests/ext4/group
>> index 7e66035..152196c 100644
>> --- a/tests/ext4/group
>> +++ b/tests/ext4/group
>> @@ -5,6 +5,7 @@
>>  #
>>  001 auto prealloc quick
>>  002 auto quick prealloc
>> +003 auto quick
>>  271 auto rw quick
>>  301 aio dangerous ioctl rw stress
>>  302 aio dangerous ioctl rw stress
>>
> .
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
