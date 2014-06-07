From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Reiserfs & ext3 changes for 3.16-rc1
Date: Sat, 7 Jun 2014 16:52:49 -0700
Message-ID: <CA+55aFzPvSGCorqEKRi87oCOrZN5RbUA1uUWq26WR=ZS2pNt+w@mail.gmail.com>
References: <20140604202758.GC22927@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140604202758.GC22927@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 4, 2014 at 1:27 PM, Jan Kara <jack@suse.cz> wrote:
>   Hello Linus,
>
>   could you please pull from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_l=
inus
>
> to get big reiserfs cleanup from Jeff, an ext3 deadlock fix, and some=
 small
> cleanups.

This does not work at all for me:

  fs/reiserfs/do_balan.c: In function =E2=80=98balance_leaf_new_nodes=E2=
=80=99:
  fs/reiserfs/do_balan.c:1248:3: error: implicit declaration of
function =E2=80=98format_bh=E2=80=99 [-Werror=3Dimplicit-function-decla=
ration]
     RFALSE(!buffer_journaled(tb->S_new[i])
     ^

Hmm? "format_bh()"?

           Linus
