From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] libcrc32c: Expose big-endian version of crc32c
Date: Wed, 28 Sep 2011 13:53:59 +1000
Message-ID: <20110928035356.GA6671@gondor.apana.org.au>
References: <20110927221239.21653.17489.stgit@elm3c44.beaverton.ibm.com> <20110927221253.21653.28062.stgit@elm3c44.beaverton.ibm.com>
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
Received: from helcar.apana.org.au ([209.40.204.226]:33961 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1I1DyT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Sep 2011 23:54:19 -0400
Content-Disposition: inline
In-Reply-To: <20110927221253.21653.28062.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 27, 2011 at 03:12:53PM -0700, Darrick J. Wong wrote:
> Provide a big-endian version of crc32c for modules that want it.

Who is going to use this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
