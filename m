From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix some s64 printing warnings
Date: Thu, 20 Nov 2008 01:11:17 -0500
Message-ID: <20081120061117.GA8610@mit.edu>
References: <20081112111049.68c604ff.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	ppc-dev <linuxppc-dev@ozlabs.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58827 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751971AbYKTGL1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Nov 2008 01:11:27 -0500
Content-Disposition: inline
In-Reply-To: <20081112111049.68c604ff.sfr@canb.auug.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 12, 2008 at 11:10:49AM +1100, Stephen Rothwell wrote:
> A powerpc ppc64_defconfig build of Linus' current tree produces these
> warnings:

Hi Stephen,

Thanks for submitting the patch!  As it turns out, a patch that was
pretty much identical to yours was submitted by Alexander Beregalov
and was merged into mainline as of 2.6.28-rc5, as commit ID ba8292e2.

Regards,

						- Ted
