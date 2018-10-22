Return-Path: <SRS0=Lb0t=NC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42936 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728674AbeJVTR5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2018 15:17:57 -0400
Date: Mon, 22 Oct 2018 12:59:44 +0200
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Olof Johansson <olof@lxom.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul Lawrence <paullawrence@google.com>,
        Sandipan Das <sandipan@linux.vnet.ibm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Paul Burton <paul.burton@mips.com>,
        David Rientjes <rientjes@google.com>, Willy Tarreau <w@1wt.eu>,
        Martin Sebor <msebor@gmail.com>,
        Christopher Li <sparse@chrisli.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Theodore Ts'o <tytso@mit.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Stefan Agner <stefan@agner.ch>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [GIT PULL] Compiler Attributes for v4.20-rc1
Message-ID: <20181022105944.GA1411@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Here it is the Compiler Attributes series/tree, which tries to disentangle
the include/linux/compiler*.h headers and bring them up to date.

The patches have been in linux-next for a while, *except* the last two
from Nick which came a bit later. Since AFAIU there will be no linux-next
this week, I included them here; but let me know if you prefer
to take them out.

You may see merge conflicts from a few other trees, from what we have
seen in linux-next.

I am not sure if you followed this, so please let me know if there is
anything you don't agree with.

And welcome back!

Cheers,
Miguel

The following changes since commit 17b57b1883c1285f3d0dc2266e8f79286a7bef38:

  Linux 4.19-rc6 (2018-09-30 07:15:35 -0700)

are available in the Git repository at:

  https://github.com/ojeda/linux.git tags/compiler-attributes-for-linus-4.20-rc1

for you to fetch changes up to 1ff2fea5e30ca15752777441ecb64a169fe22e9e:

  compiler-gcc: remove comment about gcc 4.5 from unreachable() (2018-10-19 08:47:30 +0200)

----------------------------------------------------------------
The Compiler Attributes series

This is an effort to disentangle the include/linux/compiler*.h headers
and bring them up to date.

The main idea behind the series is to use feature checking macros
(i.e. __has_attribute) instead of compiler version checks (e.g. GCC_VERSION),
which are compiler-agnostic (so they can be shared, reducing the size
of compiler-specific headers) and version-agnostic.

Other related improvements have been performed in the headers as well,
which on top of the use of __has_attribute it has amounted to a significant
simplification of these headers (e.g. GCC_VERSION is now only guarding
a few non-attribute macros).

This series should also help the efforts to support compiling the kernel
with clang and icc. A fair amount of documentation and comments have also
been added, clarified or removed; and the headers are now more readable,
which should help kernel developers in general.

The series was triggered due to the move to gcc >= 4.6. In turn, this series
has also triggered Sparse to gain the ability to recognize __has_attribute
on its own.

Finally, the __nonstring variable attribute series has been also applied
on top; plus two related patches from Nick Desaulniers for unreachable()
that came a bit afterwards.

----------------------------------------------------------------
Miguel Ojeda (15):
      Compiler Attributes: remove unused attributes
      Compiler Attributes: always use the extra-underscores syntax
      Compiler Attributes: remove unneeded tests
      Compiler Attributes: homogenize __must_be_array
      Compiler Attributes: remove unneeded sparse (__CHECKER__) tests
      Compiler Attributes: add missing SPDX ID in compiler_types.h
      Compiler Attributes: use feature checks instead of version checks
      Compiler Attributes: KENTRY used twice the "used" attribute
      Compiler Attributes: remove uses of __attribute__ from compiler.h
      Compiler Attributes: add Doc/process/programming-language.rst
      Compiler Attributes: add MAINTAINERS entry
      Compiler Attributes: add support for __nonstring (gcc >= 8)
      Compiler Attributes: enable -Wstringop-truncation on W=1 (gcc >= 8)
      Compiler Attributes: auxdisplay: panel: use __nonstring
      Compiler Attributes: ext4: remove local __nonstring definition

ndesaulniers@google.com (2):
      compiler.h: update definition of unreachable()
      compiler-gcc: remove comment about gcc 4.5 from unreachable()

 Documentation/process/index.rst                |   1 +
 Documentation/process/programming-language.rst |  45 +++++
 MAINTAINERS                                    |   5 +
 drivers/auxdisplay/panel.c                     |   7 +-
 fs/ext4/ext4.h                                 |   9 -
 include/linux/compiler-clang.h                 |   5 -
 include/linux/compiler-gcc.h                   |  74 +------
 include/linux/compiler-intel.h                 |   9 -
 include/linux/compiler.h                       |  24 +--
 include/linux/compiler_attributes.h            | 258 +++++++++++++++++++++++++
 include/linux/compiler_types.h                 | 101 ++--------
 scripts/Makefile.extrawarn                     |   1 +
 12 files changed, 345 insertions(+), 194 deletions(-)
 create mode 100644 Documentation/process/programming-language.rst
 create mode 100644 include/linux/compiler_attributes.h
