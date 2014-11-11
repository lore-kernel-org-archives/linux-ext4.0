From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/11] xfs: Remove useless test
Date: Wed, 12 Nov 2014 10:27:14 +1100
Message-ID: <20141111232714.GW28565@dastard>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
	<1415739865-2438-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1415739865-2438-2-git-send-email-jack@suse.cz>
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

On Tue, Nov 11, 2014 at 10:04:15PM +0100, Jan Kara wrote:
> Q_XQUOTARM is never passed to xfs_fs_set_xstate() so remove the test.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks fine - the higher layers ahave changed since this was added.
I'll pick this one up straight away.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
