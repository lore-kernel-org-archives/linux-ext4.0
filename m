From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Some thoughts about providing data block checksumming for ext4
Date: Wed, 26 Nov 2014 15:47:06 -0800
Message-ID: <20141126234706.GN10043@birch.djwong.org>
References: <20141103233308.GA27842@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dm-devel@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21663 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaKZXrO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2014 18:47:14 -0500
Content-Disposition: inline
In-Reply-To: <20141103233308.GA27842@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sigh...

Well, I wrote up a preliminary version of dm-checksum and then
realized that I've pretty much just built a crappier version of
dm-dedupe, but without the dedupe part.  Given that it stores
checksums in a btree which claims to be robust through failures and
gives us automatic deduplication, I wonder if it we could achieve our
aims by modifying dm-dedupe to verify the checksums on the read path?

I guess it would be interesting to see how bad the performance hit is
with the online dedupe part enabled or disabled.  dm-dedupe v2 went
out on the mailing list last August, which I missed. :(

Unless... there's a specific reason nobody mentioned dm-dedupe here?

--D
