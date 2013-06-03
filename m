From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH 1/3 v2] 285: Fix test for ext4 in some configurations
Date: Mon, 3 Jun 2013 14:08:23 -0500
Message-ID: <51ACE9A7.30208@sgi.com>
References: <1369948905-6693-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1369948905-6693-1-git-send-email-jack@suse.cz>
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
> In some configurations (e.g. 1 KB block size), ext4 can decide it is
> better to zero out several blocks rather than splitting unwritten
> extent. This changes results SEEK_HOLE / SEEK_DATA returns and thus the
> test fails. Fix the problem by disabling the feature for this test.
>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, this patch has been committed.

commit ce9d1cdd618eaea256356c81cfd579039169b999
Author: Jan Kara <jack@suse.cz>
Date:   Mon Jun 3 13:40:36 2013 -0500

     xfstests 285: Fix test for ext4 in some configurations

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
