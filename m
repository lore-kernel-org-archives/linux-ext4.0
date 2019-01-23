Return-Path: <SRS0=JWl4=P7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 392F1C282C0
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 20:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1300B21872
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Jan 2019 20:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfAWUFg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Jan 2019 15:05:36 -0500
Received: from mxo1.nje.dmz.twosigma.com ([208.77.214.160]:34555 "EHLO
        mxo1.nje.dmz.twosigma.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfAWUFg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2019 15:05:36 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2019 15:05:35 EST
Received: from localhost (localhost [127.0.0.1])
        by mxo1.nje.dmz.twosigma.com (Postfix) with ESMTP id A1B65100050;
        Wed, 23 Jan 2019 19:59:24 +0000 (GMT)
X-Virus-Scanned: Debian amavisd-new at twosigma.com
Received: from mxo1.nje.dmz.twosigma.com ([127.0.0.1])
        by localhost (mxo1.nje.dmz.twosigma.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0e8Szh9NcQMG; Wed, 23 Jan 2019 19:59:24 +0000 (GMT)
Received: from exmbdft5.ad.twosigma.com (exmbdft5.ad.twosigma.com [172.22.1.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxo1.nje.dmz.twosigma.com (Postfix) with ESMTPS id 881678002E;
        Wed, 23 Jan 2019 19:59:24 +0000 (GMT)
Received: from exmbdft5.ad.twosigma.com (172.22.1.56) by
 exmbdft5.ad.twosigma.com (172.22.1.56) with Microsoft SMTP Server (TLS) id
 15.0.1365.1; Wed, 23 Jan 2019 19:59:24 +0000
Received: from twosigma.com (192.168.147.202) by exmbdft5.ad.twosigma.com
 (172.22.1.56) with Microsoft SMTP Server (TLS) id 15.0.1365.1 via Frontend
 Transport; Wed, 23 Jan 2019 19:59:24 +0000
Date:   Wed, 23 Jan 2019 14:59:22 -0500
From:   Thomas Walker <Thomas.Walker@twosigma.com>
To:     Elana Hashman <Elana.Hashman@twosigma.com>
CC:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        "'tytso@mit.edu'" <tytso@mit.edu>,
        "'linux-ext4@vger.kernel.org'" <linux-ext4@vger.kernel.org>
Subject: Re: Phantom full ext4 root filesystems on 4.1 through 4.14 kernels
Message-ID: <20190123195922.GA16927@twosigma.com>
References: <9abbdde6145a4887a8d32c65974f7832@exmbdft5.ad.twosigma.com>
 <20181108184722.GB27852@magnolia>
 <c7cfeaf451d7438781da95b01f21116e@exmbdft5.ad.twosigma.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c7cfeaf451d7438781da95b01f21116e@exmbdft5.ad.twosigma.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Unfortunately this still continues to be a persistent problem for us.  On another example system:

# uname -a
Linux <hostname> 4.14.67-ts1 #1 SMP Wed Aug 29 13:28:25 UTC 2018 x86_64 GNU/Linux

# df -h /
Filesystem                                              Size  Used Avail Use% Mounted on
/dev/disk/by-uuid/<uuid>                                 50G   46G  1.1G  98% /

# df -hi /
Filesystem                                             Inodes IUsed IFree IUse% Mounted on
/dev/disk/by-uuid/<uuid>                                 3.2M  306K  2.9M   10% /

# du -hsx  /
14G     /

And confirmed not to be due to sparse files or deleted but still open files.

The most interesting thing that I've been able to find so far is this:

# mount -o remount,ro /
mount: / is busy
# df -h /
Filesystem                                              Size  Used Avail Use% Mounted on
/dev/disk/by-uuid/<uuid>                                 50G   14G   33G  30% /

Something about attempting (and failing) to remount read-only frees up all of the phantom space usage.
Curious whether that sparks ideas in anyone's mind?

I've tried all manner of other things without success.  Unmounting all of the overlays.  Killing off virtually all of usersapce (dropping to single user).  Dropping page/inode/dentry caches.Nothing else (short of a reboot) seems to give us the space back.


On Wed, Dec 05, 2018 at 11:26:19AM -0500, Elana Hashman wrote:
> Okay, let's take a look at another affected host. I have not drained it, just
> cordoned it, so it's still in Kubernetes service and has running, active pods.
> 
