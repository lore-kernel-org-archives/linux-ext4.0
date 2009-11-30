From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs/ext2: ext2_readdir comment about returns
Date: Mon, 30 Nov 2009 12:17:56 +0100
Message-ID: <20091130111755.GB4240@quack.suse.cz>
References: <a229bc400911291530s51e1971do402e6441115d70ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, Pavel Machek <pavel@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>, ronny.pretzsch@dfs.de,
	Corentin Chary <corentin.chary@gmail.com>
To: =?iso-8859-1?B?Suly6W15?= Cochoy <jeremy.cochoy@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753665AbZK3LR7@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a229bc400911291530s51e1971do402e6441115d70ee@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

On Mon 30-11-09 00:30:55, J=E9r=E9my Cochoy wrote:
> From:Jeremy Cochoy <jeremy.cochoy@gmail.com>
> I submit a short correction about a comment in ext2/dir.c
>=20
> (I've already send it but it wasn't the good patch format and i didn'=
t
> cc the right people.)
>=20
> PS: Please excuse me if I make mistakes with the netiquette, it's my
> first patch and i wich to send more useful patchs next time, without
> hurting your eyes.
  Thanks for the patch. I'd like to point you to the
Documentation/SubmittingPatches document where is described how a prope=
r
patch submission should look like. Most importantly I miss a Signed-off=
-by
line (item 12 in the document) - without it the patch cannot be merged.
Also your description in the subject is inaccurate. In my opinion it sh=
ould
rather be:
ext2: Fixup description of ext2_find_entry
  Finally, it's easier to handle submitted patches with git tools when =
the
body of email looks like:
Something I want in the changelog additionally to mail subject line
(probably empty in your case).
---
Something that I want to say but should not end up in the changelog.

Patch.

Seeing that you have probably generated your patch from git, git
format-patch and git send-email are useful commands for submitting patc=
hes
via email.

								Honza
