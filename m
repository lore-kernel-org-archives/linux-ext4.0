From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: E2fsprogs git tree
Date: Tue, 07 Aug 2007 18:23:46 +0200
Message-ID: <46B89C92.5060302@bull.net>
References: <E1I7ukw-0001ht-T0@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60239 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXHGQXJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Aug 2007 12:23:09 -0400
In-Reply-To: <E1I7ukw-0001ht-T0@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Ts'o wrote:
> People may have noticed that e2fsprogs 1.40 and roughly a week later
> e2fsprogs 1.40.1 have been released, while there hasn't been any
> activity at http://thunk.org/hg/e2fsprogs.  That's because right afte=
r
> e2fsprogs 1.40, I have moved the e2fsprogs development activity over =
to
> git.  The public repositories can be found here:
>=20
> 	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
> 	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
>=20
> and here:
>=20
> 	git://repo.or.cz/e2fsprogs.git
> 	http://repo.or.cz/r/e2fsprogs.git
>=20

Hi Ted,

I tried to clone the source tree but it failed.

The command "git-clone=20
http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git" failed with :=20
"error: Could not interpret tags/APPLE_UUID_SNAP_1 as something to pull=
"

The command "git-clone http://repo.or.cz/r/e2fsprogs.git" failed with:=20
"error: Can't lock ref"

Could you have a look at this please?
Thank you very much,
    Val=E9rie
