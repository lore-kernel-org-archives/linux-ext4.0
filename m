From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 1/2] Jbd2: fix a bug of leaking jh->b_jcount
Date: Wed, 25 May 2011 08:02:59 -0400
Message-ID: <AD7D5A1B-C83C-441D-A376-61FC88969C23@mit.edu>
References: <-1724257416234743088@unknownmsgid> <BANLkTikbgiS+3U9HXRoLOxWih=pGJ2rHgQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: y@mx.nrchpc.ac.cn, linux-ext4@vger.kernel.org,
	Ding Dinghua <dingdinghua@nrchpc.ac.cn>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:56578 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754675Ab1EYMDI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 08:03:08 -0400
In-Reply-To: <BANLkTikbgiS+3U9HXRoLOxWih=pGJ2rHgQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On May 25, 2011, at 6:49 AM, Yongqiang Yang wrote:

> Signed-off-by: line was missed.

Also, one request --- if the leak is one that happens on the error path, please say so in the commit summary.  That changes the priority of the patch compared to something which is much higher priority if it is always leaking on the common case code path.

Thanks!!

-- Ted

