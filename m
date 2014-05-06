From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 3/3] mke2fs: check for a partition table and warn if
 present
Date: Tue, 6 May 2014 14:20:31 +0200
Message-ID: <20140506122031.GQ5962@x2.net.home>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <1399295044-24489-3-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051549310.2223@localhost.localdomain>
 <20140505135804.GC22287@thunk.org>
 <alpine.LFD.2.00.1405051606480.2223@localhost.localdomain>
 <20140505142056.GE22287@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbaEFMUf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 08:20:35 -0400
Content-Disposition: inline
In-Reply-To: <20140505142056.GE22287@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 10:20:56AM -0400, Theodore Ts'o wrote:
> On Mon, May 05, 2014 at 04:11:41PM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
> >=20
> > Fair enough. But we should still make the use of system libblkid by
> > default if you do not have any objections.
>=20
> What I want to do is test to see if there is a system libblkid
> available at all, and if so, use it by default.  I want to be able to
> use the internal libblkid for development testing purposes, but the
> goal is that when Andreas builds on MacOS, it should use the internal
> libblkid by default (since there is no system blkid), but on Linux
> systems, we should use the system blkid by default in the 1.43 branch=
=2E

BTW, util-linux is not Linux only (although code portability is bonus
rather than a primary goal :-). We have BSD, Solaris and GNU Hurd users=
=2E=20

The plan for the next release (v2.25) is to support libs-only builds
(for example build and install libblkid and libuuid, but nothing
else).

    Karel

--=20
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
