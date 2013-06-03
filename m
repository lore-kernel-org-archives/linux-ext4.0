From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH] xfstests: fix seek_sanity_test for fs w/o fallocate
Date: Mon, 3 Jun 2013 07:42:08 -0500
Message-ID: <51AC8F20.8030501@sgi.com>
References: <51A8C59B.3030308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:45700 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049Ab3FCMlG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jun 2013 08:41:06 -0400
In-Reply-To: <51A8C59B.3030308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/31/2013 10:45 AM, Eric Sandeen wrote:
> currently the seek_sanity_test (generic/285) fails on ext3
> or ext2 due to fallocate() failures.  Just ignore that test
> if the fs doesn't support fallocate.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks Eric and Zheng, this has been committed.

commit 3e889c6735117e0906c339ffae0dbc17a4df27fb
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Jun 3 07:28:17 2013 -0500

     xfstests: fix seek_sanity_test for fs w/o fallocate

(Rich adds another step to his commit procedure to prevent this from 
happening again)

--Rich
