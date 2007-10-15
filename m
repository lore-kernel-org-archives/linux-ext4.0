From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/8][e2fsprogs] add new macro to get descriptor number
Date: Sun, 14 Oct 2007 22:09:11 -0400
Message-ID: <20071015020910.GH9715@thunk.org>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr> <1188488293.15770.49.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37994 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbXJOCJk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2007 22:09:40 -0400
Content-Disposition: inline
In-Reply-To: <1188488293.15770.49.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 30, 2007 at 05:38:13PM +0200, Valerie Clement wrote:
> 
> From: Valerie Clement <valerie.clement@bull.net>
> 
> This patch introduces a new macro EXT2_DESC_PER_BLOCK to calculate the number
> of group descriptors per block as two different structures are now defined,
> ext4_group_desc structure for ext4 filesystems and ext2_group_desc structure
> for older filesystems.
> 
> Signed-off-by: Valerie Clement <valerie.clement@bull.net>

Applied with minor changes take into account that I haven't applied
patch 3/8 yet.

						- Ted
