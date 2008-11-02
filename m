From: Theodore Tso <tytso@mit.edu>
Subject: Re: Wrong calculation of space remaining on a 32 bit system.
Date: Sun, 2 Nov 2008 18:01:35 -0500
Message-ID: <20081102230135.GM8134@mit.edu>
References: <490DBBD9.9040300@tvcablenet.be> <20081102204352.GJ8134@mit.edu> <490E1FB1.8020100@tvcablenet.be> <87fxm9bxps.fsf@newton.gmurray.org.uk> <490E289F.4010907@tvcablenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Graham Murray <graham@gmurray.org.uk>, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?Fran=E7ois?= Valenduc
	<francois.valenduc@tvcablenet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57916 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751683AbYKBXBj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 18:01:39 -0500
Content-Disposition: inline
In-Reply-To: <490E289F.4010907@tvcablenet.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 02, 2008 at 11:24:31PM +0100, Fran=E7ois Valenduc wrote:
>=20
> How can I know if I ran out of inodes ? I already tried 128 and 256
> inode sizes but the problem occurs in both cases.=20

By using the command "df -i".  It will list the number of inodes that
are in use.

The tuning parameters for mke2fs is -i (the inode ratio), or -N
(number of inodes).  The number of inodes is normally calculated as a
ratio to the disk size.  The normal inode ratio is 16384, which allows
for an average inode size of 16k.  If you have a huge number of small
files, or small directories, or a huge number of symbolic links or
device nodes in the filesystem, you can run out of inodes.  You can
change this either by specifying a a smaller inode ratio, or by
explicitly specifying the number of inodes you want created using the
-N option.

> As I said in my bug
> report, I found a patch dated from november 2007 which seems to adres=
s
> the problem (see
> http://osdir.com/ml/file-systems.ext4/2007-11/msg00200.htm).  Off cou=
rse,
> I can't apply it any more now.

You can't apply it because it's already been applied; it's been in
mainline for quite a while.

>  But it seems this kind of problem still
> exists. I have no problem to use ext4 on a 64 bit systems with logica=
l
> volumes having approximately the same size.

That seems very strange.  Maybe you have a different version of
mke2fs, or a different mke2fs.conf file?  (The default inode size can
be controlled by the mke2fs.conf file.)

Can you send the output of "dumpe2fs -h" on a filesystem where you are
having this problem, and on a filesystem from the 64-bit system where
it is working correctly?

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
