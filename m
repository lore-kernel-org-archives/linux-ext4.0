From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Space Maps?
Date: Mon, 24 Nov 2014 10:33:36 -0500
Message-ID: <20141124153336.GA10992@thunk.org>
References: <pan.2014.11.24.12.43.51@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47739 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaKXPd5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Nov 2014 10:33:57 -0500
Content-Disposition: inline
In-Reply-To: <pan.2014.11.24.12.43.51@googlemail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 24, 2014 at 12:43:51PM +0000, Holger Hoffst=E4tte wrote:
>=20
> Cleaning out some old research papers I came again across the proposa=
l
> for "space maps" in ext4 [1]. What happened to that? Was it rejected
> due to too much risk or other technical reasons? The benefits sound
> appealing, so I was wondering if there's something fundamentally wron=
g
> with the suggested approach.

No one ever submitted patches. The other issue would be the 71 patents
which Jeff Bonwick claimed in his blog that Sun filed on technologies
relating ZFS.  I wouldn't know whether there are any patents that read
on space maps, because like many companies (due to the United States'
dysfunctional patent system), my employer doesn't allow me to look at
patents --- and so I don't want to know (see previous comments about
the US's dysfunctional patent system).  However, if anyone knows of
space maps being used in some file system before ZFS, that would
certainly be interesting and something that I _would_ want to know.

There is some thinking about using an in-memory AVL tree to track free
space, and demand-loading it from the bitmaps, but no one has had the
time to implement it to date.

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
