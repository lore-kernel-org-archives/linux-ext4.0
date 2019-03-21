Return-Path: <SRS0=3UD1=RY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B75C10F00
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 15:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF496218E2
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Mar 2019 15:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfCUP5K (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:57:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728088AbfCUP5J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Mar 2019 11:57:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DA60E88AB1;
        Thu, 21 Mar 2019 15:57:08 +0000 (UTC)
Received: from work (ovpn-204-90.brq.redhat.com [10.40.204.90])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BCDDD5D9C5;
        Thu, 21 Mar 2019 15:57:07 +0000 (UTC)
Date:   Thu, 21 Mar 2019 16:57:03 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        darrick.wong@oracle.com
Subject: Re: [PATCH 8/9] e2scrub_all: refactor device probe loop
Message-ID: <20190321155703.ili5ghofgm3hneq5@work>
References: <20190321020218.5154-1-tytso@mit.edu>
 <20190321020218.5154-8-tytso@mit.edu>
 <20190321102742.k2oos4epoj6fyjao@work>
 <20190321143141.GB9434@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321143141.GB9434@mit.edu>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 21 Mar 2019 15:57:08 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Mar 21, 2019 at 10:31:41AM -0400, Theodore Ts'o wrote:
> On Thu, Mar 21, 2019 at 11:27:42AM +0100, Lukas Czerner wrote:
> > 
> > lv_role=public does not exclude snapshots and so it will fail later in
> > e2scrub when you try to create a snapshot of a thicksnapshot which is
> > not supported.
> 
> Ah, good point.  Thanks for pointing that out.
> 
> > Also I am not sure what's the rush, but it seems you've ignored my other
> > suggestions.
> 
> I did consider them all, but there were reasons why I didn't use them.
> One of them wasn't practical because I needed LVM2_VG_NAME; when you
> made that suggestion, I hadn't published the patch needed to fix
> Debian Bug #924301.  Of course, if we use your suggestion of using "-S
> vg_free > ${snap_size}" it will obviate that need; so thanks for that
> suggestion.
> 
> The reason why I didn't take one of your other suggestions is that we
> need to check whether or not the file system is mounted, and so we
> needed the mountpoint in lsblk, and once you ask for the mountpoint,
> we can no longer use awk to select a field, since an unmounted file
> system shows up as a an empty column.
> 
> % sudo lsblk -o MOUNTPOINT,FSTYPE,NAME -l
>            LVM2_member nvme0n1p3_crypt
>            ext4        lambda-uroot
> [SWAP]     swap        lambda-swap_1
> /          ext4        lambda-root
>            ext4        lambda-old--files
>            ext4        lambda-library
>            ext4        lambda-test--4k
>            ext4        lambda-scratch
>            ext4        lambda-test--1k
>                        lambda-scratch2
>                        lambda-scratch3
>            ext4        lambda-results
>                        lambda-thinpool_tmeta
>                        lambda-thinpool_tdata

So the good news is that it's not really a problem. What you really want
is the mountpoint if it exists and the device otherwise right ?

Then my suggestion will do just that becuase awk will separate the fieds
with FS (field separator) which by default is a single space. But space
is special in awk becuase the fields will be separated by a runs of
space, so if you pick the fileds just right you'll get what you want.

So if I run this on my system

# lsblk -o MOUNTPOINT,NAME,FSTYPE -p -n -l `lvs -o lv_path -S lv_active=active,lv_role=public,lv_role!=snapshot,vg_free\>256 --noheadings`

I'll get

            /dev/mapper/vg_perpetuum-ext4--suck
            /dev/mapper/vg_perpetuum-fedora29
            /dev/mapper/vg_perpetuum-fedora29--2
            /dev/mapper/vg_perpetuum-freebsd
/mnt/kernel /dev/mapper/vg_perpetuum-kernel      ext4
/home       /dev/mapper/vg_perpetuum-lv_home     xfs
/           /dev/mapper/vg_perpetuum-lv_root     xfs
[SWAP]      /dev/mapper/vg_perpetuum-lv_swap     swap
/var        /dev/mapper/vg_perpetuum-lv_var      xfs
            /dev/mapper/vg_perpetuum-lvol001     ext4
            /dev/mapper/vg_perpetuum-overlay     ext4
            /dev/mapper/vg_perpetuum-rhel7
            /dev/mapper/vg_perpetuum-rhel8
            /dev/mapper/vg_perpetuum-test0       ext3
            /dev/mapper/vg_perpetuum-test1       xfs
            /dev/mapper/vg_perpetuum-test10      ext4
            /dev/mapper/vg_perpetuum-test11      ext4
            /dev/mapper/vg_perpetuum-test12
            /dev/mapper/vg_perpetuum-test2
            /dev/mapper/vg_perpetuum-test3       ext4
            /dev/mapper/vg_perpetuum-test4       ext4
            /dev/mapper/vg_perpetuum-test5
            /dev/mapper/vg_perpetuum-test6       LVM2_member
            /dev/mapper/vg_perpetuum-test7
            /dev/mapper/vg_perpetuum-test8
            /dev/mapper/vg_perpetuum-test9       ext4
            /dev/mapper/vg_perpetuum-testing     ext4
            /dev/mapper/vg_perpetuum-testing1    xfs
            /dev/mapper/vg_perpetuum-thinvolume

now if I add 

| awk '{print $1}'

I'll get

/dev/mapper/vg_perpetuum-ext4--suck
/dev/mapper/vg_perpetuum-fedora29
/dev/mapper/vg_perpetuum-fedora29--2
/dev/mapper/vg_perpetuum-freebsd
/mnt/kernel
/home
/
[SWAP]
/var
/dev/mapper/vg_perpetuum-lvol001
/dev/mapper/vg_perpetuum-overlay
/dev/mapper/vg_perpetuum-rhel7
/dev/mapper/vg_perpetuum-rhel8
/dev/mapper/vg_perpetuum-test0
/dev/mapper/vg_perpetuum-test1
/dev/mapper/vg_perpetuum-test10
/dev/mapper/vg_perpetuum-test11
/dev/mapper/vg_perpetuum-test12
/dev/mapper/vg_perpetuum-test2
/dev/mapper/vg_perpetuum-test3
/dev/mapper/vg_perpetuum-test4
/dev/mapper/vg_perpetuum-test5
/dev/mapper/vg_perpetuum-test6
/dev/mapper/vg_perpetuum-test7
/dev/mapper/vg_perpetuum-test8
/dev/mapper/vg_perpetuum-test9
/dev/mapper/vg_perpetuum-testing
/dev/mapper/vg_perpetuum-testing1
/dev/mapper/vg_perpetuum-thinvolume


hence I get mountpoin where the volume is mounted and the device where
it is not. That's what we need right ?

What I did not consider was [SWAP] but we can get rid of that easily.

grep -v '[SWAP]'

> 
> I also really didn't like using grep to select the file system type
> ext[234], since if it would falsely select a LV name that contained
> "ext4", e.g.:
> 
> /home/dave       xfs        rhel-ext4--sucks

That can be dealt with as well as well just by grepping for ' ext[234]$'

So in the end we'll have something like

# lsblk -o MOUNTPOINT,NAME,FSTYPE -p -n -l `lvs -o lv_path -S lv_active=active,lv_role=public,lv_role!=snapshot,vg_free\>256 --noheadings` | grep -v '[SWAP]' | grep ' ext[234]$' | awk '{print $1}'

and so on my system this gives me

/mnt/kernel
/dev/mapper/vg_perpetuum-lvol001
/dev/mapper/vg_perpetuum-overlay
/dev/mapper/vg_perpetuum-test0
/dev/mapper/vg_perpetuum-test10
/dev/mapper/vg_perpetuum-test11
/dev/mapper/vg_perpetuum-test3
/dev/mapper/vg_perpetuum-test4
/dev/mapper/vg_perpetuum-test9
/dev/mapper/vg_perpetuum-testing

And leaving out mounted file systems is again as simple as

grep -v '^/dev/'

Have I missed something ?


Now for the performance. I drop caches, then run each twice

the ls_scan_targets function runs

real	0m0.575s
user	0m0.086s
sys	0m0.179s

real	0m0.241s
user	0m0.088s
sys	0m0.169s


My one-line suggestion runs

real	0m0.275s
user	0m0.027s
sys	0m0.047s

real	0m0.069s
user	0m0.015s
sys	0m0.052s


So the difference is significant, although I would not consider it
meaningful since it's really low anyway, but some people complained so I
guess someone cares and people do have different systems so...

> 
> :-)
> 
> We could have used awk to select the field, but that still doesn't
> deal with the mountpoint column being empty when it is unmounted.  I
> did briefly consider using lsblk -J, but I didn't want to add a
> dependency on the jq[1] package (and I didn't even know if RHEL/Fedora
> packages jq).
> 
> [1] https://packages.debian.org/stretch/jq

Yes Fedora does have it, but I agree that adding this dependency is not
ideal.

Thanks!
-Lukas

> 
> Cheers,
> 
> 					- Ted
