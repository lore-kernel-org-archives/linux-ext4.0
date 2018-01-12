From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 00/11] fscrypt: symlink helpers and
 fscrypt.h cleanup
Date: Thu, 11 Jan 2018 23:33:38 -0500
Message-ID: <20180112043338.GA8249@thunk.org>
References: <20180105184502.48473-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@google.com>, linux-f2fs-devel@lists.sourceforge.net,
 linux-fscrypt@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20180105184502.48473-1-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

I've taken the v2 version of this series, plus the ext4-specific
patches to use the new symlink helpers (from the v1 patch series).
After testing and validating them, I included the patches to convert
f2fs and ubifs to use the symlink helpers, so I could also grab the
cleanup patches from the V1 series.

Jaeguk, Richard, please let me know if you are OK with my taking the
f2fs and ubifs changes in the fscrypt tree.  It seems like it would
keep things simpler if we did that.

Cheers,

						- Ted

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
