From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Mon, 5 Oct 2015 09:23:15 -0700
Message-ID: <5612A3F3.2040609@linux.intel.com>
References: <20151005152236.GA8140@thunk.org>
 <CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/05/2015 08:58 AM, Linus Torvalds wrote:
=2E..
> Dave, mind sharing the micro-benchmark or perhaps even just a kernel
> profile of it? How is that "iov_iter_fault_in_readable()" so
> noticeable? It really shouldn't be a big deal.

The micro was just plugging this test:

	https://www.sr71.net/~dave/intel/write1byte.c

In to will-it-scale:

	https://github.com/antonblanchard/will-it-scale

iov_iter_fault_in_readable() shows up as the third-most expensive kerne=
l
function in a profile:

>      7.45%  write1byte_proc  [kernel.kallsyms]     [k] copy_user_enha=
nced_fast_string=20
>      6.51%  write1byte_proc  [kernel.kallsyms]     [k] unlock_page   =
                =20
>      6.04%  write1byte_proc  [kernel.kallsyms]     [k] iov_iter_fault=
_in_readable    =20
>      5.23%  write1byte_proc  libc-2.20.so          [.] __GI___libc_wr=
ite             =20
>      4.86%  write1byte_proc  [kernel.kallsyms]     [k] entry_SYSCALL_=
64              =20
>      4.48%  write1byte_proc  [kernel.kallsyms]     [k] iov_iter_copy_=
from_user_atomic=20
>      3.94%  write1byte_proc  [kernel.kallsyms]     [k] generic_perfor=
m_write         =20
>      3.74%  write1byte_proc  [kernel.kallsyms]     [k] mutex_lock    =
                =20
>      3.59%  write1byte_proc  [kernel.kallsyms]     [k] entry_SYSCALL_=
64_after_swapgs =20
>      3.55%  write1byte_proc  [kernel.kallsyms]     [k] find_get_entry=
                =20
>      3.53%  write1byte_proc  [kernel.kallsyms]     [k] vfs_write     =
                =20
>      3.17%  write1byte_proc  [kernel.kallsyms]     [k] find_lock_entr=
y               =20
>      3.17%  write1byte_proc  [kernel.kallsyms]     [k] put_page      =
                =20

The disassembly points at the stac/clac pair being the culprits inside
the function (copy/paste from 'perf top' disassebly here):

=2E..
>        =E2=94=82      stac
>  24.57 =E2=94=82      mov    (%rcx),%sil
>  15.70 =E2=94=82      clac
>  28.77 =E2=94=82      test   %eax,%eax
>   2.15 =E2=94=82      mov    %sil,-0x1(%rbp)
>   8.93 =E2=94=82    =E2=86=93 jne    66
>   2.31 =E2=94=82      movslq %edx,%rdx

One thing I've been noticing on Skylake is that barriers (implicit and
explicit) are showing up more in profiles.  What we're seeing here
probably isn't actually stac/clac overhead, but the cost of finishing
some other operations that are outstanding before we can proceed throug=
h
here.
