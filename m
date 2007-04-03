From: Vincent Caron <vcaron@bearstech.com>
Subject: Re: tune2fs -l stale info
Date: Tue, 03 Apr 2007 15:55:57 +0200
Message-ID: <1175608557.5079.15.camel@localhost>
References: <1175170676.5185.42.camel@localhost>
	<20070329195939.GI5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, ext3-users@redhat.com
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <20070329195939.GI5967@schatzie.adilger.int>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On jeu, 2007-03-29 at 13:59 -0600, Andreas Dilger wrote:
> On Mar 29, 2007  14:17 +0200, Vincent Caron wrote:
> >   I just noticed that 'tune2fs -l' did not returned a "lively" updated
> > information regarding the free inodes count (looks like it's always
> > correct after unmounting).
> 
> This is a bit of a defect in all 2.6 kernels.  They never update the
> on disk superblock free blocks/inodes information to avoid lock contention,
> even if this info is available.

  It turns out it is okay in my case since 'df -i' reports correct
numbers.

> Can you please give the following patch a try?  It fixes this issue,
> and also makes statfs MUCH more efficient for large filesystems, because
> the filesystem overhead is constant unless the filesystem size changes
> and checking that for 16k groups is slow (hence hack to add cond_resched()
> instead of fixing problem correctly).  It has not been tested much, but
> is very straight forward.
> 
> Only the last part is strictly necessary to fix your particular problem
> (setting of es->s_free_inodes_count and es->s_free_blocks_count).  This
> is lazy, in the sense that you need a "statfs" to update the count, and
> then a truncate or unlink or rmdir in order to dirty the superblock to
> flush it to disk.  However, it will be correct in the buffer cache, and
> it is a lot better than what we have now.  We don't want a non-lazy version
> anyways, because of performance.

  Unfortunately the problem shows on a production machine and I don't
have a similar one to test properly (it's a heavy-loaded filer).

  BTW, if ondisk superblocks are not updated until specific events occur
(umount, statfs), what is the consequence of a system crash ? Does
journalization come into play (superblock=metadata?), does fsck fixes
figures from other ondisk structures ? Just being curious...
