Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B480C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 21:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E47F2218D4
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 21:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfCUVOm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 17:14:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbfCUVOm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Mar 2019 17:14:42 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04A13F74B9;
        Thu, 21 Mar 2019 21:14:42 +0000 (UTC)
Received: from work (ovpn-204-90.brq.redhat.com [10.40.204.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1755B5D9C5;
        Thu, 21 Mar 2019 21:14:40 +0000 (UTC)
Date:   Thu, 21 Mar 2019 22:14:37 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321211437.qdbvjmbwaaji3id6@work>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
 <20190321102742.k2oos4epoj6fyjao@work>
 <20190321143141.GB9434@mit.edu>
 <20190321155703.ili5ghofgm3hneq5@work>
 <20190321182456.GG9434@mit.edu>
 <20190321201710.vw5g2kfp6p2b3jxk@work>
 <20190321204823.GJ9434@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321204823.GJ9434@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 21 Mar 2019 21:14:42 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 04:48:23PM -0400, Theodore Ts'o wrote:
> On Thu, Mar 21, 2019 at 09:17:10PM +0100, Lukas Czerner wrote:
> > 
> > Right, I did mention it later in the reply. It can be filtered
> > 
> > grep -v '^/dev/'
> 
> Well, that assumes all device nodes are in /dev.  Which is not
> necessarily always the case, especially in some of the more _whacky_
> container setups which I've seen.   (Hmm, is whacky redundant here?)

Fair enough, I've never seen this outside dm/lvm testing.

> 
> I suppose can test whether or not the path is a block device or a
> directory.....
> 
> > 
> > For me this new function is the wors of all.
> > 
> > cold cache:
> > real	0m2.115s
> > user	0m0.040s
> > sys	0m0.154s
> > 
> > second time:
> > real	0m1.100s
> > user	0m0.037s
> > sys	0m0.122s
> > 
> > But that's because of blkid which is terribly slow for some reason.
> 
> I ran my test on a system with a NVMe SSD, and no HDD's attached.  I
> just did an strace, and I see the util-linux folks have really done a
> great job of pessimizing blkid.  :-(

Yeah, all I have on that system is spinning rust :)
lsblk works good enough for me so I am not sure how I feel about special
binary to check the mount point :)

-Lukas

> 
> My version used to just pull the information from the blkid cache file
> and then verified the results, but it looks like the new, improved
> util-linux version of blkid scans the /dev directory and opens and
> reads from each device node, even when we're querying a single block
> device.  <groan>
> 
> Even lsblk is *amazingly* inefficient in terms of the number of
> useless file opens which it performs, although at least they are all
> /sysfs files.
> 
> I'm half tempted to create and ship a binary which just calls
> ext2fs_check_mount_point() and returns the value, since it's the most
> efficient.  This command
> 
> sudo strace -o /tmp/st /build/e2fsprogs-maint/lib/ext2fs/tst_ismounted  /dev/lambda/tp
> 
> Opens /proc/mounts and does a trial mount of /dev/lambda/tp to make
> sure it's actually busy, and that's it.
> 
> Sigh...
> 
> 						- Ted
