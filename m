From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2] ext4: rearrange initialization to fix EXT4FS_DEBUG
Date: Mon, 14 Jul 2014 07:56:23 -0400
Message-ID: <20140714115623.GC8935@thunk.org>
References: <1405181415-1403-1-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1407140959450.13527@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33572 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaGNMG1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jul 2014 08:06:27 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1407140959450.13527@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 14, 2014 at 10:04:47AM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > +	block =3D ext4_count_free_clusters(sb);
> > +	ext4_free_blocks_count_set(sbi->s_es, block);
>=20
>=20
> This does not seem right. block is in cluster units so we need to
> convert.
>=20
> 	ext4_free_blocks_count_set(sbi->s_es, EXT4_C2B(sbi, blocks));
>=20
> Otherwise it looks good to me.

Thanks, for catching this!   II've fixed up the patch on the ext4 git t=
ree.

					- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
