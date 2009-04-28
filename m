From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 undeletion question
Date: Tue, 28 Apr 2009 12:53:46 -0600
Message-ID: <20090428185346.GR3209@webber.adilger.int>
References: <alpine.DEB.2.00.0904281037240.5262@zest.trausch.us>
 <20090428161106.GB24043@mit.edu> <20090428132609.7628940e@zest.trausch.us>
 <87f94c370904281055s630e55adsba1e4968f782a822@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Michael B. Trausch" <mbt@zest.trausch.us>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	mike-mobile@trausch.us
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52395 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbZD1SyP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 14:54:15 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3SIs6BI016570
	for <linux-ext4@vger.kernel.org>; Tue, 28 Apr 2009 11:54:06 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIT00300LTU0700@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 28 Apr 2009 11:54:06 -0700 (PDT)
In-reply-to: <87f94c370904281055s630e55adsba1e4968f782a822@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 28, 2009  13:55 -0400, Greg Freemyer wrote:
> On Tue, Apr 28, 2009 at 1:26 PM, Michael B. Trausch <mbt@zest.trausch=
=2Eus> wrote:
> > Eh. =A0Thanks for the mention... gave it a shot, but it seems to fa=
il
> > nearly immediately:
> >
> > Tuesday, 2009-Apr-28 at 13:21:41 - mbt@zest - Linux v2.6.29.1
> > Ubuntu Jaunty:[0-9/10014-0]:undel> sudo ext3grep --restore-all /dev=
/zestvg/home-retain-undelete
> > Running ext3grep version 0.10.1
> > WARNING: I don't know what EXT3_FEATURE_COMPAT_EXT_ATTR is.
> > ext3grep: ext3grep.cc:119: void run_program(): Assertion `be2le(jou=
rnal_super_block.s_header.h_magic) =3D=3D 0xc03b3998U' failed.
> > zsh: abort =A0 =A0 =A0sudo ext3grep --restore-all /dev/zestvg/home-=
retain-undelete

One question is whether you formatted this filesystem as ext4 to start
with, or did you upgrade the filesystem from ext3 and the files existed
before the upgrade?  If the latter it is much more likely that you can
recover.  If the former you need to add EXT4_FEATURE_INCOMPAT_EXTENTS
to the list of supported feature flags in run_program().

If the files were created under ext4 then the ext3grep tool will likely
have to be further modified to understand the extent format, which
might not be too hard if you are willing to poke at the code a bit.
It seems like the ext3grep author is receptive to answering questions
about that tool and we can answer questions about the ext4 extent layou=
t.

At a quick glance, what would be easiest to start is to modify the
print_inode_to() function to check for the EXT4_EXTENT_FL being set
in the inode.flags() field.  Add a new extent() method to the Inode
struct that casts i_blocks[0] to struct ext4_extent_header and then
the i_blocks[3], i_blocks[6], i_blocks[9], i_blocks[12] to struct
ext4_extent if eh_depth =3D=3D 0, or ext4_extent_index if eh_depth > 0.

The good news is that ext4 usually allocates file blocks contiguously
so if you can find the inodes themselves in the journal you can likely
extract most of the data just by printing the in-inode extents to find
the block ranges and then dumping the file data with 'dd'.

> > I did create a snapshot of it using LVM (durr, I didn't think of th=
at
> > before) so the FS is preserved as it was... I just don't know how t=
o go
> > about digging through it to get the directory that I deleted out.
> > Hopefully I can figure that out before terribly long, as I am stuck
> > until I do...

> WinHex is a commercial product for doing undeletes that supports
> Ext2/3, ReiserFS, Reiser4, and UFS.  You need the Specialist version
> to handle ext3.  It might handle ext4.

It is highly unlikely that this tool will understand ext4 enhancements =
as-is.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
