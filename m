From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH v3] ext4: Prevent race while waling extent tree
Date: Tue, 13 Nov 2012 10:51:04 -0800
Message-ID: <20121113185104.GC1282@lenny.home.zabbo.net>
References: <1352732245-30132-1-git-send-email-lczerner@redhat.com>
 <1352794923-28555-1-git-send-email-lczerner@redhat.com>
 <CA+a=Yy6pi5rUv2GJtsvH1=O+WAawWg03S_ORpVfwnVzYa4tPqA@mail.gmail.com>
 <alpine.LFD.2.00.1211131304030.3577@localhost>
 <20121113141911.GA7472@X61>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, dmonakhov@openvz.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab2KMSvK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2012 13:51:10 -0500
Content-Disposition: inline
In-Reply-To: <20121113141911.GA7472@X61>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> The deadlock mentioned by Zach Brown can be fixed by simply switching
> to GFP_NOFS.

That's a start, but it doesn't address the copy_to_user().  You could
pin that memory, I suppose, but that starts to feel like more trouble
than its worth.

- z
