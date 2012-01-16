From: Mark Tinguely <tinguely@sgi.com>
Subject: Re: [PATCH 2/8] xfstests: rename USE_BIG_LOOPFS to be more generic
Date: Mon, 16 Jan 2012 10:23:24 -0600
Message-ID: <4F144EFC.3010406@sgi.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com> <1321875088-30801-3-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:40981 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754963Ab2APQXZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jan 2012 11:23:25 -0500
In-Reply-To: <1321875088-30801-3-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/-10/63 13:59, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> USE_BIG_LOOPFS is really misnamed - it can be used on real devices just as
> easily as loop devices. It really means we are testing a large scratch device
> and that we should enable the special filesystem filling and checking options
> that enable xfstests to be run sanely on large XFS filesystems.
>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
