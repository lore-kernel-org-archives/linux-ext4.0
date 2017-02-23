From: Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH] vfs: hoist {XFS, EXT4}_IOC_{GOING,
	SHUT}DOWN to the VFS
Date: Thu, 23 Feb 2017 16:54:47 +0800
Message-ID: <e8ce1e4a-3333-39d1-b9bd-1464512aa125@huawei.com>
References: <20170223075230.GB5837@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net
To: "Darrick J. Wong" <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20170223075230.GB5837@birch.djwong.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Hi Darrick,

On 2017/2/23 15:52, Darrick J. Wong wrote:
> ext4 and XFS expose the same shutdown ioctl with the same parameters,
> so let's hoist the whole mess into the vfs headers.

Could you cover f2fs in this patch since f2fs has already supported SHUTDOWN ioctl?

Thanks,


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
