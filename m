Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC48C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52F4D218A1
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 20:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfCUURP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 16:17:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41588 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfCUURP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Mar 2019 16:17:15 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D56959473;
        Thu, 21 Mar 2019 20:17:15 +0000 (UTC)
Received: from work (ovpn-204-90.brq.redhat.com [10.40.204.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3046260857;
        Thu, 21 Mar 2019 20:17:13 +0000 (UTC)
Date:   Thu, 21 Mar 2019 21:17:10 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321201710.vw5g2kfp6p2b3jxk@work>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
 <20190321102742.k2oos4epoj6fyjao@work>
 <20190321143141.GB9434@mit.edu>
 <20190321155703.ili5ghofgm3hneq5@work>
 <20190321182456.GG9434@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321182456.GG9434@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 21 Mar 2019 20:17:15 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 02:24:56PM -0400, Theodore Ts'o wrote:
> On Thu, Mar 21, 2019 at 04:57:03PM +0100, Lukas Czerner wrote:
> > 
> > hence I get mountpoin where the volume is mounted and the device where
> > it is not. That's what we need right ?
> 
> Well, except by default we need to be able to determine whether or not
> the volume is mounted, since by default e2scrub_all only runs on
> mounted file systems (unless -A) is specified.

Right, I did mention it later in the reply. It can be filtered

grep -v '^/dev/'

> 
> What I'm now doing is this, which I think is the simplest way to do things:
> 
> ls_scan_targets() {
> 	for NAME in $(lvs -o lv_path --noheadings \
> 		   -S "lv_active=active,lv_role=public,lv_role!=snapshot,vg_free>${snap_size_mb}") ; do
> 		# Skip non-ext[234]
> 		case "$(blkid -o value -s TYPE ${NAME})" in
> 		ext[234])	;;
> 		*)		continue;;
> 		esac
> 
> 		if [ "${scrub_all}" -eq 1 ]; then
> 		    echo ${NAME}
> 		else
> 		    MOUNTPOINT="$(lsblk -o MOUNTPOINT --noheadings ${NAME})"
> 
> 		    if [ -n "${MOUNTPOINT}" ]; then
> 			echo "${MOUNTPOINT}"
> 		    fi
> 		fi
> 	done | sort | uniq
> }
> 
> This way we only bother to fetch the mountpoints for ext[234] file
> systems, and only when -A is _not_ specified.
> 
> In fact, I'm actually thinking that we should just *always* just
> return the device pathname in which case we can make this even
> simpler:
> 
> ls_scan_targets() {
> 	for NAME in $(lvs -o lv_path --noheadings \
> 		   -S "lv_active=active,lv_role=public,lv_role!=snapshot,vg_free>${snap_size_mb}") ; do
> 		# Skip non-ext[234]
> 		case "$(blkid -o value -s TYPE ${NAME})" in
> 		ext[234])	;;
> 		*)		continue;;
> 		esac
> 
> 		if [ "${scrub_all}" -eq 1 ] ||
> 		   [ -n "$(lsblk -o MOUNTPOINT --noheadings ${NAME})" ]; then
> 		    echo ${NAME}
> 		fi
> 	done | sort | uniq
> }
> 
> This means that we always run e2scrub on the device name, which in
> some cases might result in some ugliness, e.g.
> 
> 	systemctl start e2scrub@-dev-lambda-test\\x2d1k
> 
> But I think I can live with that.  (However, the fact that
> systemd-escape will create Unicode characters which themselves have to
> be escaped is, well, sad....)
> 
> What do you see on your system when you benchmark the above?  The fact
> that we only determine the mountpoints on ext[234] file systems should
> save some time.  We are sheling out to blkid for each device but
> that's probably not a huge overhead.
> 
> My before (v1.45.0 plus support for -n so we can have comparable
> times) and after times (with all of the changes):
> 
> 0.16user 0.15system 0:00.83elapsed 38%CPU (0avgtext+0avgdata 13384maxresident)k
> 
> 0.12user 0.11system 0:00.36elapsed 64%CPU (0avgtext+0avgdata 13420maxresident)k

For me this new function is the wors of all.

cold cache:
real	0m2.115s
user	0m0.040s
sys	0m0.154s

second time:
real	0m1.100s
user	0m0.037s
sys	0m0.122s

But that's because of blkid which is terribly slow for some reason.
Replacing it with lsblk I get much better results

cold cache:
real	0m0.383s
user	0m0.043s
sys	0m0.112s

second time:
real	0m0.153s
user	0m0.048s
sys	0m0.102s

-Lukas

> 
> Your one-linder is a bit faster:
> 
> 0.03user 0.04system 0:00.23elapsed 31%CPU (0avgtext+0avgdata 13316maxresident)k
> 
> But if we need to determine thick versus thin LV's so we can
> potentially do thin snapshots, a bunch of these optimizations are
> going to go away anyway.  And realistically, so long as we're fast in
> the "no LV's" and "LV's exist but there is no free space" cases, that
> should avoid most user complaints, since if we *do* trigger e2scrub,
> the cost of running ls_scan_targets will be in the noise.
> 
> 					- Ted
