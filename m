From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/13] fscrypto: rename some functions for
	clarity
Date: Sun, 3 Apr 2016 03:45:05 -0400
Message-ID: <20160403074505.GG3334@thunk.org>
References: <1459660924-2960-1-git-send-email-ebiggers3@gmail.com>
	<1459660924-2960-3-git-send-email-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: mhalcrow@google.com, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1459660924-2960-3-git-send-email-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 03, 2016 at 12:21:53AM -0500, Eric Biggers wrote:
> Rename fscrypt_complete() to page_crypt_complete().  This callback is
> specifically for data pages; fscrypto also performs filename encryption.
> 
> Rename dir_crypt_complete() to fname_crypt_complete().  This callback is
> also used for symlink targets, not just directory entries.
> 
> Rename fscrypt_process_policy() to fscrypt_set_policy().  The new name
> better matches the ioctl, and it goes along with fscrypt_get_policy().
> 
> Signed-off-by: Eric Biggers <ebiggers3@gmail.com>

I'd really rather not renaming any globally visible functions until
after ext4 is converted over to use fs/crypto, just to avoid confusion.

Cheers,

					- Ted

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785471&iu=/4140
