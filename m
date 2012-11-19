From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V7 00/23] ext4: Add inline data support
Date: Mon, 19 Nov 2012 15:41:01 +0800
Message-ID: <50A9E28D.2010601@tao.ma>
References: <1351047002-4723-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 50-87-16-10.unifiedlayer.com ([50.87.16.10]:44123 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752848Ab2KSHlJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 02:41:09 -0500
Received: from [182.92.247.2] (port=14999 helo=[10.62.3.43])
	by box585.bluehost.com with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TaLyd-00031g-Ug
	for linux-ext4@vger.kernel.org; Mon, 19 Nov 2012 00:41:08 -0700
In-Reply-To: <1351047002-4723-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
	any chance that inline data can be merged in this window?

Thanks
Tao
On 10/24/2012 10:50 AM, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Hi list,
> 
> this is another try for the inline data support for ext4. There is
> no major change from V6. I just rebased it to 3.7-rc1 and run
> xfstests again it.
> 
> git diff --stat
>  fs/ext4/Makefile  |    2 +-
>  fs/ext4/dir.c     |   41 +-
>  fs/ext4/ext4.h    |   89 +++-
>  fs/ext4/extents.c |   22 +-
>  fs/ext4/ialloc.c  |    4 +
>  fs/ext4/inline.c  | 1878 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/inode.c   |  237 ++++++--
>  fs/ext4/namei.c   |  492 ++++++++++-----
>  fs/ext4/xattr.c   |   87 ++-
>  fs/ext4/xattr.h   |  280 ++++++++
>  10 files changed, 2855 insertions(+), 277 deletions(-)
> 
> Thanks
> Tao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

