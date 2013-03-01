From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH 08/10] xfstest: add fallocate/punch_hole vs AIO/DIO stress
 test
Date: Fri, 1 Mar 2013 11:50:09 -0600
Message-ID: <5130EA51.7090306@sgi.com>
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org> <1361356935-29153-9-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <xfs@oss.sgi.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <dchinner@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:40040 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751192Ab3CARuI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Mar 2013 12:50:08 -0500
In-Reply-To: <1361356935-29153-9-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> Run  random AIO/DIO activity (fio's job:direct_aio_raicer)
> random fallocate activity(fio's job:falloc_raicer)
> and random punch_hole activity(punch_hole_raicer) on a common
> file in parallel. If race exist old dio request may rewrite
> punched block after it was allocated to another file, we will
> catch that by verifier fio's job: "aio-dio-verifier".
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>
