From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] libext2fs: optimize rb_set_bmap_range()
Date: Mon, 26 Nov 2012 08:36:13 -0500
Message-ID: <20121126133613.GB31891@thunk.org>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu>
 <1353803794-11593-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1211261027260.18234@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34804 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab2KZNgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Nov 2012 08:36:16 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1211261027260.18234@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2012 at 10:40:28AM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> I do not see cp initialized anywhere. I suppose it should map to the
> 'in' bitmap ?

Oops, I missed this when moving the patch over.  Thanks for pointing
this out!  Yes, it should have been initialized:

	unsigned char *cp =3D in;

> I guess that 8 will always be aliquot part of 'num', by maybe we
> could explicitly check for that to avoid access to uninitialized
> memory ?

It is true that ext2fs_[sg]et_bmap_range() always gets called with num
as a multiple of 8, but it should work correctly even if it isn't
here, since when we check the uninitialized bits in the last byte in
the memory range, the optimization will just fail, and then we'll fall
back to the old slow path for the last bits in the bitmap.

     	    	     	      	       - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
