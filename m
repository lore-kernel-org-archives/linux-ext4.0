From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 0/12] e2fsprogs: add 64-bit support
Date: Mon, 11 Jun 2007 18:41:56 +0200
Message-ID: <466D7B54.7050005@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48108 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbXFKQke (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 12:40:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

Here is the new version of our e2fsprogs patches to add the 64-bit=20
support in the e2fsprogs tools.

=46irst, I introduced a new compilation option to build e2fsprogs=20
utilities for ext4 filesytems and not break backwards compatiblity with=
=20
ext2/3 filesystems.

So most of the new code for ext4 is included under #ifdef _EXT4FS_.

The major change is that when compiling with _EXT4FS_ option, blk_t is=20
64 bits.

I tried to create new interfaces for ext4 which use the new type blk64_=
t=20
you defined, so most of the code in the patches 03 and 05 are simply=20
duplicated from the 32-bit version.

This patchset is also not complete:
TODO:
   - support of 48-bit in extents to complete,
   - support of 48-bit block number for ACL to do,
   - change the format string %u for a block number to %llu in case of=20
64 bits (many occurences in the code),
   - update code under ext2ed/,
   - and surely other utilities/interfaces I don't use or know to port.

Code compiled, booted and briefly tested on a 20TB device (mkfs,=20
debugfs, e2fsck, dumpe2fs, filefrag tested)
Some non-regression tests also done on ext3 filesystems when compiling=20
code without _EXT4FS_ option.

I splitted the changes into 12 patches to facilitate the review of the=20
patches. I hope this work will be able to make progress on the code for=
=20
the 64-bit support.
   Val=E9rie
