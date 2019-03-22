Return-Path: <SRS0=JWMb=RZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E202C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Mar 2019 09:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED4BC218D3
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Mar 2019 09:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbfCVJiT (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Mar 2019 05:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727713AbfCVJiS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 22 Mar 2019 05:38:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C2093082B4F;
        Fri, 22 Mar 2019 09:38:18 +0000 (UTC)
Received: from work (unknown [10.40.205.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 60C1560BE7;
        Fri, 22 Mar 2019 09:38:17 +0000 (UTC)
Date:   Fri, 22 Mar 2019 10:38:11 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190322093811.rw2z2nsyntckfpvq@work>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
 <20190321102742.k2oos4epoj6fyjao@work>
 <20190321143141.GB9434@mit.edu>
 <20190321155703.ili5ghofgm3hneq5@work>
 <20190321182456.GG9434@mit.edu>
 <20190321201710.vw5g2kfp6p2b3jxk@work>
 <20190321204823.GJ9434@mit.edu>
 <20190321220440.GK9434@mit.edu>
 <20190321220819.GL9434@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321220819.GL9434@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 22 Mar 2019 09:38:18 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 06:08:19PM -0400, Theodore Ts'o wrote:
> On Thu, Mar 21, 2019 at 06:04:40PM -0400, Theodore Ts'o wrote:
> > OK, I've reworked the function to read:
> > 
> > ls_scan_targets() {
> > 	lsblk -o NAME,MOUNTPOINT,FSTYPE -P -n -p \
> > 	      $(lvs -o lv_path --noheadings -S "lv_active=active,lv_role=public,lv_role!=snapshot,vg_free>${snap_size_mb}") | \
> > 	    grep FSTYPE=\"ext\[234\]\" | while read vars ; do
> > 		eval "${vars}"
> > 
> > 		if [ "${scrub_all}" -eq 1 ] || [ -n "${MOUNTPOINT}" ]; then
> > 		    echo ${MOUNTPOINT:-${NAME}}
> > 		fi
> > 	done | sort | uniq
> > }
> > 
> > I think that's the final answer....
> 
> And I just saw your e-mail about dropping the sort and uniq calls.
> OK, I'll take care of that too.
> 
> 					- Ted

Great, I like it and it runs very fast on my system.

cold cache
real	0m0.268s
user	0m0.011s
sys	0m0.036s

second run
real	0m0.053s
user	0m0.013s
sys	0m0.031s

Thanks for working on this.
-Lukas
