From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 14/14] crc32: Select an algorithm via kconfig
Date: Fri, 2 Dec 2011 08:25:05 +0800
Message-ID: <20111202002505.GB19842@gondor.apana.org.au>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201201517.5876.39207.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111201201517.5876.39207.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 01, 2011 at 12:15:17PM -0800, Darrick J. Wong wrote:
> Allow the kernel builder to choose a crc32* algorithm for the kernel.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

I don't like this at all.  How do you expect distros or indeed
anyone to make this choice? For generic C implementations like
this we should only have one, and not many.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
