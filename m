From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: mballoc: avoid 20-argument function call
Date: Mon, 15 Jun 2015 00:36:05 -0400
Message-ID: <20150615043605.GA15413@thunk.org>
References: <1433975282-20694-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433975282-20694-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 11, 2015 at 12:28:02AM +0200, Rasmus Villemoes wrote:
> Making a function call with 20 arguments is rather expensive in both
> stack and .text. In this case, doing the formatting manually doesn't
> make it any less readable, so we might as well save 155 bytes of .text
> and 112 bytes of stack.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Thanks, applied.

						- Ted
