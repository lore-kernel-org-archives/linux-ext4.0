From: Theodore Tso <tytso@mit.edu>
Subject: Re: Wrong calculation of space remaining on a 32 bit system.
Date: Mon, 3 Nov 2008 15:24:40 -0500
Message-ID: <20081103202440.GG29102@mit.edu>
References: <490DBBD9.9040300@tvcablenet.be> <20081102204352.GJ8134@mit.edu> <490E1FB1.8020100@tvcablenet.be> <87fxm9bxps.fsf@newton.gmurray.org.uk> <490E289F.4010907@tvcablenet.be> <20081102230135.GM8134@mit.edu> <490F42D2.8080200@tvcablenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Graham Murray <graham@gmurray.org.uk>, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?Fran=E7ois?= Valenduc
	<francois.valenduc@tvcablenet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49867 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754316AbYKCUYr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 15:24:47 -0500
Content-Disposition: inline
In-Reply-To: <490F42D2.8080200@tvcablenet.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 03, 2008 at 07:28:34PM +0100, Fran=E7ois Valenduc wrote:
>=20
> As you may have guessed, I created a logical volume for the portage t=
ree
>  of gentoo. It indeeds contains a lot of small files with all the
> ebuilds. I use XFS for the portage tree on the 64 bits computer. Mayb=
e
> ext4 is not appropriate for this case. Maybe I would have the same
> problem also on the 64 bits computer.

There's nothing wrong with using ext4 for this case; it's just that
you do need to specify the appropriate average inode size.  An average
inode size of 16k works fine for most applications, but not for this
one.  You could calculate an appropriate inode ratio by figuring the
average size of the files used on your system, which I would guess is
somewhere between 4k and 8k, and then this wouldn't be a problem.

I don't know a whole lot about Gentoo's ebuilds, and why it creates so
many small files but if it is common, we could create an entry in
/etc/mke2fs.conf, i.e., like this:

[fs_types]
	portage =3D {
		inode_ratio =3D 8192
	}

Now if you run "mke2fs -t portage", it would automatically create a
filesystem with an inode ratio of 8k. =20

As another example, suppose a spy agency needed to create filesystem
where they stored the results of "pen registers", which record the
time, date, source and destination of phone calls[1].  And suppose
they decide to store each intercept as a separate file, and each file
on average is less than 1k.  (No kidding, I was once at a "next
generation filesystem" requirements session at Sandia National Labs
some 9 years ago where they asked for something very similar to this
--- the ability to write huge numbers of itsy-bitsy files very
quickly, in contrast to the a-bomb simulation folks, who wanted the
ability to write a few really big files very quickly.)  Then they
might want to do something like this:

[fs_types]
	nsa =3D {
	    inode_ratio =3D 1024
	    blocksize =3D 1024
	}

(Alternatively, they might want to consider storing their intercepts
in something *other* than a filesystem, like say a database instead.  :=
-)

[1] http://www.capsteps.com/sounds/nsa-glory.mp3

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
