From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: don't bother checking for
 encryption key in ->mmap()
Date: Fri, 23 Jun 2017 19:46:27 -0400
Message-ID: <20170623234627.ok4ge3lldrieknq4@thunk.org>
References: <20170523003945.14279-1-ebiggers3@gmail.com>
	<20170523003945.14279-2-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers@google.com>, linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-mtd@lists.infradead.org,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20170523003945.14279-2-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Mon, May 22, 2017 at 05:39:42PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since only an open file can be mmap'ed, and we only allow open()ing an
> encrypted file when its key is available, there is no need to check for
> the key again before permitting each mmap().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
