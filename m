From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Mon, 5 Jan 2009 18:34:37 -0500
Message-ID: <20090105233437.GC14500@mit.edu>
References: <4961603B.5020505@ph.tum.de> <20090105170259.GB8939@mit.edu> <49627285.8060407@ph.tum.de> <20090105213938.GG8939@mit.edu> <49628EBF.2040805@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40052 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbZAEXek (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 18:34:40 -0500
Content-Disposition: inline
In-Reply-To: <49628EBF.2040805@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 05, 2009 at 11:50:39PM +0100, Thiemo Nagel wrote:
>
> fs/ext4/ext4_i.h, line 34:
> typedef unsigned long ext4_group_t;

Ah, I'm looking in the ext4 patch queue, which is about to be sent to
Linus.  This clean up has been in the patch queue for a while, so I
had forgotten about it.

commit 44766d46f4641604b3af167fef2eb5fa9caee7b4
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Nov 4 20:43:52 2008 -0500

    ext4: Make ext4_group_t be an unsigned int
    
    Nearly all places in the ext3/4 code which uses "unsigned long" is
    probably a bug, since on 32-bit systems a ulong a 32-bits, which means
    we are wasting stack space on 64-bit systems.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
