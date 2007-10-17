From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH 0/8][e2fsprogs] 64-bit block number support - first part
Date: Wed, 17 Oct 2007 16:13:50 +0200
Message-ID: <4716189E.7060301@bull.net>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr> <20071014151211.GA6328@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41975 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXJQOOM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Oct 2007 10:14:12 -0400
In-Reply-To: <20071014151211.GA6328@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> It's good to clean this up, but this presumes that blk_t is going to
> change to a 64-bit type.  I'd much rather *add* a blk64_t, and keep
> blk_t at 32 bits.  This patch series in a number of places makes the
> presumption that blk_t will change size --- in particular when it
> creates new interfaces that returns 64-bits through a blk_t.  Please
> don't do that.

Does it mean that we'll have to duplicate all of the structures
containing fields of type blk_t (like process_block_struct,
e2fsck_struct, ext2_inode_cache, ...) and also duplicate most of
the code for the functions which use variables of type blk_t?

   Val=E9rie
