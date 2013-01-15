From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] lib/ext2fs/bitops.h: Use the optmized/documented
 byteswapping routines
Date: Mon, 14 Jan 2013 21:05:18 -0500
Message-ID: <20130115020518.GA31857@thunk.org>
References: <1358019145-2774-1-git-send-email-crrodriguez@opensuse.org>
 <20130114141356.GA12052@thunk.org>
 <50F4ABC6.6080001@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43405 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab3AOCFW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2013 21:05:22 -0500
Content-Disposition: inline
In-Reply-To: <50F4ABC6.6080001@opensuse.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 10:07:18PM -0300, Cristian Rodr=EDguez wrote:
>=20
> The code does not compile anyway at least in mingw (I just tried)
> and probably in several other targets anyway.. with or without my
> patch :-)

I know for certain that the code compiles on MacOS, *BSD, and Solaris..=
=2E

       	   	   	    	 	  - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
