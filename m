From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4/30[23]: ignore EBUSY error
Date: Mon, 19 Jan 2015 16:27:41 +0400
Message-ID: <87sif7arb6.fsf@openvz.org>
References: <1421650955-29350-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: tytso@mit.edu, david@fromorbit.com,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1421650955-29350-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com> writes:

Acked-by Dmitry Monakhov <dmonakhov@openvz.org>
> xfstests ext4/302, ext4/303 are ext4 defragmentation stress test,
> which will ioctl(EXT4_IOC_MOVE_EXT), so EBUSY is expected to happen,
> for example, when page's corresponding buffer_head's state is BH_Dirty.
>
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> ---
>  tests/ext4/302 | 2 ++
>  tests/ext4/303 | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/tests/ext4/302 b/tests/ext4/302
> index 1e90016..c604c8f 100755
> --- a/tests/ext4/302
> +++ b/tests/ext4/302
> @@ -60,6 +60,8 @@ filesize=${FILE_SIZE}
>  size=999G
>  buffered=0
>  fadvise_hint=0
> +continue_on_error=write
> +ignore_error=,EBUSY
>  
>  ##########################################
>  # Test2
> diff --git a/tests/ext4/303 b/tests/ext4/303
> index 9573872..2d01f0f 100755
> --- a/tests/ext4/303
> +++ b/tests/ext4/303
> @@ -60,6 +60,8 @@ filesize=${FILE_SIZE}
>  size=999G
>  buffered=0
>  fadvise_hint=0
> +continue_on_error=write
> +ignore_error=,EBUSY
>  
>  #################################
>  # Test3
> -- 
> 1.8.3.1
