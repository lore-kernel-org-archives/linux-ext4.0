Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C48C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 10:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E00E20700
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 10:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfBTKi2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:38:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:51926 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726209AbfBTKi2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Feb 2019 05:38:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E3B8DADD2;
        Wed, 20 Feb 2019 10:38:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 715AA1E0880; Wed, 20 Feb 2019 11:38:26 +0100 (CET)
Date:   Wed, 20 Feb 2019 11:38:26 +0100
From:   Jan Kara <jack@suse.cz>
To:     fanchaoting@ruijie.com.cn
Cc:     jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
Subject: Re: lastest kernel ext4 io slowly
Message-ID: <20190220103826.GC27474@quack2.suse.cz>
References: <D602F70AAAF7E34689D19106B0CEEEC16BAC0E7F@FZEX4.ruijie.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D602F70AAAF7E34689D19106B0CEEEC16BAC0E7F@FZEX4.ruijie.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 20-02-19 06:23:09, fanchaoting@ruijie.com.cn wrote:
> ############################patch#################################
> 
> commit 16c54688592ce8eea85d2a26d37b64fa07e3e233
> Author: Jan Kara <jack@suse.cz>
> Date:   Fri Sep 30 01:03:17 2016 -0400
> 
>     ext4: Allow parallel DIO reads
> 
>     We can easily support parallel direct IO reads. We only have to make
>     sure we cannot expose uninitialized data by reading allocated block to
>     which data was not written yet, or which was already truncated. That is
>     easily achieved by holding inode_lock in shared mode - that excludes all
>     writes, truncates, hole punches. We also have to guard against page
>     writeback allocating blocks for delay-allocated pages - that race is
>     handled by the fact that we writeback all the pages in the affected
>     range and the lock protects us from new pages being created there.
> 
>     Signed-off-by: Jan Kara <jack@suse.cz>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> ############################################################
> 
> 
> hi jack , when I checkout lastest kernel
> "https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.14.101.tar.xz".  I
> use fio to test it , I find io become slowly. Here is my test method:
> 
> # fio -filename=/fio_test -direct=1 -iodepth 1 -thread -rw=randrw
> -rwmixread=70 -ioengine=psync -bs=4k -size=5G -numjobs=50 -runtime=180
> -group_reporting -name=randrw_70read_4k
> 
...

> Run status group 0 (all jobs):
>    READ: bw=29.9MiB/s (31.3MB/s), 29.9MiB/s-29.9MiB/s (31.3MB/s-31.3MB/s), io=5377MiB (5638MB), run=180006-180006msec
>   WRITE: bw=12.8MiB/s (13.4MB/s), 12.8MiB/s-12.8MiB/s (13.4MB/s-13.4MB/s), io=2303MiB (2415MB), run=180006-180006msec
> 
> when I revert this patch, I find io is faster
...
> Run status group 0 (all jobs):
>    READ: bw=85.3MiB/s (89.4MB/s), 85.3MiB/s-85.3MiB/s (89.4MB/s-89.4MB/s), io=14.0GiB (16.1GB), run=180003-180003msec
>   WRITE: bw=36.6MiB/s (38.4MB/s), 36.6MiB/s-36.6MiB/s (38.4MB/s-38.4MB/s), io=6587MiB (6907MB), run=180003-180003msec

Yes, this is understandable because you direct all 50 threads to do mixed
read-write synchronous IO against the same file (I suppose you mount ext4
with dioread_nolock mount option, right?). This commit changes direct IO
code to use shared lock on the inode so now reads cannot run in parallel to
writes on this file.

Honestly, I find the testcase a bit artificial (applications like databases
that care about good throughput for mixed read-write workload use AIO which
avoids this issue) and the code is simpler this way. Do you have some real
use case for this?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
