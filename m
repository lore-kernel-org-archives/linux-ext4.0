From: Johann Lombardi <johann@whamcloud.com>
Subject: Re: [PATCH] ext4: add support for multiple mount protection
Date: Tue, 12 Apr 2011 17:11:41 -0400
Message-ID: <20110412211141.GA4244@neo>
References: <1302631493-9778-1-git-send-email-johann@whamcloud.com>
 <4DA4B885.6020004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40922 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab1DLVLp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Apr 2011 17:11:45 -0400
Received: by gwaa18 with SMTP id a18so2505292gwa.19
        for <linux-ext4@vger.kernel.org>; Tue, 12 Apr 2011 14:11:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4DA4B885.6020004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 12, 2011 at 03:39:33PM -0500, Eric Sandeen wrote:
> There was a lot of skepticism about this last time, and I imagine there still is...

MMP has absolutely no overhead if you don't turn it on. HA configurations (e.g. for NFS/CIFS servers) are very common out there.
Don't you think that MMP could be used in conjunction with Red Hat Cluster Suite to avoid corrupting the backend filesystem when things go wrong?

> 400 new lines of kernel code for this, and if the other machine is hung up for 5 seconds and doesn't update, it can still be multiply-mounted anyway, right?
> 
> BUG: soft lockup - CPU#0 stuck for 10s! anyone?  :(

If the kmmpd thread misses some MMP sequence updates, it reads the MMP block and calls ext3_error() if the sequence was updated behind its back.

Johann
