From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
	write_time()
Date: Mon, 24 Nov 2014 07:21:01 -0800
Message-ID: <20141124152101.GA12575@infradead.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1416599964-21892-2-git-send-email-tytso@mit.edu>
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

On Fri, Nov 21, 2014 at 02:59:21PM -0500, Theodore Ts'o wrote:
> We needed to preserve update_time() because btrfs wants to have a
> special btrfs_root_readonly() check; otherwise we could drop the
> update_time() inode operation entirely.

Can't btrfs just set the immutable flag on every inode that is read
when the root has the BTRFS_ROOT_SUBVOL_RDONLY flag?  That would
cut down the places that need this check to the ioctl path so that
we prevent users from clearling the immutable flag.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
