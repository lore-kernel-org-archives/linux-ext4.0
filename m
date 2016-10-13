From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Wed, 12 Oct 2016 23:39:53 -0400
Message-ID: <20161013033953.sgohuvud5krlupf3@thunk.org>
References: <1475258329-146528-1-git-send-email-ebiggers@google.com>
	<CAFLxGvyCHwWms8wJf1gU0hRj__Q0Z2F2wKuZ3sYNfp8wQ9S4PQ@mail.gmail.com>
	<20161003180340.GA54410@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	jaegeuk@kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20161003180340.GA54410@google.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 30, 2016 at 7:58 PM, Eric Biggers <ebiggers@google.com> wrote:
> The XTS tweak (or IV) was initialized differently on little endian and
> big endian systems.  Because the ciphertext depends on the XTS tweak, it
> was not possible to use an encrypted filesystem created by a little
> endian system on a big endian system and vice versa, even if they shared
> the same PAGE_SIZE.  Fix this by always using little endian.
>
> This will break hypothetical big endian users of ext4 or f2fs
> encryption.  However, all users we are aware of are little endian, and
> it's believed that "real" big endian users are unlikely to exist yet.
> So this might as well be fixed now before it's too late.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
