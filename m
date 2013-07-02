From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Date: Tue, 2 Jul 2013 10:18:32 -0700
Message-ID: <CA+55aFyRLc81s03ULLZ26N0qwRqxS-9+6XpyhxVH62qx2b5o2A@mail.gmail.com>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <nsxbo6mxu38.fsf@lambda.thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hmm I'm getting this compiler warning:

  fs/ext4/inode.c: In function =E2=80=98ext4_writepages=E2=80=99:
  fs/ext4/inode.c:2219:6: warning: =E2=80=98err=E2=80=99 may be used un=
initialized in
this function [-Wmaybe-uninitialized]

and I think the compiler is right to warn. The 'err' variable is set
inside a whilte() and an if() statement, and it is not at all obvious
that those codepaths are always taken.

Maybe that "map->m_len" is always guaranteed to be nonzero, and the
"while()" statement could be a "do { } while()" one. But if so, make
it so, don't write code as if it might never be executed, when the
return value seems to *depend* on it being executed.

Or just initialize the variable correctly.

This warning may not be new to this pull, I just happened to notice it =
now.

                Linus
