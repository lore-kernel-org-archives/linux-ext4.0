From: Theodore Tso <tytso@mit.edu>
Subject: Re: Wrong calculation of space remaining on a 32 bit system.
Date: Mon, 3 Nov 2008 16:46:35 -0500
Message-ID: <20081103214635.GB18117@mit.edu>
References: <490DBBD9.9040300@tvcablenet.be> <20081102204352.GJ8134@mit.edu> <490E1FB1.8020100@tvcablenet.be> <87fxm9bxps.fsf@newton.gmurray.org.uk> <490E289F.4010907@tvcablenet.be> <20081102230135.GM8134@mit.edu> <490F42D2.8080200@tvcablenet.be> <20081103202440.GG29102@mit.edu> <490F6BD4.4080408@tvcablenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Graham Murray <graham@gmurray.org.uk>, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?Fran=E7ois?= Valenduc
	<francois.valenduc@tvcablenet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43271 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235AbYKCVqj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 16:46:39 -0500
Content-Disposition: inline
In-Reply-To: <490F6BD4.4080408@tvcablenet.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2008 at 10:23:32PM +0100, Fran=E7ois Valenduc wrote:
> So, as you suggested I add the following section in mke2fs.conf:
>=20
>    portage =3D {
>                 features =3D
> has_journal,extents,flex_bg,uninit_bg,dir_nlink,extra_isize
>                 inode_ratio=3D4096
>         }

You can also just do

    portage =3D {
    	    inode_ratio=3D4096
    }

=2E.. and then "mke2fs -t ext4 -T portage" or "/sbin/mkfs.ext4 -T
portage" will do the right thing.  Note BTW, that this issue with the
inode_ratio is also true for ext3, so what I've suggested means that
"mke2fs -t ext3 -T portage" or "mke2fs -t ext2 -T portage" will also
do the right thing for an ext3 or ext2 filesystem, respectively.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
