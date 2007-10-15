From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/8][e2fsprogs] convert block number definition to blk_t
Date: Sun, 14 Oct 2007 21:02:38 -0400
Message-ID: <20071015010238.GE9715@thunk.org>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr> <1188488020.15770.41.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54998 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbXJOBDG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2007 21:03:06 -0400
Content-Disposition: inline
In-Reply-To: <1188488020.15770.41.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 30, 2007 at 05:33:40PM +0200, Valerie Clement wrote:
> 
> From: Valerie Clement <valerie.clement@bull.net>
> 
> This patch converts a few __u32 or unsigned int block number definitions to
> blk_t type.  Conversions are necessary to prepare the 64-bit porting.
> 
> Signed-off-by: Valerie Clement <valerie.clement@bull.net>

Applied with the following description:

Use blk_t type instead of unsigned int or __u32

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
