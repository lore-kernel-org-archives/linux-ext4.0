From: tytso@mit.edu
Subject: Re: [PATCH] [17/23] EXT3: Fix set but unused variables
Date: Mon, 14 Jun 2010 13:21:13 -0400
Message-ID: <20100614172113.GB6666@thunk.org>
References: <20100610110.764742110@firstfloor.org>
 <20100610111053.43E78B1A2B@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56248 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab0FNRVP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jun 2010 13:21:15 -0400
Content-Disposition: inline
In-Reply-To: <20100610111053.43E78B1A2B@basil.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 10, 2010 at 01:10:53PM +0200, Andi Kleen wrote:
> 
> I think it's mostly dead code, but needs more review. I was not fully sure
> about the jbd case.
> 
> cc: tytso@mit.edu
> cc: linux-ext4@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
