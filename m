From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Date: Thu, 1 Sep 2011 11:07:37 +1000
Message-ID: <20110901010737.GA25658@gondor.apana.org.au>
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com> <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39189 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1IABIR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 21:08:17 -0400
Content-Disposition: inline
In-Reply-To: <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 31, 2011 at 05:33:36PM -0700, Darrick J. Wong wrote:
> This is a loadable module that will self-test the CRC32c code.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Please use the existing crypto testing framework.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
