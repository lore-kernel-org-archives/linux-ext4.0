From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] fix compile error while opening the macro DOUBLE_CHECK
Date: Mon, 16 Nov 2015 20:03:05 -0800
Message-ID: <20151117040305.GA10663@kroah.com>
References: <1447729443-14698-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: zhangaihua1@huawei.com
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447729443-14698-1-git-send-email-zhangaihua1@huawei.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 17, 2015 at 11:04:03AM +0800, zhangaihua1@huawei.com wrote:
> From: Aihua Zhang <zhangaihua1@huawei.com>
> 
> the error is:
>     fs/ext4/mballoc.c:475:43: error: 'struct ext4_group_info' has
> no member named 'bb_bitmap'
>     the definition of macro should before 'struct ext4_group_info'
> 
> Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
> ---
>  fs/ext4/ext4.h    |   12 ++++++++++++
>  fs/ext4/mballoc.h |   12 ------------
>  2 files changed, 12 insertions(+), 12 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
