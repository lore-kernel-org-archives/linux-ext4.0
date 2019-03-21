Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5AEC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 18:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 181BE218FD
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 18:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfCUSZK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 14:25:10 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52164 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727829AbfCUSZK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Mar 2019 14:25:10 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2LIOuuw002833
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Mar 2019 14:24:57 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 671FC420AA8; Thu, 21 Mar 2019 14:24:56 -0400 (EDT)
Date:   Thu, 21 Mar 2019 14:24:56 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321182456.GG9434@mit.edu>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
 <20190321102742.k2oos4epoj6fyjao@work>
 <20190321143141.GB9434@mit.edu>
 <20190321155703.ili5ghofgm3hneq5@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321155703.ili5ghofgm3hneq5@work>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 04:57:03PM +0100, Lukas Czerner wrote:
> 
> hence I get mountpoin where the volume is mounted and the device where
> it is not. That's what we need right ?

Well, except by default we need to be able to determine whether or not
the volume is mounted, since by default e2scrub_all only runs on
mounted file systems (unless -A) is specified.

What I'm now doing is this, which I think is the simplest way to do things:

ls_scan_targets() {
	for NAME in $(lvs -o lv_path --noheadings \
		   -S "lv_active=active,lv_role=public,lv_role!=snapshot,vg_free>${snap_size_mb}") ; do
		# Skip non-ext[234]
		case "$(blkid -o value -s TYPE ${NAME})" in
		ext[234])	;;
		*)		continue;;
		esac

		if [ "${scrub_all}" -eq 1 ]; then
		    echo ${NAME}
		else
		    MOUNTPOINT="$(lsblk -o MOUNTPOINT --noheadings ${NAME})"

		    if [ -n "${MOUNTPOINT}" ]; then
			echo "${MOUNTPOINT}"
		    fi
		fi
	done | sort | uniq
}

This way we only bother to fetch the mountpoints for ext[234] file
systems, and only when -A is _not_ specified.

In fact, I'm actually thinking that we should just *always* just
return the device pathname in which case we can make this even
simpler:

ls_scan_targets() {
	for NAME in $(lvs -o lv_path --noheadings \
		   -S "lv_active=active,lv_role=public,lv_role!=snapshot,vg_free>${snap_size_mb}") ; do
		# Skip non-ext[234]
		case "$(blkid -o value -s TYPE ${NAME})" in
		ext[234])	;;
		*)		continue;;
		esac

		if [ "${scrub_all}" -eq 1 ] ||
		   [ -n "$(lsblk -o MOUNTPOINT --noheadings ${NAME})" ]; then
		    echo ${NAME}
		fi
	done | sort | uniq
}

This means that we always run e2scrub on the device name, which in
some cases might result in some ugliness, e.g.

	systemctl start e2scrub@-dev-lambda-test\\x2d1k

But I think I can live with that.  (However, the fact that
systemd-escape will create Unicode characters which themselves have to
be escaped is, well, sad....)

What do you see on your system when you benchmark the above?  The fact
that we only determine the mountpoints on ext[234] file systems should
save some time.  We are sheling out to blkid for each device but
that's probably not a huge overhead.

My before (v1.45.0 plus support for -n so we can have comparable
times) and after times (with all of the changes):

0.16user 0.15system 0:00.83elapsed 38%CPU (0avgtext+0avgdata 13384maxresident)k

0.12user 0.11system 0:00.36elapsed 64%CPU (0avgtext+0avgdata 13420maxresident)k

Your one-linder is a bit faster:

0.03user 0.04system 0:00.23elapsed 31%CPU (0avgtext+0avgdata 13316maxresident)k

But if we need to determine thick versus thin LV's so we can
potentially do thin snapshots, a bunch of these optimizations are
going to go away anyway.  And realistically, so long as we're fast in
the "no LV's" and "LV's exist but there is no free space" cases, that
should avoid most user complaints, since if we *do* trigger e2scrub,
the cost of running ls_scan_targets will be in the noise.

					- Ted
