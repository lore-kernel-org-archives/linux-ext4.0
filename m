From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH 1/3] add releasepage hooks to block devices which can
 be used by file systems
Date: Mon, 05 Jan 2009 17:16:08 +0900
Message-ID: <4961C1C8.2080300@jp.fujitsu.com>
References: <20081226050138.GU28946@ZenIV.linux.org.uk> <1230995358-24013-1-git-send-email-tytso@mit.edu> <1230995358-24013-2-git-send-email-tytso@mit.edu>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1230995358-24013-2-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted-san,

Theodore Ts'o wrote:
> Implement blkdev_releasepage() to release the buffer_heads and pages
> after we release private data belonging to a mounted filesystem.
>
> Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/block_dev.c     |   15 +++++++++++++++
>  fs/super.c         |    2 ++
>  include/linux/fs.h |    2 ++
>  3 files changed, 19 insertions(+), 0 deletions(-)

I was confirming whether the kernel to which your new patch is applied can run
without trouble. But unfortunately, I got a hangup problem. Now I am
investigating the root cause.
After I investigated it for a little time, I think calling log_wait_commit() from
journal_try_to_free_buffers() can cause it.
I examine it a little more in detail.

Additional Info(Crash dump):
Backtrace:
crash> bt
PID: 260    TASK: f71076d0  CPU: 1   COMMAND: "kswapd0"
 #0 [f707dcbc] schedule at c06346a3
 #1 [f707dd34] log_wait_commit at f80904c1
 #2 [f707dd70] journal_try_to_free_buffers at f808c81f
 #3 [f707dd94] blkdev_releasepage at c04916cc
 #4 [f707dda4] try_to_release_page at c04526b1
 #5 [f707ddb0] shrink_page_list at c045b3d1
 #6 [f707de50] shrink_list at c045b72e
 #7 [f707def0] shrink_zone at c045bbc6
 #8 [f707df40] kswapd at c045c12c
 #9 [f707dfd8] kthread at c043612c
#10 [f707dfe4] kernel_thread_helper at c04045e1

Sleep time:
crash> ps -l | head -n 1
[5360808577593]  PID: 7995   TASK: c98b76d0  CPU: 1   COMMAND: "crtfile"
crash> ps -l 260
[3727586943566]  PID: 260    TASK: f71076d0  CPU: 1   COMMAND: "kswapd0"
crash> p (5360808577593 - 3727586943566)/1000000000
$4 = 1633
 ======> 1633 seconds

Best Regards,
Toshiyuki Okajima

