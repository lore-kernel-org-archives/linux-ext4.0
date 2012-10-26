From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: xfstests: Assume yes when test device is not partitioned
Date: Fri, 26 Oct 2012 10:54:24 -0500
Message-ID: <508AB230.1010102@sgi.com>
References: <1315038799-2150-1-git-send-email-prasadjoshi.linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>,
	Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>,
	<xfs@oss.sgi.com>
To: Prasad Joshi <prasadjoshi.linux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:34357 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964822Ab2JZPwv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Oct 2012 11:52:51 -0400
In-Reply-To: <1315038799-2150-1-git-send-email-prasadjoshi.linux@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/03/2011 03:33 AM, Prasad Joshi wrote:
> If an entire device used for file system creation, the mkfs.ext2/3/4
> asks for confirmation before proceeding. Since the device is
> configured for testing it is safe to assume positive response
> during mkfs.
>
> The patch also replaces hard coded mkfs path with MKFS_PROG variable.
>
> Signed-off-by: Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>
> Signed-off-by: Prasad Joshi <prasadjoshi.linux@gmail.com>
>
> ---
> 032       |    4 ++--
>   049       |    2 +-
>   073       |    2 +-
>   common.rc |    4 ++--
>   4 files changed, 6 insertions(+), 6 deletions(-)
>
Looks good

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Prasad,

This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests, 
master branch, commit ID 9ea06dce.

Thanks
--Rich
