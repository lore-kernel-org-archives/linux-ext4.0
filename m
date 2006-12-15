From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: Re: [RFC] [patch 2/3] change attribute for ext4: ext4 specific code
Date: Fri, 15 Dec 2006 11:36:40 +0100
Message-ID: <45827AB8.6020400@bull.net>
References: <456DD75A.2010700@bull.net> <20061206214934.GA4551@schatzie.adilger.int> <45803906.5070307@bull.net> <20061214160307.GE9079@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59996 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbWLOKgj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Dec 2006 05:36:39 -0500
To: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20061214160307.GE9079@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso a =E9crit :
> On Wed, Dec 13, 2006 at 06:31:50PM +0100, Cordenner jean noel wrote:
>=20
> There was discussion on yesterday's call about whether or not 32-bit
> was enough for NFSv4, or whether it also requried 64-bits of change
> notification in the RFC's.  So one of the questions is whether this i=
s
> something that would justify requiring 64-bits --- and if so, maybe w=
e
> need to require that big inodes be used and store the entire 64-bit
> value beyond 128 bytes.  This would mean that NFSv4 cache management
> couldn't be fully implemented without big inodes, or we'd have to mak=
e
> do by using the inode ctime as a partial substitute.
>=20
> What do you think?
>=20
> 						- Ted
>=20

Well it seems that NFSv4 RFC requires a 64-bits notification.
The interest of the change attribute is that it has a simple=20
implementation and doesn't seem to penalize the performance.
Using a 32bits counter and the ctime can give a resolution less than ns=
=2E

But it seems to me that finner timestamp could be usefull in the future=
=2E=20
As the ns patch also use a counter, I don't know if a common=20
implementation would avoid using big inode.

I agree with Andreas saying that the "change_attribute" can be stored i=
n=20
the i_version field.

Jean noel
