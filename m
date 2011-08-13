From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: e2dis: a Jigdo-like tool for Ext2+ FS
Date: Sat, 13 Aug 2011 17:21:09 +0700
Message-ID: <86ei0p8ve2.fsf@gray.siamics.net>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40074 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab1HMKV2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Aug 2011 06:21:28 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QsBLI-0003ND-UL
	for linux-ext4@vger.kernel.org; Sat, 13 Aug 2011 12:21:24 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 13 Aug 2011 12:21:24 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 13 Aug 2011 12:21:24 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

	A couple of weeks ago I've started working on a tool
	(tentantively named =E2=80=9CExt2 disassembler=E2=80=9D) to walk throu=
gh an
	Ext2+ filesystem (or an image of) and produce the mapping of
	files' (inodes') relative block numbers to the image's (or
	=E2=80=9Cphysical=E2=80=9D) block numbers.

	The version-that-works (apparently) is almost done, pending
	upload to a publicly-accessible Git repository.

	However, there's a considerable amount of work to be done so
	that the tool will become really usable.  Therefore, I'd
	appreciate any help with it.

	TIA.

    Why I'm interested in that?

	Recently, there was a discussion in debian-devel@ on whether the
	Debian project should provide images for easy deployment within
	=E2=80=9Cvirtual=E2=80=9D environments (such as KVM, Xen, etc.)

	Such images (which, I assume, will use a filesystem supported by
	e2fsprogs) are going to be quite large: hundreds MiB to a few
	GiB's (depending on the intended usage) per architecture per
	version.

	Earlier, to reduce the burden of mirroring of the ISO 9660 (CD,
	DVD, etc.) images, the Jigdo (for Jigsaw Download) tool was
	introduced.  The tool uses SHA-1 to associate pieces of a
	filesystem image with the contents of the files of a specified
	set.  As the result, the tool produces the association map,
	which has the parts of the image for which no matching files are
	known embedded.  (A helper file, which contains the URI's the
	files may be downloaded from, is also generated.)

	Given such an association map, and the files, the tool is
	capable of restoring the image.

	The tool is filesystem-agnostic.  Unfortunately, it relies on
	the fact that the files on the ISO 9660 filesystem are never
	fragmented.  Which doesn't hold for Ext2+.

	However, given the knowledge of the filesystem, it's possible to
	solve the task of describing the parts of a given image as being
	parts of the files specified.

    Done

	The tool iterates over the inodes, and records the
	logical-to-physical blocks correspondence.  All the =E2=80=9Cchunks=E2=
=80=9D
	belonging to the same inode are marked as such.

	The mapping is written to a SQLite database.

    To do

	Message digests are to be computed and recorded just as well.

	Non-payload blocks are to be annotated as well.

	A tool to reassemble the image.

	Command line interface.  (Preferably compliant to the GNU Coding
	Standards.)

--=20
=46SF associate member #7257

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
