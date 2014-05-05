From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] mke2fs: check for a partition table and warn if
 present
Date: Mon, 5 May 2014 10:20:56 -0400
Message-ID: <20140505142056.GE22287@thunk.org>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <1399295044-24489-3-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051549310.2223@localhost.localdomain>
 <20140505135804.GC22287@thunk.org>
 <alpine.LFD.2.00.1405051606480.2223@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49832 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932752AbaEEOU7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 10:20:59 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405051606480.2223@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 04:11:41PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> Fair enough. But we should still make the use of system libblkid by
> default if you do not have any objections.

What I want to do is test to see if there is a system libblkid
available at all, and if so, use it by default.  I want to be able to
use the internal libblkid for development testing purposes, but the
goal is that when Andreas builds on MacOS, it should use the internal
libblkid by default (since there is no system blkid), but on Linux
systems, we should use the system blkid by default in the 1.43 branch.

> Also it'll be great to mention that in the commit description that
> this is the reason why we still try to use the old approach.

=46air enough.  Actually, we should probably put it in the code
comments.

> blkid_probe_enable_superblocks(pr, 0);

Ok, thanks.

        				- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
