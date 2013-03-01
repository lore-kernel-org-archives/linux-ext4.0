From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH 07/10] xfstest: add fallocate/truncate vs AIO/DIO stress
 test
Date: Fri, 1 Mar 2013 11:49:35 -0600
Message-ID: <5130EA2F.9080209@sgi.com>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org> <1361356935-29153-8-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <xfs@oss.sgi.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <dchinner@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:40012 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202Ab3CARte (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Mar 2013 12:49:34 -0500
In-Reply-To: <1361356935-29153-8-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> Run  DIO, fallocate and truncate threads on a common file in parallel.
> If race exist old dio request may rewrite blocks after it was allocated
> to another file, we will catch that by verifying blocks content.
>
> this patch known to catch deadlock for ext4
> http://lists.openwall.net/linux-ext4/2012/09/06/3
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>
