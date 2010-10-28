From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: [next-20101038] Call trace in ext4
Date: Thu, 28 Oct 2010 22:15:00 +0200
Message-ID: <AANLkTimw9Vwzy4MXO1t7TnJfwTwYtWcfj0D=Zx8O72cY@mail.gmail.com>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
	<20101028175221.GA1578@arch.trippelsdorf.de>
	<20101028180118.GC6814@thunk.org>
	<20101028193211.GA28126@thunk.org>
	<AANLkTimHJe9bA-X+JWkspgjb4AZkkgbEFWQiwzO-gx-h@mail.gmail.com>
	<20101028200548.GC28126@thunk.org>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, sedat.dilek@gmail.com,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	sfr@canb.auug.org.au,
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101028200548.GC28126@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 28, 2010 at 10:05 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Oct 28, 2010 at 09:54:23PM +0200, Sedat Dilek wrote:
>>
>> Hm, unfortunately NO (see logs).
>>
>> I have compiled via M=3Dfs/ext4 in an already compiled build-tree wi=
th
>> these 3 patches.
>
> Ok, stupid question. =C2=A0You did make sure the new ext4 module was
> loaded, right?
>
>> [ =C2=A0100.884524] ------------[ cut here ]------------
>> [ =C2=A0100.884718] kernel BUG at /home/sd/src/linux-2.6/linux-2.6.3=
6/debian/build/source_i386_none/fs/ext4/inode.c:2721!
>
> OK, so after the patch, line 2721: changed from page_buffers() to:
>
> =C2=A0 =C2=A0if (!page_has_buffers(page))
>
> page_has_buffers() expands to:
>
> #define page_has_buffers(page) =C2=A0PagePrivate(page)
>
> which expands to test_bit() call to see if PG_private1 is set in
> page->flags. =C2=A0There is no BUG_ON anywhere there as far as I can =
tell.
>
> Line 2721 in the older kernel was page_has_buffers() which does have =
a
> BUG_ON check.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-=
 Ted
>

I created a new ext4.ko via "make M=3Dfs/ext4" in the build-dir and
copied the the kernel-module to /lib/modules/$(uname
-r)/kernel/fs/ext4/, is that not enough?
If not, I have to recompile a new kernel.

- Sedat -
