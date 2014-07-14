From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4:dev 8/8] fs/ext4/indirect.c:1462 ext4_ind_remove_space()
 error: we previously assumed 'partial->bh' could be null (see line 1441)
Date: Mon, 14 Jul 2014 06:00:45 -0400
Message-ID: <20140714100045.GB8935@thunk.org>
References: <20140712093409.GX23001@mwanda>
 <alpine.LFD.2.00.1407140853160.13527@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33340 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbaGNKA5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jul 2014 06:00:57 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1407140853160.13527@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2014 at 09:03:37AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.gi=
t dev

> Hi Ted,
>=20
> in which branch is it ? I can not find this commit anywhere in the
> ext4 tree.

It's on the tip of the dev tree, but remember, the dev branch is a
rewinding branch, so the commit id's are not stable.  Patches that are
behind the master branch are guaranteed to be stable, but at the
moment master =3D=3D origin.

What happened is that I had just rewound the dev branch to reflect
v3.16-rc5, since Linus accepted the stable regression fixes right
before he released 3.16-rc5, and to fix the bug you pointed out in
"ext4: rearrange initialization to fix EXT4FS_DEBUG".

(Moving forward to v3.16-rc5 also means that we now have the mm fix
that was causing the data=3Djournal fsx test failures.)

At the moment the commit is 14e4f8cecbc4e (which is the tip of dev).
I don't plan to make any more changes for the three patches currently
on dev:

14e4f8c ext4: fix punch hole on files with indirect mapping
9f2fc8c ext4: remove metadata reservation checks
07dd825 ext4: rearrange initialization to fix EXT4FS_DEBUG

although I wouldn't be surprised if we get more review comments or
find issues with 9f2fc8c and 14e4f8c that require that we fix them up. =
 :-)

Also as a reminder (which you probably know, but this may be useful
for other newer ext4 developers on the list), the dev branch is
(mostly) a dual of the state of the patches on the ext4 patch queue:

https://ext4.wiki.kernel.org/index.php/Ext4_patchsets#The_ext4_patch_qu=
eue

(The reason why I say "mostly" is that I'm not always that good about
making sure I keep the timestamps file up to date, so the instructions
described in the ext4 wiki don't *always* result in exactly the same
commit id's.  Most people don't seem to care, but if this is a
problem, let me know and I can be more anal about updating the
timestamp file when I push out changes to the ext4 patch queue's git
tree.)

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
