From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Sat, 17 Aug 2013 09:02:04 -0400
Message-ID: <20130817130204.GA30769@thunk.org>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
 <CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44947 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab3HQNCI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Aug 2013 09:02:08 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 14, 2013 at 07:06:44AM +0200, Felipe Monteiro de Carvalho wrote:
> 
> Did my last message go through? Just wondering if it was lost ...

I think part of the problem (besids lots of people being busy and on
vacation) is it's not clear what your ext4 reader is going to be used
for.  As a result it's hard to give advice, not knowing what the
requirements are for said reader.

> >    EXT4_FEATURE_INCOMPAT_COMPRESSION    = $0001;

Compression isn't implemeneted, and so I'd suggest not trying to
assume anything the file system with this feature.

> >    EXT4_FEATURE_INCOMPAT_FILETYPE       = $0002;

This would be true only if you are properly handling the name_len in
the direct structure.  (It is a 16 bit Little Endian element, but only
the low 8 bits are the name length; the high 8 bits are for the file
type).

> >    EXT4_FEATURE_INCOMPAT_RECOVER        = $0004; // Needs recovery */

If you are not doing journal replay, you should *not* try to handle a
file system with the needs recovery bit set.

> >    EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM= $2000; // use crc32c for bg */

If you're going to ignore potential checksum errors in the
metadata....

> > But I now wonder about these features:
> >
> >    EXT4_FEATURE_INCOMPAT_MMP            = $0100;

This is used to protect against multiple systems trying to access a
shared block device.  If you are not supporting the MMP protocol, it's
possible for the metadata blocks on a shared block device to be
changing out from under you, with potentially hilarious (if you find
kernel oops or file system reader crashes funny) results.

> >    EXT4_FEATURE_INCOMPAT_EA_INODE       = $0400; // EA in inode */
> >    EXT4_FEATURE_INCOMPAT_DIRDATA        = $1000; // data in dirent */
> >    EXT4_FEATURE_INCOMPAT_LARGEDIR       = $4000; // >2GB or 3-lvl htree */
> >    EXT4_FEATURE_INCOMPAT_INLINEDATA     = $8000; // data in inode */

These features aren't quite fully supported yet.  The inline data
feature is probably closest to be being fully supported, when we
release an the next major version of e2fsprogs.

> > And also which ones require an active work for a reader application to
> > implement. As I already found out that FLEX_BG does not require active
> > work to be supported despite being in the INCOMPAT list...

A lot of whether changes are needed to a file system implementation
depends on how carefully and robustly it had been written in the first
place.  Flex_bg had to be an incompat feature because the Linux kernel
implementation was checking certain invariants which flex_bg would
have violated.  If you have an implementation that isn't checking for
various metadata inconsistenties or errors, it might not matter.

By the way, depending on what your propietary reader is going to be
used for, you might want to consider using an fsfuzzer to make sure it
handles subtly corrupted file systems in a sane way.  If not (again
depending on how oyu use it), you could end up crashing your system
(if this mysterious proprietary reader is part of some OS) or
potentially causing a security breach (buffer overruns, anyway?  :-)

Cheers,

						- Ted
