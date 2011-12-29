From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch 1/1] ext4: use proper little-endian bitops
Date: Wed, 28 Dec 2011 20:34:31 -0500
Message-ID: <20111229013431.GJ12370@thunk.org>
References: <201111152256.pAFMu6Xw017147@wpaz9.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, akinobu.mita@gmail.com,
	adilger.kernel@dilger.ca
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54476 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab1L2Bef (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 20:34:35 -0500
Content-Disposition: inline
In-Reply-To: <201111152256.pAFMu6Xw017147@wpaz9.hot.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 15, 2011 at 02:56:06PM -0800, akpm@linux-foundation.org wrote:
> From: Akinobu Mita <akinobu.mita@gmail.com>
> Subject: ext4: use proper little-endian bitops
> 
> ext4_{set,clear}_bit() is defined as __test_and_{set,clear}_bit_le() for
> ext4.  Only two ext4_{set,clear}_bit() calls check the return value.  The
> rest of calls ignore the return value and they can be replaced with
> __{set,clear}_bit_le().
> 
> This changes ext4_{set,clear}_bit() from __test_and_{set,clear}_bit_le()
> to __{set,clear}_bit_le() and introduces ext4_test_and_{set,clear}_bit()
> for the two places where old bit needs to be returned.
> 
> This ext4_{set,clear}_bit() change is considered safe, because if someone
> uses these macros without noticing the change, new ext4_{set,clear}_bit
> don't have return value and causes compiler errors where the return value
> is used.
> 
> This also removes unused ext4_find_first_zero_bit().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Applied.

						- Ted
