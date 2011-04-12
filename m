From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: add support for multiple mount protection
Date: Tue, 12 Apr 2011 15:39:33 -0500
Message-ID: <4DA4B885.6020004@redhat.com>
References: <1302631493-9778-1-git-send-email-johann@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: Johann Lombardi <johann@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab1DLUje (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Apr 2011 16:39:34 -0400
In-Reply-To: <1302631493-9778-1-git-send-email-johann@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/12/11 1:04 PM, Johann Lombardi wrote:
> Prevent an ext4 filesystem from being mounted multiple times.
> A sequence number is stored on disk and is periodically updated (every 5
> seconds by default) by a mounted filesystem.
> At mount time, we now wait for s_mmp_update_interval seconds to make sure
> that the MMP sequence does not change.
> In case of failure, the nodename, bdevname and the time at which the MMP
> block was last updated is displayed.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> Signed-off-by: Johann Lombardi <johann@whamcloud.com>
> ---
>  fs/ext4/ext4.h  |   56 ++++++++-
>  fs/ext4/super.c |  363 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 416 insertions(+), 3 deletions(-)
> 

There was a lot of skepticism about this last time, and I imagine there still is...

400 new lines of kernel code for this, and if the other machine is hung up for 5 seconds and doesn't update, it can still be multiply-mounted anyway, right?

BUG: soft lockup - CPU#0 stuck for 10s! anyone?  :(

I don't see the value in it for upstream ext4, but then hey, ext4 rarely meets a feature it doesn't like ;)

-Eric
