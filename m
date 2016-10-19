From: Richard Weinberger <richard@nod.at>
Subject: [RFD] Common userspace tool for fscypto
Date: Wed, 19 Oct 2016 13:35:54 +0200
Message-ID: <0bef3877-060e-b722-0354-3a5508219e23@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: David Gstir <david@sigma-star.at>, Theodore Ts'o <tytso@mit.edu>,
	Eric Biggers <ebiggers@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net, kzak@redhat.com,
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Hi!

Since file level encryption has more than one user, currently ext4, f2fs and soon ubifs
it would be nice to have a single tool to control fscrypto from userspace.

For ext4 we have already at least two tools, one as part of e2fsprogs and another
one on github[0]. IMHO the latter one is much more user friendly and intuitive to use.
I as unable to find the userspace tool for f2fs.

That said, what about implementing such a tool as part of util-linux to control
fscrypto? We (David and I) would volunteer.

Thanks,
//richard

[0] https://github.com/gdelugre/ext4-crypt

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
