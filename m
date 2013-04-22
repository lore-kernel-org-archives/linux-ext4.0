From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH 1/2] xfstests: dump _require_fio output to log
Date: Mon, 22 Apr 2013 10:30:50 -0500
Message-ID: <517557AA.2040305@sgi.com>
References: <1366024188-21756-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	dchinner@redhat.com, xfs@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <1366024188-21756-1-git-send-email-dmonakhov@openvz.org>
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

On 04/15/2013 06:09 AM, Dmitry Monakhov wrote:

> diff --git a/tests/ext4/301 b/tests/ext4/301
> old mode 100644
> new mode 100755
>
Sorry I forgot to mention this change was unrelated to this patch.

tests/ext4/30? are changed to 755 in commit 'ca9fe94e'.

Thanks for this patch Dmitry, it has been committed.

--Rich


commit 6105b952f46cddf88029d14857cb2658cdab2d52
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Mon Apr 15 11:09:47 2013 +0000

     xfstests: dump _require_fio output to log

     This should help find incompatibility issues.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
