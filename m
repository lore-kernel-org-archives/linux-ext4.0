From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH 3/3 v2] 285: Test offsets over 4GB
Date: Mon, 3 Jun 2013 14:10:28 -0500
Message-ID: <51ACEA24.4080809@sgi.com>
References: <1369948905-6693-1-git-send-email-jack@suse.cz>
	<1369948905-6693-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1369948905-6693-3-git-send-email-jack@suse.cz>
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

On 05/30/2013 04:21 PM, Jan Kara wrote:
> Test whether SEEK_HOLE and SEEK_DATA works correctly with offsets over
> 4GB, 8TB, and 16TB.
>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, this patch has been committed.

commit e2549c60dd44b4d00a82bbc4acc91e094544839f
Author: Jan Kara <jack@suse.cz>
Date:   Mon Jun 3 13:53:49 2013 -0500

     xfstests 285: Test offsets over 4GB

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
