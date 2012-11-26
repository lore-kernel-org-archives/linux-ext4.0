From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6] libext2fs: add ext2fs_bitcount() function
Date: Mon, 26 Nov 2012 09:06:38 -0500
Message-ID: <20121126140638.GC31891@thunk.org>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu>
 <1353803794-11593-4-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1211261123400.18234@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34813 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab2KZOGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Nov 2012 09:06:42 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1211261123400.18234@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2012 at 11:30:55AM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > +unsigned int ext2fs_bitcount(const void *addr, unsigned int count)
> > +{
> > +	const unsigned char *cp =3D addr;
> > +	const __u32 *p =3D addr;
> > +	unsigned int res =3D 0;
> > +
>=20
> Again it is assumed that 8 will always be aliquot of 'count', but
> it might be worth having a check for that ?

In this case "count" is in bytes, since that's the only thing that
makes sense.  I'll rename the variable to nbytes to make this clear.

      	      	   	      	       	  	    - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
