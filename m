From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: dev branch or master branch?
Date: Fri, 31 May 2013 19:07:07 -0400
Message-ID: <20130531230707.GA23048@thunk.org>
References: <20130531163305.297890@gmx.com>
 <20130531171352.GA6915@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: jon ernst <jonernst07@gmx.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53846 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836Ab3EaXHM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 19:07:12 -0400
Content-Disposition: inline
In-Reply-To: <20130531171352.GA6915@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 01, 2013 at 01:13:52AM +0800, Zheng Liu wrote:
> On Fri, May 31, 2013 at 12:33:05PM -0400, jon ernst wrote:
> > Hi list,
> > =20
> > Patches that people send to this list, =A0are those against to dev =
branch or master branch?
>=20
> You'd better send a patch that bases against dev branch.  You can clo=
ne
> ext4 tree from here:
>   https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/

Note that the dev branch is rewinding, so sometimes patches will drop
from it.  So it is a bit dangerous to base a git branch on the dev
branch if you care about this sort of thing.  But if you are
submitting patches, that shouldn't be a major problem.

Normally the master branch will be between origin and dev (where
origin is the commit from Linus's mainline kernel tree from which we
do development during a particular development cycle).  Currently the
origin branch is at v3.10-rc2.  I had forgotten to push the master
branch forward until very recently; I've just fixed this.

Normally I'll push the master branch forward after the patches have
fully passed a regression test run and we're confident that we don't
need to modify the patches between origin and master.

Hope this helps,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
