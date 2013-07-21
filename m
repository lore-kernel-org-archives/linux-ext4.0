From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fuzzying a user mode linux image often core dumps with
Date: Sat, 20 Jul 2013 21:03:52 -0400
Message-ID: <20130721010352.GB21484@thunk.org>
References: <51EAA7A7.4000104@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	"user-mode-linux-devel@lists.sourceforge.net"
	<user-mode-linux-devel@lists.sourceforge.net>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39611 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab3GUBD6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Jul 2013 21:03:58 -0400
Content-Disposition: inline
In-Reply-To: <51EAA7A7.4000104@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 20, 2013 at 05:07:19PM +0200, Toralf F=F6rster wrote:
> I do run the fuzzer trinity within a 32 bit user mode linux.
> With latest git tree I do often get a core dump like the one attached=
=2E
>=20
> Although it is the nature of trinity to corrupt the kernel /me wonder=
s why it happens nearly alway
> at the same place. That's why I decided to just report it here.

Thanks, this is a known problem for which the fix is can be found here:

	http://patchwork.ozlabs.org/patch/260250/

I hope to get this fixed before -rc2 is released; the only question at
the moment is whether the fix is going to go to Linus via the ext4
tree or the VFS tree....

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
