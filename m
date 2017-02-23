From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: hoist {XFS, EXT4}_IOC_{GOING,
 SHUT}DOWN to the VFS
Date: Thu, 23 Feb 2017 08:57:58 -0800
Message-ID: <20170223165758.GC5837@birch.djwong.org>
References: <20170223075230.GB5837@birch.djwong.org>
	<e8ce1e4a-3333-39d1-b9bd-1464512aa125@huawei.com>
	<20170223101518.GA1769@jaegeuk.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Chao Yu <chao@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20170223101518.GA1769@jaegeuk.local>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Thu, Feb 23, 2017 at 02:15:19AM -0800, Jaegeuk Kim wrote:
> Hello,
> 
> On 02/23, Chao Yu wrote:
> > Hi Darrick,
> > 
> > On 2017/2/23 15:52, Darrick J. Wong wrote:
> > > ext4 and XFS expose the same shutdown ioctl with the same parameters,
> > > so let's hoist the whole mess into the vfs headers.
> > 
> > Could you cover f2fs in this patch since f2fs has already supported SHUTDOWN ioctl?
> 
> It's funny that I submitted a similar patch two years ago along with f2fs
> support.
> 
> https://patchwork.kernel.org/patch/5814991/

Heh, I didn't even realize that.  I'll pull f2fs into the patch shortly.

--D

> 
> Thanks,

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
