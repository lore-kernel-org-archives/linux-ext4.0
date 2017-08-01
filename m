From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: Re: [PATCH] ext4: release discard bio after sending discard
 commands
Date: Tue, 01 Aug 2017 23:31:38 +0000
Message-ID: <20170801233138epcms1p4e0d111bd6757201e7df26a281c9d7dd4@epcms1p4>
References: <20170801090909.GB4215@quack2.suse.cz>
        <1501554568-13815-1-git-send-email-daeho.jeong@samsung.com>
        <CGME20170801022917epcas2p49ee3e7d5ac5cba8746253429888b6d1c@epcms1p4>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "jack@suse.com" <jack@suse.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:59953 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdHAXbl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Aug 2017 19:31:41 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20170801233139epoutp012ef010eababe86ededf8c475a105102d~W3M08ZEyt0379903799epoutp01Q
        for <linux-ext4@vger.kernel.org>; Tue,  1 Aug 2017 23:31:39 +0000 (GMT)
In-Reply-To: <20170801090909.GB4215@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> > We've changed the discard command handling into parallel manner.

> > But, in this change, I forgot decreasing the usage count of the bio

> > which was used to send discard request. I'm sorry about that.

> > 

> > Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>

> > Fixes: a015434480dc ("ext4: send parallel discards on commit

> > completions")

 

> Why do you think this is needed? submit_bio_wait() consumes the reference

> that you've got from __blkdev_issue_discard()...

>  

>                                                                Honza



Hi Jan,



I thought like you, but submit_bio_wait() doesn't consume the reference

of the bio and the bio cannot be released after the I/O has been completed.

The caller of submit_bio_wait() should invoke bio_put() in person.

You can see what we have to do after calling submit_bio_wait() in

fs/crypto/bio.c.



Actually, in our device, I can see that the slab memory grows gradually

because of the unreleased discard bios.
