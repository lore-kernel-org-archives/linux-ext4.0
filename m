From: Florian Weimer <fweimer@bfk.de>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Mon, 24 Aug 2009 11:19:01 +0000
Message-ID: <82k50tjw7u.fsf@mid.bfk.de>
References: <20090312092114.GC6949@elf.ucw.cz>
	<200903121413.04434.rob@landley.net>
	<20090316122847.GI2405@elf.ucw.cz>
	<200903161426.24904.rob@landley.net>
	<20090323104525.GA17969@elf.ucw.cz>
	<87ljqn82zc.fsf@frosties.localdomain>
	<20090824093143.GD25591@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090824093143.GD25591@elf.ucw.cz> (Pavel Machek's message of "Mon\, 24 Aug 2009 11\:31\:43 +0200")
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

* Pavel Machek:

> +Linux block-backed filesystems can only work correctly when several
> +conditions are met in the block layer and below (disks, flash
> +cards). Some of them are obvious ("data on media should not change
> +randomly"), some are less so.

You should make clear that the file lists per-file-system rules and
that some file sytems can recover from some of the error conditions.

> +* don't damage the old data on a failed write (ATOMIC-WRITES)
> +
> +	(Thrash may get written into sectors during powerfail.  And
> +	ext3 handles this surprisingly well at least in the
> +	catastrophic case of garbage getting written into the inode
> +	table, since the journal replay often will "repair" the
> +	garbage that was written into the filesystem metadata blocks.

Isn't this by design?  In other words, if the metadata doesn't survive
non-atomic writes, wouldn't it be an ext3 bug?

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
