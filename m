From: Mark Tinguely <tinguely@sgi.com>
Subject: Re: [PATCH 6/8] xfstest: enable xfs_repair for large filesystem testing
Date: Mon, 16 Jan 2012 11:04:37 -0600
Message-ID: <4F1458A5.3000404@sgi.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com> <1321875088-30801-7-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:40727 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752654Ab2APREi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jan 2012 12:04:38 -0500
In-Reply-To: <1321875088-30801-7-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/-10/63 13:59, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Now that large filesystem testing does not play free space games to
> fill the space without IO, we can enable xfs_repair when running in
> this mode. xfs_repair has had it's scalability problems solved, too,
> so this is a safe thing to do.
>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
