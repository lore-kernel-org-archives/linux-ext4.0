From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: -tip: origin tree build failure (was: [GIT PULL] ext4 update for 2.6.37)
Date: Thu, 28 Oct 2010 10:00:26 -0700
Message-ID: <AANLkTin62vAwJxcsrFk6Yn7Q6tzr-D=EmKKwPazuAJ11@mail.gmail.com>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop> <20101028075631.GA7690@elte.hu>
 <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com> <20101028163854.GA15450@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101028163854.GA15450@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 28, 2010 at 9:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Point taken in any case, i'll read your edited changelog and will cha=
nge the
> template accordingly.
>
> Would this:
>
> =A0Upstream commit 5dabfc7 ("ext4: rename {exit,init}_ext4_*() to
> =A0ext4_{exit,init}_*()"), breaks the build on all[yes/mod]config wit=
h
> =A0CONFIG_EXT4_FS_XATTR disabled:
>
> =A0...
>
> have been better?

Yes. Except for the kernel the default git commit abbreviation is
borderline too short. Seven hex-chars can easily alias with a few more
pulls from me: git will not give aliases at the time it gives a
shorthand, but a month or two later the abbreviated commit may no
longer be unique.

So I suggest using --abbrev=3D12 or similar.

What I ended up writing your commit as was this:

    ext4: fix compile with CONFIG_EXT4_FS_XATTR disabled

    Commit 5dabfc78dced ("ext4: rename {exit,init}_ext4_*() to
    ext4_{exit,init}_*()") causes

      fs/ext4/super.c:4776: error: implicit declaration of function
=91ext4_init_xattr=92

    when CONFIG_EXT4_FS_XATTR is disabled.

    It renamed init_ext4_xattr to ext4_init_xattr but forgot to update =
the
    dummy definition in fs/ext4/xattr.h.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Acked-by: "Theodore Ts'o" <tytso@mit.edu>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

but that's just me.

                   Linus
