From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: After unlinking a large file on ext4, the process stalls for a long time
Date: Wed, 16 Jul 2014 21:37:59 -0600
Message-ID: <59C3F41A-6AFD-418E-BCE6-2361B8140D9A@dilger.ca>
References: <53C687B1.30809@free.fr> <21446.38705.190786.631403@quad.stoffel.home> <53C6B38A.3000100@free.fr>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_61936BE7-F172-4B51-8EBC-C0CC10B7EAEE"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: John Stoffel <john@stoffel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Mason <mpeg.blue@free.fr>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <53C6B38A.3000100@free.fr>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_61936BE7-F172-4B51-8EBC-C0CC10B7EAEE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 16, 2014, at 11:16 AM, Mason <mpeg.blue@free.fr> wrote:
> (I hope you'll forgive me for reformatting the quote characters
> to my taste.)

Thank you.

> On 16/07/2014 17:16, John Stoffel wrote:
>> Mason wrote:
>>> I'm using Linux (3.1.10 at the moment) on a embedded system
>>> similar in spec to a desktop PC from 15 years ago (256 MB RAM,
>>> 800-MHz CPU, USB).
>>=20
>> Sounds like a Raspberry Pi...  And have you investigated using
>> something like XFS as your filesystem instead?
>=20
> The system is a set-top box (DVB-S2 receiver). The system CPU is
> MIPS 74K, not ARM (not that it matters, in this case).
>=20
> No, I have not investigated other file systems (yet).
>=20
>>> I need to be able to create large files (50-1000 GB) "as fast
>>> as possible".  These files are created on an external hard disk
>>> drive, connected over Hi-Speed USB (typical throughput 30 MB/s).
>>=20
>> Really... so you just need to create allocations of space as quickly
>> as possible,
>=20
> I may not have been clear. The creation needs to be fast (in UX terms,
> so less than 5-10 seconds), but it only occurs a few times during the
> lifetime of the system.
>=20
>> which will then be filled in later with actual data?
>=20
> Yes. In fact, I use the loopback device to format the file as an
> ext4 partition.=20
>=20
> The use case is
> - allocate a large file
> - stick a file system on it
> - store stuff (typically video files) inside this "private" FS
> - when the user decides he doesn't need it anymore, unmount and unlink
> (I also have a resize operation in there, but I wanted to get the
> basics before taking the hard stuff head on.)
>=20
> So, in the limit, we don't store anything at all: just create and
> immediately delete. This was my test.

I would agree that LVM is the real solution that you want to use.
It is specifically designed for this, and has much less overhead than
a filesystem on a loopback device on a file on another filesystem.
The amount of space overhead is tuneable, but typically the volumes
are allocated in multiples of 4MB chunks.

That said, I think you've found some kind of strange performance =
problem,
and it is worthwhile to figure this out.

>>> /tmp # time ./foo /mnt/hdd/xxx 5
>>> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [68 ms]
>>> unlink(filename): 0 [0 ms]
>>> 0.00user 1.86system 0:01.92elapsed 97%CPU (0avgtext+0avgdata =
528maxresident)k
>>> 0inputs+0outputs (0major+168minor)pagefaults 0swaps
>>>=20
>>> /tmp # time ./foo /mnt/hdd/xxx 10
>>> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [141 ms]
>>> unlink(filename): 0 [0 ms]
>>> 0.00user 3.71system 0:03.83elapsed 96%CPU (0avgtext+0avgdata =
528maxresident)k
>>> 0inputs+0outputs (0major+168minor)pagefaults 0swaps
>>>=20
>>> /tmp # time ./foo /mnt/hdd/xxx 100
>>> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [1882 ms]
>>> unlink(filename): 0 [0 ms]
>>> 0.00user 37.12system 0:38.93elapsed 95%CPU (0avgtext+0avgdata =
528maxresident)k
>>> 0inputs+0outputs (0major+168minor)pagefaults 0swaps
>>>=20
>>> /tmp # time ./foo /mnt/hdd/xxx 300
>>> posix_fallocate(fd, 0, size_in_GiB << 30): 0 [3883 ms]
>>> unlink(filename): 0 [0 ms]
>>> 0.00user 111.38system 1:55.04elapsed 96%CPU (0avgtext+0avgdata =
528maxresident)k
>>> 0inputs+0outputs (0major+168minor)pagefaults 0swaps

Firstly, have you tried using "fallocate()" directly, instead of
posix_fallocate()?  It may be (depending on your userspace) that
posix_fallocate() is writing zeroes to the file instead of using
the fallocate() syscall, and the kernel is busy cleaning up all
of the dirty pages when the file is unlinked.  You could try using
strace to see what system calls are actually being used.

Secondly, where is the process actually stuck?  =46rom your output
above, the unlink() call takes no measurable time before returning,
so I don't see where it is actually stuck.  Again, running your
test with "strace -tt -T ./foo /mnt/hdd/xxx 300" will show which
syscall is actually taking so much time to complete.  I don't
think it is unlink().

Cheers, Andreas






--Apple-Mail=_61936BE7-F172-4B51-8EBC-C0CC10B7EAEE
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU8dFGHKl2rkXzB/gAQJjYg/+OVbB/LadceVAWWHE6KPzmlf0nNZcPSqZ
6ov56qXeUsndf+TeUkKEWvhnRTPcfa1mQNwPD477NtUJce7yNzEaMCQ18kqSwFgg
7T6Ek2cUGJXxc3VJgtK3GYZN0aQCSWE4EwhSTqSInOloooX7164Mm0JTq+BzNwBP
bZQ7/95S6weipD6PIM/rNSo/iq/6TH99D20qdnb25j0KV6E7WGb+x80okQ9NP/Ix
7VQ6Jw6tlE5EipPxO0+C/KNsOGttafazdk3knT6gSuLvN0yF4gtAJ6l7ZaiRxJQI
Lt2rCTItCmCyccuGp4ZqmO3zQDSw4mPoxlLJxRHlWehtuRbFhaBqSfbfZLJwqpm8
DSHj7vsHGxf0p7ErK4j36TgJtSGAYfcCwW9Pq3jzjKmNoGmz4Hsv2og79x7DRuxL
E+9ac/+wXKAtWQvO2ahxXKNcwfyB0LxCECXUPEYloGmADZQRYJyzmaah+q/8fXjS
iHR4o2EemFXA0BzS257p30DiOyQK9nnYFcFUPfLGWueSCLVGzBEZqR8T/v1MyD8i
JdBSic/2s8wlD6IJUAg5yRRyyxiUfkciwcR8uBev/bCN5GC04WdGEp51TP2Fgvqu
3fMHl5S60WusLoYNxFacZQ41ODYPwdgrtFGZSIPrtFJgWz7m9NcsKdO5B/OZAIxO
V6PCslk1cSk=
=rkkY
-----END PGP SIGNATURE-----

--Apple-Mail=_61936BE7-F172-4B51-8EBC-C0CC10B7EAEE--
