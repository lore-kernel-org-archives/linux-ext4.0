Return-Path: <SRS0=iy/Z=RW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FECEC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 15:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C0FE20850
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Mar 2019 15:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfCSPD2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:03:28 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37552 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726703AbfCSPD1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2019 11:03:27 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-99.corp.google.com [104.133.0.99] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2JF2inB004810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Mar 2019 11:02:45 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 3067B420AA8; Tue, 19 Mar 2019 11:02:44 -0400 (EDT)
Date:   Tue, 19 Mar 2019 11:02:44 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, linux-ext4@vger.kernel.org
Subject: Re: New service e2scrub_reap
Message-ID: <20190319150244.GA23187@mit.edu>
References: <fb05730f-c078-ec94-72d3-83a398f936a7@molgen.mpg.de>
 <20190318214717.GB3859@mit.edu>
 <9d83dc52-dda8-6241-40ae-8a4fec4bb9eb@molgen.mpg.de>
 <20190318233238.GE4936@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318233238.GE4936@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Mar 18, 2019 at 04:32:38PM -0700, Darrick J. Wong wrote:
> That's ... interesting.  On my developer workstations (Ubuntu 16.04 and
> 18.04) it generally takes 1/10th the amount of time to run
> e2scrub_all.
> 
> Even on my aging ~2010 era server that only has disks it takes 0.3s:
> 
> # time e2scrub_all -A -r
> 
> real    0m0.280s
> user    0m0.160s
> sys     0m0.126s
> 
> I wonder what's different between our computers?  Do you have a
> lvm2-lvmetad service running?

No, I don't.  I do have lvm2-lvmpolld service active, but I don't
think that's used by lvs.

What I can see is from running the script under bash -vx is that
e2scrub_all is calling:

	lvs --nameprefixes -o vg_name,lv_name,lv_role --noheadings <dev>

for each device returned by lsblk (whether or not it is a LVM device).
At least on my system, it takes around a seventh of a second to run:

# sudo time lvs --nameprefixes -o vg_name,lv_name,lv_role --noheadings /dev/lambda/root 
  LVM2_VG_NAME='lambda' LVM2_LV_NAME='root' LVM2_LV_ROLE='public'
0.01user 0.01system 0:00.14elapsed 16%CPU (0avgtext+0avgdata 13528maxresident)k
8704inputs+0outputs (0major+1056minor)pagefaults 0swaps

# sudo time lvs --nameprefixes -o vg_name,lv_name,lv_role --noheadings /dev/nvmen0
  Volume group "nvmen0" not found
  Cannot process volume group nvmen0
Command exited with non-zero status 5
0.02user 0.01system 0:00.18elapsed 25%CPU (0avgtext+0avgdata 13648maxresident)k
8704inputs+0outputs (0major+1554minor)pagefaults 0swaps

"e2scrub -A -r" is running the lvs command ten times.  So that's
around 1.5 to 2 seconds of the five second run.

Looking at the strace output of the lvs command, I don't see it doing
anything that would a long time, but it *is* doing a huge amount of
open/fstat/close on a huge number of sysfs files.  (Essentially, it's
searching all block devices looking for a match for the given LVM
volume.)  So the e2scrub -A script is going to be opening O(N**2)
sysfs files where N is the number of block devices in the system.

> However, since e2scrub is tied to lvm, Ted is right that calling lvs in
> the outer loop would be far more efficient.  I'll have a look at
> reworking this.

We can also use lvm's selection criteria so we don't have to call eval
on the output of the lvs unnecessarily.

Something else that I noticed --- I don't think lvs --nameprefixes
escapes shell magic characters.  Fortunately lvm only allows names to
contain characters from the set [a-zA-Z+_.-], and I don't *think*
there is the way for userspace to trick lvm to returning a device
pathname that might include the string "/dev/bobby/$(rm -rf /)"
But we might want to take a second, more paranoid look at whether
we are sure it's safe.

       	    	 	 	     	  	     - Ted

P.S. Obligatory xkcd reference: https://xkcd.com/327/

P.P.S.  Just for yucks, it might also be worth testing to see whether
or not the automounts that some desktops use based on the volume label
on the USB stick is doing shell escape santization....
