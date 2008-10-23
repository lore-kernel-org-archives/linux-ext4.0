From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned
	htree hash algorithms
Date: Wed, 22 Oct 2008 22:56:47 -0400
Message-ID: <20081023025646.GD10369@mit.edu>
References: <1224560624-9691-1-git-send-email-tytso@mit.edu> <1224560624-9691-2-git-send-email-tytso@mit.edu> <20081022172221.c1a8c5b5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:49978 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751008AbYJWC4x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Oct 2008 22:56:53 -0400
Content-Disposition: inline
In-Reply-To: <20081022172221.c1a8c5b5.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 22, 2008 at 05:22:21PM -0700, Andrew Morton wrote:
> > +		if (((int) c) == -1) {
> 
> arm says
> 
> fs/ext3/super.c: In function `ext3_fill_super':
> fs/ext3/super.c:1750: warning: comparison is always false due to limited range of data type
> 
> Also, is there any way in which this new code can be, umm, cleaned up?

Hmm..... is it considered safe to depend on the userspace limits.h
header file?  I guess if we trust that header file to be correct we
could check the value of CHAR_MIN and/or CHAR_MAX as defined by
limits.h.

Alternatively we could do an #ifdef __CHAR_UNSIGNED__, which is
defined by gcc.  The manual for gcc tells us not to depend on it, but
to depend on limits.h instead.

Any thoughts, or comments?  Does anyone know if the Intel compiler
will DTRT with either of these approaches?

						- Ted
