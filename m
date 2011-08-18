From: Christian Brunner <chb@muc.de>
Subject: Re: Kernel 3.0.0 + ext4 + ceph == ...
Date: Thu, 18 Aug 2011 11:19:41 +0200
Message-ID: <CAO47_-9CarhvHYj0R6o=uGsYZzX2J=uwgP1GCjLhZ+v5XKv0-g@mail.gmail.com>
References: <4E33D101.1050504@ufm.su>
	<9BF9E529-C532-4A94-8362-93C2D1B778DB@mit.edu>
	<4E3432FC.9030204@ufm.su>
	<20110730165001.GI7361@thunk.org>
	<Pine.LNX.4.64.1107301016120.23447@cobra.newdream.net>
	<20110730221900.GK7361@thunk.org>
	<Pine.LNX.4.64.1107302149430.23447@cobra.newdream.net>
	<4E353D9E.5080802@ufm.su>
	<Pine.LNX.4.64.1107310951550.2348@cobra.newdream.net>
	<4E35B833.6070304@ufm.su>
	<Pine.LNX.4.64.1107311339530.23447@cobra.newdream.net>
	<80E3795B-C981-492F-9312-DC91D57E4017@mit.edu>
	<Pine.LNX.4.64.1108010918580.6290@cobra.newdream.net>
	<CAO47_-9DmxqfBsBF2K_8ScX_4d-HPz01QeQ-2FFwZS-nCDEOsw@mail.gmail.com>
	<CAC-hyiHzmn25ryJkNUdzQvk7c7chwVDfmwDeo8X2+4zTbDuFGQ@mail.gmail.com>
	<CAO47_-9N0k_OjgUooBtTjGdvTqbAoUTJ-vbqVy8q4=f6YkV_og@mail.gmail.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sage Weil <sage@newdream.net>, Theodore Tso <tytso@mit.edu>,
	Fyodor Ustinov <ufm@ufm.su>, ceph-devel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_-9N0k_OjgUooBtTjGdvTqbAoUTJ-vbqVy8q4=f6YkV_og@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I'm sorry, that I have to correct this:

The problem is still happening with 3.0.1. Although it only seems to
happen under high load now.

I also did some tracing (with 3.0.0 as the problem is easier to
reproduce here). What might be interesting to note is, that the
corruption does not occur, when I do an "strace -f cosd". (Maybe a
race condition?).

To reproduce the problem I have now setup a ceph cluster on a single ma=
chine
with replication between /ceph/osd.000 and /ceph/osd.001.

My setup now has only two active placement groups with 2 objects.

The corruption is happening, when I start replication from osd.000 to
osd.001. It is reproducible most of the time (but not allways), when I
do the following:

# mkfs.ext4 -T largefile /dev/sdb1
# mount -o noatime,user_xattr /dev/sdb1 /ceph/osd.001/
# cosd -i 001 --mkjournal --mkfs --monmap /tmp/monmap
# /usr/bin/cosd -d -i 001 -c /etc/ceph/ceph.conf


### wait until replication has finished and then stop the cosd

# umount /dev/sdb1
# fsck.ext4 -f /dev/sdb
e2fsck 1.41.12 (17-May-2010)
Pass 1: Checking inodes, blocks, and sizes
Inode 43, i_blocks is 8, should be 16.  Fix<y>? no

Inode 2078, i_blocks is 24, should be 16.  Fix<y>? no



I can also provide an e2image with the metadata and the strace output
of the cosd, if this would be helpful.

Regards,
Christian


2011/8/8 Christian Brunner <chb@muc.de>:
> I tried 3.0.1 today, which contains the commit Theodore suggested and
> was no longer able to reproduce the problem.
>
> So I think the corruption we have seen is indeed related to:
>
> commit 7132de744ba76930d13033061018ddd7e3e8cd91
> Author: Maxim Patlasov <maxim.patlasov@gmail.com>
> Date: =A0 Sun Jul 10 19:37:48 2011 -0400
>
> =A0 ext4: fix i_blocks/quota accounting when extent insertion fails
>
>
> I will now try to apply this patch to the RHEL6.1 kernel and see what
> happens...
>
> Thanks for your help.
>
> Christian
>
>
> 2011/8/3 Yehuda Sadeh Weinraub <yehuda.sadeh@dreamhost.com>:
>> On Wed, Aug 3, 2011 at 7:16 AM, Christian Brunner <chb@muc.de> wrote=
:
>> ...
>>> I tried to reproduce this without ceph, but wasn't able to...
>>>
>>> In the meantime it seams, that I can also see the side effects on t=
he
>>> librbd side: I get an "librbd: data error!" when I do an "rbd copy"=
=2E
>>>
>>> When I look at the librbd code this is related to a sparse_read not
>>> returning the right size of the object.
>>>
>>> I don't know if it helps, but I think that the problem is also rela=
ted
>>> to sparse file usage.
>>>
>>
>> There were a few sparse-read issues that we fixed not too long ago,
>> but should have been fixed for at least the previous ceph version. I=
'm
>> not sure what version you're using.
>> There was a ext4 fiemap issue that I was hitting on specific
>> environments but couldn't determine whether it was fixed in later
>> kernel versions (I was using 2.6.32). Now is a good time to try and
>> get to the bottom of it. Here's a script I was using to reproduce it=
:
>>
>> #!/bin/sh
>> dd if=3D/dev/urandom of=3Dbla bs=3D1 seek=3D$((0x6f000)) count=3D$((=
0x1000)); sync
>> dd if=3D/dev/urandom of=3Dbla bs=3D1 seek=3D$((0x70000)) count=3D$((=
0x1000)); sync
>> dd if=3D/dev/urandom of=3Dbla bs=3D1 seek=3D$((0x71000)) count=3D$((=
0x1000)); sync
>> dd if=3D/dev/urandom of=3Dbla bs=3D1 seek=3D$((0x72000)) count=3D$((=
0x1000)); sync
>> dd if=3D/dev/urandom of=3Dbla bs=3D1 seek=3D$((0x73000)) count=3D$((=
0x1000)); sync
>> dd if=3D/dev/urandom of=3Dbla bs=3D1 seek=3D$((0x74000)) count=3D$((=
0x2000)); sync
>> dd if=3D/dev/urandom of=3Dbla bs=3D1 seek=3D$((0x2ae000)) count=3D$(=
(0x2000)); sync
>>
>> You can compile and run the following utility to dump all the extent=
s:
>> http://pastebin.com/h2Cnpk2Q
>>
>> Thanks,
>> Yehuda
>>
>> Oh, btw, You can effectively disable the use of fiemap by setting th=
e
>> 'filestore fiemap threshold' config option with large enough value
>> (e.g., anything bigger than 4 MB should be enough for rbd).
>> --
>> To unsubscribe from this list: send the line "unsubscribe ceph-devel=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
