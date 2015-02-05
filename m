From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 4/11] xfsprogs: xfs_io: add finsert command for insert
	range
Date: Fri, 6 Feb 2015 10:40:33 +1100
Message-ID: <20150205234033.GW4251@dastard>
References: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
	<1421853126-4505-5-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, bfoster@redhat.com,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1421853126-4505-5-git-send-email-linkinjeon@gmail.com>
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

On Thu, Jan 22, 2015 at 12:11:59AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Add finsert command for fallocate FALLOC_FL_INSERT_RANGE flag.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

I've just pulled this patch into xfsprogs in preparation for getting
this functionality fully reviewed and merged in the 3.21 kernel
cycle.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
