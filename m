From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] resize2fs: fix minimum size calculation
Date: Wed, 17 Jun 2015 20:55:39 -0400
Message-ID: <5582170B.9000607@ubuntu.com>
References: <20150524013431.GB3270@thunk.org> <1432436541-16990-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:17467 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751614AbbFRA6s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2015 20:58:48 -0400
In-Reply-To: <1432436541-16990-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 05/23/2015 11:02 PM, Phillip Susi wrote:
> The size calculation adds an initial number of block groups needed
> to hold the inodes on the fs, then augments them with additional
> groups needed to reach the minimum number of data blocks, and then
> calculates the size of the last block group ( which should be a
> fraction of one block group ).  It was calculating a last bg size
> of several block groups because when adding the supplementary bgs,
> it only advanced the position of the start of the last group by one
> group, even though it was adding multiple groups.  Add the missing
> multiplier to move the last bg start position up to the correct 
> location, thus computing a proper fractional last bg size.

Bump.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJVghcLAAoJENRVrw2cjl5Rc40H/3S52xJvxPV0f9cpXZT1qNLe
KEOi3O8B8FxQdfi3e3DjOk7OVl9t0wB+pob1QrOb8COp8wWEYr0dvQbq+fMLFOCx
8QehpD+q+0O9ZiptcNvhPEa65vNXTWE9Mo+nnK/eSPm+wXJ/XfGISIQfy7U0qzXP
ZJ0rsyqpFqkJKBOBIh3P9vxxaR+wDM+KuRERk0nc/shnH6Yg5Ud2PUzd+ZmGSYHY
DPxT0Gde3T/9whLOMBaD8NSTyqG5zPASBybqqqKHyeasAuWUqGEO8G79KsZvaeJ5
3LCG92vWO6wt7jQPzgf95Z6uj4CHVVufqA7DQwKKDgIE1JGFq7C76/pwfAranG0=
=nqrK
-----END PGP SIGNATURE-----
