From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
Date: Sat, 12 Apr 2014 09:59:06 -0400
Message-ID: <20140412135906.GC13837@thunk.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1397242665-2183-3-git-send-email-lczerner@redhat.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 11, 2014 at 08:57:44PM +0200, Lukas Czerner wrote:
> Currently in do_fallocate in collapse range case we're checking whether
> offset + len is not bigger than i_size. However there is nothing which
> would prevent i_size from changing so the check is pointless. It should
> be done in the file system itself and the file system needs to make sure
> that i_size is not going to change.
> 
> As it is now we can easily crash kernel by having two processes doing
> truncate and fallocate collapse range at the same time. This can be
> reproduced on ext4 and it is theoretically possible on xfs even though I
> was not able to trigger it with this simple test.
> 
> This commit removes the check from do_fallocate and adds it to the file
> system.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/extents.c | 11 +++++++++--
>  fs/open.c         |  8 --------
>  fs/xfs/xfs_file.c | 10 +++++++++-
>  3 files changed, 18 insertions(+), 11 deletions(-)

Looks good to me.  Do the xfs folks mind if I carry this in the ext4
tree and push it to Linus shortly after -rc1?  If so, please send me
an ack'ed by.

If folks have a strong preference to handle this differently, let me
know.

Cheers,

						- Ted


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
