From: Theodore Tso <tytso@thunk.org>
Subject: Re: [PATCH 0/8][e2fsprogs] 64-bit block number support - first part
Date: Wed, 17 Oct 2007 10:53:26 -0400
Message-ID: <20071017145326.GA11073@thunk.org>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr> <20071014151211.GA6328@thunk.org> <4716189E.7060301@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41092 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759637AbXJQOxb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2007 10:53:31 -0400
Content-Disposition: inline
In-Reply-To: <4716189E.7060301@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 17, 2007 at 04:13:50PM +0200, Valerie Clement wrote:
> Theodore Tso wrote:
>> It's good to clean this up, but this presumes that blk_t is going to
>> change to a 64-bit type.  I'd much rather *add* a blk64_t, and keep
>> blk_t at 32 bits.  This patch series in a number of places makes the
>> presumption that blk_t will change size --- in particular when it
>> creates new interfaces that returns 64-bits through a blk_t.  Please
>> don't do that.
>
> Does it mean that we'll have to duplicate all of the structures
> containing fields of type blk_t (like process_block_struct,
> e2fsck_struct, ext2_inode_cache, ...) and also duplicate most of
> the code for the functions which use variables of type blk_t?

process_block_struct and e2fsck_struct are e2fsck specific structures,
so they don't have to be duplicated; the concern is libext2fs ABI
compatibility.

As far as ext2_inode_cache, you will note that the structure is
defined in ext2fsP.h, so it's not visible to outside callers.  The
ext2fsP.h file was created specifically to allow internal
implementation changes without breaking the ABI, because structures in
ext2fsP.h aren't part of the published interface.

If there are functions where we can show that none of the users of
libext2fs library are calling it, by surveying all known apps that
link against libext2fs (both in e2fsprogs and external to e2fsprogs),
then there is another alternative.  If we know that it's most likely
only being used as an internal helper functions by libext2fs, and the
only reason it wasn't declared static was because it was being used
from another .c file, we could use a linker script to hide the
internal functions using ELF symbol versions, so that applications
would never see those functions.  It won't work for the static
library, so it's not full proof, but if we at the same time use a
function prefix like ext2fs__ with two underscores, it'll probably be
good enough.  This would be the equivalent of removing a function from
the library (as far as outside callers are concerned), so we would
have to do our own due diligence before we could proceed, but it would
be possible.

						- Ted
