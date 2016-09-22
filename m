From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4,
	f2fs: fscrypt_has_permitted_context() check in file open
Date: Thu, 22 Sep 2016 11:59:39 -0400
Message-ID: <20160922155939.vunlgdw4grnmutcp@thunk.org>
References: <6789d30e-f95d-d8bd-cd6e-664a89c0dfd1@nod.at>
	<20160922134433.w3riey2mhtvs54dx@thunk.org>
	<0216ba94-eb55-9617-9b0d-32b92ee41ec5@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: David Gstir <david@sigma-star.at>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <0216ba94-eb55-9617-9b0d-32b92ee41ec5@nod.at>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 22, 2016 at 04:21:30PM +0200, Richard Weinberger wrote:
> 
> Got it. So, the use case is preventing off-line attacks.
> But I fear this is only a drop in the bucket. What we really need is
> meta data authentication.

True security requires a system-wide design, sure.  For example, you
might want a locked bootloader that will only boot signed kernels.
The kernel might then require to use a read-only root file system with
dm-verity to make sure the system software can't be trojan'ed.  And
then you want the system software to enforce that the top-level
directories which contain encrypted information are protected using
the correct keys, perhaps using some trusted hardware store where the
user's keys are stored (and only released when the proper password /
pin is given).

Given all of those induction steps, *then* the file system level
checks that require that all subdirectories and files in an encrypted
directories must be encrypted using the same key as their parent will
provide the security you need.

Cheers,

							- Ted

------------------------------------------------------------------------------
