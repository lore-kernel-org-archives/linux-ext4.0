From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: e2dis: a Jigdo-like tool for Ext2+ FS
Date: Mon, 15 Aug 2011 11:29:57 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108151125470.3695@dhcp-27-109.brq.redhat.com>
References: <86ei0p8ve2.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1191746045-1313400600=:3695"
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1HOJaB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 05:30:01 -0400
In-Reply-To: <86ei0p8ve2.fsf@gray.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1191746045-1313400600=:3695
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 13 Aug 2011, Ivan Shmakov wrote:

> 	A couple of weeks ago I've started working on a tool
> 	(tentantively named “Ext2 disassembler”) to walk through an
> 	Ext2+ filesystem (or an image of) and produce the mapping of
> 	files' (inodes') relative block numbers to the image's (or
> 	“physical”) block numbers.

Hi Ivan,

I have not seen your code, but that sounds like something that debugfs
(part of e2fsprogs) is already doing very well (and a lot more). This is
exactly the "extN disassembler" you're talking about and with a little
bit of scripting around it you should be able dig any information you
desire from the file system so I do not think that new application is
needed. But I might be wrong, just take a look at it.

Thanks!
-Lukas

> 
> 	The version-that-works (apparently) is almost done, pending
> 	upload to a publicly-accessible Git repository.
> 
> 	However, there's a considerable amount of work to be done so
> 	that the tool will become really usable.  Therefore, I'd
> 	appreciate any help with it.
> 
> 	TIA.
> 
>     Why I'm interested in that?
> 
> 	Recently, there was a discussion in debian-devel@ on whether the
> 	Debian project should provide images for easy deployment within
> 	“virtual” environments (such as KVM, Xen, etc.)
> 
> 	Such images (which, I assume, will use a filesystem supported by
> 	e2fsprogs) are going to be quite large: hundreds MiB to a few
> 	GiB's (depending on the intended usage) per architecture per
> 	version.
> 
> 	Earlier, to reduce the burden of mirroring of the ISO 9660 (CD,
> 	DVD, etc.) images, the Jigdo (for Jigsaw Download) tool was
> 	introduced.  The tool uses SHA-1 to associate pieces of a
> 	filesystem image with the contents of the files of a specified
> 	set.  As the result, the tool produces the association map,
> 	which has the parts of the image for which no matching files are
> 	known embedded.  (A helper file, which contains the URI's the
> 	files may be downloaded from, is also generated.)
> 
> 	Given such an association map, and the files, the tool is
> 	capable of restoring the image.
> 
> 	The tool is filesystem-agnostic.  Unfortunately, it relies on
> 	the fact that the files on the ISO 9660 filesystem are never
> 	fragmented.  Which doesn't hold for Ext2+.
> 
> 	However, given the knowledge of the filesystem, it's possible to
> 	solve the task of describing the parts of a given image as being
> 	parts of the files specified.
> 
>     Done
> 
> 	The tool iterates over the inodes, and records the
> 	logical-to-physical blocks correspondence.  All the “chunks”
> 	belonging to the same inode are marked as such.
> 
> 	The mapping is written to a SQLite database.
> 
>     To do
> 
> 	Message digests are to be computed and recorded just as well.
> 
> 	Non-payload blocks are to be annotated as well.
> 
> 	A tool to reassemble the image.
> 
> 	Command line interface.  (Preferably compliant to the GNU Coding
> 	Standards.)
> 
> 

-- 
--8323328-1191746045-1313400600=:3695--
