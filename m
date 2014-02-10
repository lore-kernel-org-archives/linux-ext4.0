From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE)
	for fallocate
Date: Tue, 11 Feb 2014 09:12:59 +1100
Message-ID: <20140210221259.GW13647@dastard>
References: <1391319821-3135-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com,
	adilger.kernel@dilger.ca, mtk.manpages@gmail.com,
	Ashish Sangwan <a.sangwan@samsung.com>,
	linux-fsdevel@vger.kernel.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1391319821-3135-1-git-send-email-linkinjeon@gmail.com>
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

On Sun, Feb 02, 2014 at 02:43:41PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate.
> updated detailed semantics in comments.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Looks OK to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
