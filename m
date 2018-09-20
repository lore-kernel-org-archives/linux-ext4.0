From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v5 00/15] Compiler Attributes
Date: Thu, 20 Sep 2018 11:18:17 -0700
Message-ID: <CAKwvOdk2O+-FqXU1R8m=vSbZuMGJxY-_4AWd+tFpcTDKhWWFaw@mail.gmail.com>
References: <20180920172301.21868-1-miguel.ojeda.sandonis@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, adilger.kernel@dilger.ca,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>, rostedt@goodmis.org,
        mchehab+samsung@kernel.org, olof@lxom.net,
        konstantin@linuxfoundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul Lawrence <paullawrence@google.com>,
        sandipan@linux.vnet.ibm.com,
        Andrey Konovalov <andreyknvl@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        paul.burton@mips.com, David Rientjes <rientjes@google.c
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920172301.21868-1-miguel.ojeda.sandonis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 20, 2018 at 10:23 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> The Compiler Attributes series is an effort to disentangle
> the include/linux/compiler*.h headers and bring them up to date.
>
> The main idea behind the series is to use feature checking macros
> (i.e. __has_attribute) instead of compiler version checks (e.g. GCC_VERSION),
> which are compiler-agnostic (so they can be shared, reducing the size
> of compiler-specific headers) and version-agnostic.
>
> Other related improvements have been performed in the headers as well,
> which on top of the use of __has_attribute it has amounted to a significant
> simplification of these headers (e.g. GCC_VERSION is now only guarding 4
> non-attribute macros).
>
> This series should also help the efforts to support compiling the kernel
> with clang and icc. A fair amount of documentation and comments have also
> been added, clarified or removed; and the headers are now more readable,
> which should help kernel developers in general.
>
> The series was triggered due to the move to gcc >= 4.6. In turn, this series
> has also triggered Sparse to gain the ability to recognize __has_attribute
> on its own.
>
> Finally, the nonstring variable attribute series has been applied on top
> of this one.
>
> You can also fetch it from:
>
>   https://github.com/ojeda/linux/tree/compiler-attributes-v5
>
> Enjoy!
>
> Cheers,
> Miguel

Thanks for this series.  I've reviewed the rest of the patches in the
series that didn't already have my reviewed by tags on them.  They
look good to go to me.

>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Michal Marek <michal.lkml@markovi.net>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Cc: Olof Johansson <olof@lxom.net>
> Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul Lawrence <paullawrence@google.com>
> Cc: Sandipan Das <sandipan@linux.vnet.ibm.com>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Philippe Ombredanne <pombredanne@nexb.com>
> Cc: Paul Burton <paul.burton@mips.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Martin Sebor <msebor@gmail.com>
> Cc: Christopher Li <sparse@chrisli.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Joe Perches <joe@perches.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Dominique Martinet <asmadeus@codewreck.org>
> Cc: Stefan Agner <stefan@agner.ch>
> Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-ext4@vger.kernel.org
> Cc: linux-sparse@vger.kernel.org
> Cc: linux-kbuild@vger.kernel.org
>
> v4 -> v5
>
>   * Removed the 2 __naked patches, since Greg just applied them to master;
>     and rebased on top of that. The only change in the range-diff is in
>     "Compiler Attributes: always use the extra-underscores syntax" due
>     to the move of __naked to compiler_types.h.
>
>   * Applied the nonstring series on top of this one (last 4 patches).
>     Rationale:
>       - the nonstring series would anyway be modified again by this one
>         (so it has been rebased after the general cleanup).
>       - ext4's "local" nonstring was merged
>       - easier to manage (and easier to see the end result)
>
>     The first 2 patches of the last 4 add the warning back at W=1 and
>     add the __nonstring attribute. The other two serve as an example
>     of usage and as a cleanup.
>
>   * Cc lists removed from each commit; using a single list in the cover letter;
>     and a new, revised list of Cc (wider audience).
>
> Miguel Ojeda (15):
>   Compiler Attributes: remove unused attributes
>   Compiler Attributes: always use the extra-underscores syntax
>   Compiler Attributes: remove unneeded tests
>   Compiler Attributes: homogenize __must_be_array
>   Compiler Attributes: remove unneeded sparse (__CHECKER__) tests
>   Compiler Attributes: add missing SPDX ID in compiler_types.h
>   Compiler Attributes: use feature checks instead of version checks
>   Compiler Attributes: KENTRY used twice the "used" attribute
>   Compiler Attributes: remove uses of __attribute__ from compiler.h
>   Compiler Attributes: add Doc/process/programming-language.rst
>   Compiler Attributes: add MAINTAINERS entry
>   Compiler Attributes: add support for __nonstring (gcc >= 8)
>   Compiler Attributes: enable -Wstringop-truncation on W=1 (gcc >= 8)
>   Compiler Attributes: auxdisplay: panel: use __nonstring
>   Compiler Attributes: ext4: remove local __nonstring definition
>
>  Documentation/process/index.rst               |   1 +
>  .../process/programming-language.rst          |  45 +++
>  MAINTAINERS                                   |   5 +
>  drivers/auxdisplay/panel.c                    |   7 +-
>  fs/ext4/ext4.h                                |   9 -
>  include/linux/compiler-clang.h                |   5 -
>  include/linux/compiler-gcc.h                  |  70 +----
>  include/linux/compiler-intel.h                |   9 -
>  include/linux/compiler.h                      |  19 +-
>  include/linux/compiler_attributes.h           | 258 ++++++++++++++++++
>  include/linux/compiler_types.h                | 101 +------
>  scripts/Makefile.extrawarn                    |   1 +
>  12 files changed, 341 insertions(+), 189 deletions(-)
>  create mode 100644 Documentation/process/programming-language.rst
>  create mode 100644 include/linux/compiler_attributes.h
>
> --
> 2.17.1
>


-- 
Thanks,
~Nick Desaulniers
