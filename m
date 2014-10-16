From: Dmitry Monakhov <dmonlist@gmail.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:2982!
Date: Fri, 17 Oct 2014 02:03:45 +0400
Message-ID: <87egu7k6ym.fsf@openvz.org>
References: <20141016055718.GA17655@redhat.com> <871tq8pdh4.fsf@openvz.org> <20141016143346.GA9910@redhat.com> <20141016201504.GA24798@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141016201504.GA24798@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dave Jones <davej@redhat.com> writes:

> On Thu, Oct 16, 2014 at 10:33:46AM -0400, Dave Jones wrote:
>
>  >  > Try this patch http://www.spinics.net/lists/linux-ext4/msg45683.html
>  >=20
>  > I'll give it a try if I can get it reproducing easily, otherwise I cna=
't say
>  > either way whether the patch is doing any good.
>
> ok, I managed to reproduce it a few times, and then tried again with
> your patch.  I'm not sure if it's related, but I'm now seeing lockups
> in ext4.  The process that gets stuck looks like this..
99.99% this one is not related. This is just one more uncovered one
by trinity magics. Looks like I've got what is wrong
lseek SEEK_HOLE/SEEK_DATA try to find block allocated one by one
instead of using ext4_ext_next_allocated_block() COMMIT c8c0df24
Plese look an my test below. I'm too tired for today (especially
after Gone girl the movie). I'll send patch tomorrow.
>
> trinity-c21     R  running task    13232  9781    831 0x10000004
>  0000000000000000 0000000000000001 0000000000000000 0000000000000000
>  ffff8800c8d333d8 0000000000000000 0000000000000002 00000000cacaa650
>  ffff880217cf7db8 0000000000000000 0000000000000000 ffffffffa929ff8c
> Call Trace:
>  [<ffffffffa929ff8c>] ? ext4_map_blocks+0x31c/0x560
>  [<ffffffffa929fe75>] ? ext4_map_blocks+0x205/0x560
>  [<ffffffffa92e689c>] ? ext4_es_find_delayed_extent_range+0x48c/0x4e0
>  [<ffffffffa9298fe1>] ? ext4_llseek+0x261/0x3f0
>  [<ffffffffa922e6e9>] ? __fdget_pos+0x49/0x50
>  [<ffffffffa90e484e>] ? rcu_read_lock_held+0x6e/0x80
>  [<ffffffffa920ca44>] ? SyS_lseek+0x94/0xc0
>
> I've got to run right now, but I'll look into tracing it some more when I=
 get back.
>
> 	Dave

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQEDCAAoJEFzOBSYIXfveYnMP/jhrHc5AtCoghjkMwt/2Vq5W
7c6gTiiAeoRaPqdxhXoya0iGZPwnheQSeChOWoQllgNpu54ZgwhSWMa5sm9/ZXr8
Zv2z7ZdjXsb1Ld6FPY0t3qL6+rvIqh1FgmOtsIyYprfBpekjXn4jzfXTD5OJf3g5
wOsindZilPd+BXXKu6yJYGcZ4qNFV63Zf85jAnhbLUaROUVU2CSrQ7nPrx865Nu6
stgwXExamr4oyBoOMZrjhuRUbq3yb/uXi4Y86G6BnRSIO5MdmgYmDBEqukT9hW2V
T2zPDqf/jn3idmTolBNGRTZhQzdhuQAEFSh8K72CIVJcvhRbvcNpivVNVft3NXr9
H7mwH3vyFf2msBbWeAD5WxHRa05oHnqzzVLlz8OW1iRpdj9LbFwa9jKmw9uKnDRv
iN95S/KlblIMk57S9snTIen43t9DNsHsLv8pdp36k3uNpfbrUG0Re6i0c9XeCNf8
r5fvTi9iY25/8aEPByZN6YGYVDCzVbyRSP27GBrFfRjX1W+xBoWUqSZMa5oWEvzB
kQauafQRv98raxT8vemlWmjn+cqHDFB5wrlp8IAV2MCAFvNO+nXGBp1ZhSD+ztpV
Z7s2XyLS82NNf9em5FUhjXBqQAZvzBhVjoKd9+coYCJFvdD9gLkFYZctmLqrOxct
glIef+IrwyuX3dqpCdXZ
=6lIW
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=lseek.c

/*
 * regression test for bug in ext4_seek_data
 *  (C) Dmitry Monakhov 
 * original report https://lkml.org/lkml/2014/10/16/620
 */		
#define _GNU_SOURCE
#define _LARGEFILE_SOURCE
#define _FILE_OFFSET_BITS 64
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>

#ifndef SEEK_DATA
#define SEEK_DATA       3
#endif

int main(int argc, char **argv)
{
        int fd;
        loff_t size = 1ULL << 40;
        fd = open("test", O_RDWR|O_CREAT, 0777);
        ftruncate(fd, size);
        size = 1ULL << 39;
	/* Next line will likely spin forever :) */
        llseek(fd, size, SEEK_DATA);
        return 0;
}

--=-=-=--
