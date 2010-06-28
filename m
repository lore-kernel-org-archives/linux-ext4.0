From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when using CFQ
Date: Mon, 28 Jun 2010 09:58:51 -0400
Message-ID: <x49hbknfeck.fsf@segfault.boston.devel.redhat.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<4C21D442.8080703@oracle.com> <4C22F316.3080009@oracle.com>
	<x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>
	<4C284419.3000905@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Joel Becker <joel.becker@oracle.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	"ocfs2-devel\@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
To: Tao Ma <tao.ma@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0F1N66 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jun 2010 09:58:58 -0400
In-Reply-To: <4C284419.3000905@oracle.com> (Tao Ma's message of "Mon, 28 Jun
	2010 14:41:29 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tao Ma <tao.ma@oracle.com> writes:

> btw, I also met with a NULL pointer deference in cfq_yield. I have
> attached the null.log also. This seems to be related to the previous
> deadlock and happens when I try to remount the same volume after
> reboot and ocfs2 try to do some recovery.

Since I can't reproduce your binary kernel even with your .config, could
you send me the disassembly of the cfq_yield function from your vmlinux
binary?

Thanks!
Jeff
