From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] ext3 freeze feature ver 0.2
Date: Tue, 26 Feb 2008 08:39:02 -0800
Message-ID: <47C440A6.6080202@redhat.com>
References: <20080219202706t-sato@mail.jp.nec.com> <20080226172014t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYBZQjF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Feb 2008 11:39:05 -0500
In-Reply-To: <20080226172014t-sato@mail.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Takashi Sato wrote:

> o Elevate XFS ioctl numbers (XFS_IOC_FREEZE and XFS_IOC_THAW) to the VFS
>   As Andreas Dilger and Christoph Hellwig advised me, I have elevated
>   them to include/linux/fs.h as below.
>     #define FIFREEZE        _IOWR('X', 119, int)
> 　  #define FITHAW          _IOWR('X', 120, int)
>   The ioctl numbers used by XFS applications don't need to be changed.
>   But my following ioctl for the freeze needs the parameter
>   as the timeout period.  So if XFS applications don't want the timeout
>   feature as the current implementation, the parameter needs to be
>   changed 1 (level?) into 0.

So, existing xfs applications calling the xfs ioctl now will behave
differently, right?  We can only keep the same ioctl number if the
calling semantics are the same.  Keeping the same number but changing
the semantics is harmful, IMHO....

-Eric
