From: "gnehzuil.liu" <gnehzuil.liu@gmail.com>
Subject: Re: possible dev branch regression - xfstest 285/1k
Date: Tue, 19 Mar 2013 00:54:51 +0800
Message-ID: <6B9FD2E7-4884-484C-BEBB-3E210007B049@gmail.com>
References: <20130315222818.GA16100@wallace> <20130316150923.GA18589@gmail.com> <20130317030648.GA14225@thunk.org> <51473C8B.5070509@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Whitney <enwlinux@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:44371 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3CRQy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2013 12:54:57 -0400
Received: by mail-da0-f49.google.com with SMTP id t11so1430529daj.8
        for <linux-ext4@vger.kernel.org>; Mon, 18 Mar 2013 09:54:57 -0700 (PDT)
In-Reply-To: <51473C8B.5070509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

=D4=DA 2013-3-19=A3=AC=C9=CF=CE=E712:10=A3=ACEric Sandeen <sandeen@redh=
at.com> =D0=B4=B5=C0=A3=BA

> On 3/16/13 10:06 PM, Theodore Ts'o wrote:
>> On Sat, Mar 16, 2013 at 11:09:23PM +0800, Zheng Liu wrote:
>>>=20
>>> I see what's going on.  First of all it isn't a bug. :-)  Please le=
t me
>>> describe why it happens.
>>>=20
>>> In this commit (4f42f80a8f), it tries to fix a bug that we never ze=
ro
>>> out an unwritten extent.  So after applied it, when an unwritten ex=
tent
>>> is converted, it could be zeroed out.  In xfstests #285 subtest 08 =
it
>>> preallocates an unwritten extent which is 4MB.  Then it writes some=
 data
>>> at offset 10 * blocksize, which the length is one blocksize, and ca=
lles
>>> sync_file_range(2) to flush it.
>>=20
>> Specifically, we are now honoring the default setting which sets the
>> max_zeroout_kb value to be 32.  With a 4k block file system, if we
>> were to zeroout the extent, we would have to zero out 40k, which is
>> greater than 32k, so resulting file after pwrite(fd, 4096, 40960)
>> looks like this:
>>=20
>> % filefrag -v /u1/foo08=20
>> Filesystem type is: ef53
>> File size of /u1/foo08 is 4194304 (1024 blocks of 4096 bytes)
>> ext:     logical_offset:        physical_offset: length:   expected:=
 flags:
>>   0:        0..       9:    1852416..   1852425:     10:            =
 unwritten
>>   1:       10..      10:    1852426..   1852426:      1:           =20
>>   2:       11..    1023:    1852427..   1853439:   1013:            =
 unwritten,eof
>> /u1/foo08: 1 extent found
>>=20
>> With a 1k block file system, we only need to zero out 10k, which is
>> less than 32k, and so after pwrite(fd, 1024, 10240), the file looks
>> like this:
>>=20
>> % filefrag -v /mnt/foo08
>> Filesystem type is: ef53
>> File size of /mnt/foo08 is 4194304 (4096 blocks of 1024 bytes)
>> ext:     logical_offset:        physical_offset: length:   expected:=
 flags:
>>   0:        0..      10:      81921..     81931:     11:           =20
>>   1:       11..    4095:      81932..     86016:   4085:            =
 unwritten,eof
>> /mnt/foo08: 1 extent found
>=20
> So the issue is just that the test is looking for actual holes
> in specific locations , but the fs chose to allocate zero-filled
> blocks instead?

Yes, it is.

>=20
>> If we run src/seek_sanity_test by hand, we can make it happy by
>> setting the following configuration option before we run it:
>>=20
>> echo 0 > /sys/fs/ext4/<dev>/extent_max_zeroout_kb
>=20
> The test could do this too, right?
>=20
> _need_to_be_root
>=20
> and:
>=20
> if [ "$FSTYP" =3D=3D "ext4" ]; then
>    ORIG_ZEROOUT_KB=3D`cat /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_k=
b`
>    echo 0 > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_kb
> fi
>=20
> and put it back to default in _cleanup:
>=20
>    echo $ORIG_ZEROOUT_KB > /sys/fs/ext4/$TEST_DEV/extent_max_zeroout_=
kb
>=20
> That way we'd be testing seek hole correctness w/o being subject to
> the vagaries in allocator behavior.

Good idea.  I will try it.

Thanks,
                                                - Zheng--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
