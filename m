From: Jim Meyering <jim@meyering.net>
Subject: Re: bug#8411: due to missing sync even on 2.6.39, cp fails to copy an odd file
Date: Sat, 02 Apr 2011 15:50:08 +0200
Message-ID: <8739m0g3u7.fsf@rho.meyering.net>
References: <87fwq0gay0.fsf@rho.meyering.net>
	<4D9724AC.2070009@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: 8411@debbugs.gnu.org, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55991 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab1DBNuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 09:50:22 -0400
Received: from mx.meyering.net (unknown [82.230.74.64])
	by smtp1-g21.free.fr (Postfix) with ESMTP id DB0B69401B5
	for <linux-ext4@vger.kernel.org>; Sat,  2 Apr 2011 15:50:10 +0200 (CEST)
In-Reply-To: <4D9724AC.2070009@draigBrady.com> (=?iso-8859-1?Q?=22P=E1drai?=
 =?iso-8859-1?Q?g?= Brady"'s message of
	"Sat, 02 Apr 2011 14:29:16 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

P=E1draig Brady wrote:
> On 02/04/11 12:16, Jim Meyering wrote:
>> Hi P=E1draig,
>> As of this change,
>>
>>     copy: with fiemap copy, only sync when needed
>>     http://git.savannah.gnu.org/cgit/coreutils.git/commit/?id=3Df698=
76e55
>>
>> fiemap copy with extents beyond EOF can fail on ext4 even with
>> Fedora 15 (2.6.38) and rawhide's 2.6.39 kernel.
>>
>> Here we construct an odd file.  First, preallocate 10MB of space,
>> and then write 5KiB of random data into the beginning of that:
>>
>>     $ fallocate -l 10000000 -n k
>>     $ dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblo=
ck of=3Dk
>>
>> However, when we try to copy "k", we get a file, "k2" of the
>> expected size, but with only NUL bytes for contents:
>
> So the extent info is not updated until sync(),
> which means cp will consider the "unwritten" extent
> as NUL data and not bother to read it :(
>
> I guess this is a corner case that was missed
> in the fixups for ext4 (and btrfs?) in 2.6.38 for this?
> I've copied ext4 devs for clarification.
> I.E. if you do this:
>
>   fallocate -l 10000000 -n k
>   dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock of=
=3Dk
>   filefrag -v k
>
> Do you get all extents still unwritten.
> I do on my 2.6.35.11-83.fc14.i686 kernel, but I expected that.

Right.  The new extent remains unwritten until after a sync
with ext4 on both Fedora 15 and rawhide kernels.

Here's F15:

    $ fallocate -l 10000000 -n k
    $ dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock =
of=3Dk
    ...
    $ filefrag -v k
    Filesystem type is: ef53
    File size of k is 5120 (2 blocks, blocksize 4096)
     ext logical physical expected length flags
       0       0  6498304            2442 unwritten,eof
    k: 1 extent found
    $ sync
    $ filefrag -v k
    Filesystem type is: ef53
    File size of k is 5120 (2 blocks, blocksize 4096)
     ext logical physical expected length flags
       0       0  6498304               2 eof
       1       2  6498306            2440 unwritten,eof
    k: 1 extent found

Same problem with rawhide, but slightly different layout:

    $ fallocate -l 10000000 -n k
    $ dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock =
of=3Dk
    ...
    $ filefrag -v k
    Filesystem type is: ef53
    File size of k is 5120 (2 blocks, blocksize 4096)
     ext logical physical expected length flags
       0       0  2054144            2048 unwritten,eof
       1    2048  2060288  2056191    394 unwritten,eof
    k: 2 extents found
    $ filefrag -v k
    [Exit 1]
    $ sync
    $ filefrag -v k
    Filesystem type is: ef53
    File size of k is 5120 (2 blocks, blocksize 4096)
     ext logical physical expected length flags
       0       0  2054144               2 eof
       1       2  2054146            2046 unwritten,eof
       2    2048  2060288  2056191    394 unwritten,eof
    k: 2 extents found
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
