From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Fix mmap data corruption when blocksize <
	pagesize
Date: Wed, 1 Oct 2014 22:06:33 -0400
Message-ID: <20141002020633.GB16766@thunk.org>
References: <1411648916-16773-1-git-send-email-jack@suse.cz>
	<1411648916-16773-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1411648916-16773-3-git-send-email-jack@suse.cz>
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

On Thu, Sep 25, 2014 at 02:41:56PM +0200, Jan Kara wrote:
> Use truncate_isize_extended() when hole is being created in a file so that
> ->page_mkwrite() will get called for the partial tail page if it is
> mmaped (see the first patch in the series for details).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied to the ext4 tree, thanks.

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
