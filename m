From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] lib/ext2fs: =?iso-8859-1?Q?Use?=
 =?iso-8859-1?Q?_=5F=5Fbuiltin=5Fpopcount_when_available_Signed-off-by=3A_?=
 =?iso-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
Date: Sun, 6 Jan 2013 17:20:20 -0500
Message-ID: <20130106222020.GA9482@thunk.org>
References: <1357484683-3021-1-git-send-email-crrodriguez@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42048 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab3AGA0d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jan 2013 19:26:33 -0500
Content-Disposition: inline
In-Reply-To: <1357484683-3021-1-git-send-email-crrodriguez@opensuse.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 06, 2013 at 12:04:43PM -0300, Cristian Rodr=EDguez wrote:
> diff --git a/lib/ext2fs/bitops.c b/lib/ext2fs/bitops.c
> index 7c3f215..0668469 100644
> --- a/lib/ext2fs/bitops.c
> +++ b/lib/ext2fs/bitops.c
> @@ -125,11 +125,15 @@ static unsigned int popcount8(unsigned int w)
> =20
>  static unsigned int popcount32(unsigned int w)
>  {
> +#if __GNUC__ > 3 || (__GNUC__ =3D=3D 3 && __GNUC_MINOR__ >=3D 4)
> +	return __builtin_popcount(w);
> +#else

The problem is that if you compile popcount32 with your patch on an
x86 using gcc 4.7.2 and run it on a Intel core i7 CPU without using
the -march=3Dcore-avx-i compiler option, __builtin_popcount() is 18%
***slower*** than the optimized, non-looping code that is currently in
e2fsprogs.  And if you do compile with -march=3Dcore-avx-i, then of
course it's faster, but most distributions won't be able to use that
compiler option, since the resulting binary will crash on older intel
CPU's.  So by default, accepting this patch will slow down things, not
speed things up, for the most common case.

I could imagine a patch which explicitly checks the CPU type using the
x86 cpuinfo instructure, and only optionally uses the popcount
instruction if it exists, and uses the optimized code if it doesn't,
but then again, it's not clear how much it's worth it.

The difference it makes when checking 4TB's worth of bitmaps is negligi=
ble:

slow popcount: 0.2623
fast popcount: 0.0700

=46or a 128TB file system worth of bitmaps, the time difference is more
measurable:

slow popcount: 8.0185
fast popcount: 2.2066

=2E.. but running e2fsck on an empty 128TB file system uses 202 CPU
seconds (assuming all of the fs metadata bocks are in cache).  So
trying to use the popcount instruction would save at most 3%.  (For
comparison, e2fsck form 1.42.6 takes 392.7 CPU seconds, so we've
already gotten most of the speed improvements already).

Still, 6 CPU seconds is 6 CPU seconds.... but only if it applies for
the vast majority of e2fsprogs users, which means (a) people who are
using distributions which provide compiled binaries, such as SuSE,
OpenSuSE, RHEL, Fedora, Debian, Ubuntu, etc., and (b) people who are
running on an x86 CPU.

So if you'd like to write a patch which explicitly uses x86-specific
__asm__ statements to call cpuinfo and popcount explicitly, I'd be
happy to take such a patch.

Better yet would be if gcc was taught how to recognize the C
statements in popcount32(), since that's one of the standard,
intelligent ways of implementing popcount32 (as opposed to the stupid
way which is apparently used by gcc's runtime library, sigh), and
inserted code which automatically did the cpuinfo check and fallback
to popcount if the CPU supports it.  This would be even better since
then gcc could do a single cpuinfo check, and then automatically use
the faster SSE[234] instructions as necessary, without having to ask
application programmers to put in gcc-specific __builtin_* functions
which have the property of pessimizing the application, if you don't
ask GCC to build a cpu-specific executable which crashes and burns if
run on an older CPU....

Regards,

						- Ted


P.S.  This is what __popcountdi2 looks like from gcc 4.7.2's runtime.
Note the looping construct, which is perhaps one of the more stupider
ways to implement popcount.  Whoever implemented this should get 100
flogs with a wet noodle....

0000000000400520 <__popcountdi2>:
  400520:	 48 8b 35 99 ab 2a 00	mov    0x2aab99(%rip),%rsi
  400527:	 31 c0                	xor    %eax,%eax
  400529:	 31 c9                	xor    %ecx,%ecx
  40052b:	 0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  400530:	 48 89 fa             	mov    %rdi,%rdx
  400533:	 48 d3 ea             	shr    %cl,%rdx
  400536:	 83 c1 08             	add    $0x8,%ecx
  400539:	 81 e2 ff 00 00 00    	and    $0xff,%edx
  40053f:	 0f b6 14 16          	movzbl (%rsi,%rdx,1),%edx
  400543:	 01 d0                	add    %edx,%eax
  400545:	 83 f9 40             	cmp    $0x40,%ecx
  400548:	 75 e6                	jne    400530 <__popcountdi2+0x10>
  40054a:	 f3 c3                	repz retq=20
  40054c:	 90                   	nop
  40054d:	 90                   	nop
  40054e:	 90                   	nop
  40054f:	 90                   	nop

Compare and contrast that with what we are using in e2fsprogs:

  	unsigned int res =3D w - ((w >> 1) & 0x55555555);
  	res =3D (res & 0x33333333) + ((res >> 2) & 0x33333333);
  	res =3D (res + (res >> 4)) & 0x0F0F0F0F;
  	res =3D res + (res >> 8);
  	return (res + (res >> 16)) & 0x000000FF;

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
