From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: xfstests: optionally run all tests under quota
Date: Fri, 26 Oct 2012 11:49:18 -0500
Message-ID: <508ABF0E.70800@sgi.com>
References: <4B71B6E7.1000203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:36871 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2JZQrl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Oct 2012 12:47:41 -0400
In-Reply-To: <4B71B6E7.1000203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/09/2010 01:26 PM, Eric Sandeen wrote:
> This patch might be a little heavy handed, but it seems to
> work; if you set USE_QUOTA=1 in your environment, all
> tests should be run with quota on and enabled.
>
> This will hopefully help shake out some of the ext4
> quota problems, although one needs to keep an eye
> on the console to see whether warnings scroll by.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>
> ---
>
>
> diff --git a/common.rc b/common.rc
> index 6424871..4fde921 100644
> --- a/common.rc
> +++ b/common.rc

Looks good

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Eric,

This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests, 
master branch, commit ID edd6bcf9.


Thanks
--Rich
