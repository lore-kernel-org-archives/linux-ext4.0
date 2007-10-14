From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/8][e2fsprogs] 64-bit block number support - first part
Date: Sun, 14 Oct 2007 11:12:11 -0400
Message-ID: <20071014151211.GA6328@thunk.org>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42312 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbXJNUag (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2007 16:30:36 -0400
Content-Disposition: inline
In-Reply-To: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Valerie,

	My apologies not having the time to review your patches until now.

On Thu, Aug 30, 2007 at 05:28:35PM +0200, Valerie Clement wrote:
> This is a series of 8 patches that prepares for the 64-bit block number support in e2fsprogs:

In general, could people please use a fill column of 72 when sending
e-mail messages, writing C code, and writing git commit logs?  It
makes life easier for people who still use 80 column screens, and it
is the kernel standard.  Thanks!

> - change a few variable types to blk_t type to support 64-bit block 
> numbers in a next step,

It's good to clean this up, but this presumes that blk_t is going to
change to a 64-bit type.  I'd much rather *add* a blk64_t, and keep
blk_t at 32 bits.  This patch series in a number of places makes the
presumption that blk_t will change size --- in particular when it
creates new interfaces that returns 64-bits through a blk_t.  Please
don't do that.

> - introduce helper functions, similar to those existing in the ext4 kernel code, to access 64-bit block counters split in two 32-bit words.

These are the ones....

						- Ted
