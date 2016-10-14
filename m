From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] fscrypto: lock inode while setting
	encryption policy
Date: Fri, 14 Oct 2016 11:11:52 -0700
Message-ID: <20161014181152.GA65380@google.com>
References: <1475087688-4048-1-git-send-email-ebiggers@google.com>
	<ea8b7140-f04e-380d-b5ae-263f029c0624@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-f2fs-devel@lists.sourceforge.net
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <ea8b7140-f04e-380d-b5ae-263f029c0624@nod.at>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 29, 2016 at 07:20:20PM +0200, Richard Weinberger wrote:
> On 28.09.2016 20:34, Eric Biggers wrote:
> > i_rwsem needs to be acquired while setting an encryption policy so that
> > concurrent calls to FS_IOC_SET_ENCRYPTION_POLICY are correctly
> > serialized (especially the ->get_context() + ->set_context() pair), and
> > so that new files cannot be created in the directory during or after the
> > ->empty_dir() check.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Reviewed-by: Richard Weinberger <richard@nod.at>
> 
> Thanks,
> //richard

Thanks.  Does anyone else have comments on this patch?  It hasn't been applied
yet.

Eric

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
