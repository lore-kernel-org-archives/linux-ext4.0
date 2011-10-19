From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 0/4] ext4: Ping.
Date: Wed, 19 Oct 2011 15:47:31 +0400
Message-ID: <87y5whw6cs.fsf@dmbot.sw.ru>
References: <1316530170-3965-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, achender@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55673 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab1JSLrg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2011 07:47:36 -0400
Received: by bkbzt19 with SMTP id zt19so2003146bkb.19
        for <linux-ext4@vger.kernel.org>; Wed, 19 Oct 2011 04:47:35 -0700 (PDT)
In-Reply-To: <1316530170-3965-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 20 Sep 2011 18:49:26 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Hi, finally have some time to run some tests on recent kernels.
> And it appeared that fallocate interface is buggy
>  - fallocate: result in fsck complain due to blocks beyond i_size
>    without  EOFBLOCKS_FL
>  - punch_hole: also provoke fsck complain and even EIO due to
>    incorrect EOFBLOCKS_FL update
> 
Ping.. Tomorrow will be a month since patches was submitted,
Ted, any news, do you have plans to merge it?
PS: testcases was updated and avalable here:
   http://article.gmane.org/gmane.comp.file-systems.ext4/28602
> #LOG:
> #Following two patches are mostly cleanup 
> ext4-cleanup-ext4_ext_grow_indepth-code.patch
> ext4-move-inode-indepth-shrink-logic-to-didicated-fu.patch
> # Later patches are fixes for issues.
> ext4-Do-not-clear-EOFBLOCKS_FL-too-soon.patch
> ext4-fix-punch_hole-extend-handler.patch
> I've also attached my temp testcase for both issues
> Will submit generic xfstests based on it soon.
> 
> ########### TESTCASE###################
> #! /bin/bash
> #############################################################################
> # dmonakhov@openvz.org
> # Trivial fsstress test  
> # TODO: Add to xfstests
> # Required patches
> # kill fsstress reliably
> #  Message-Id: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
> # In order unresvsp to work kernel should contain following patch
> #  Message-Id: <1316528400-1797-1-git-send-email-dmonakhov@openvz.org>
> #############################################################################
> # FIXES FOR ext4.git:3.1.0-rc2+
> #0001-ext4-cleanup-ext4_ext_grow_indepth-code.patch
> #0002-ext4-move-inode-indepth-shrink-logic-to-didicated-fu.patch
> #0003-ext4-Do-not-clear-EOFBLOCKS_FL-too-soon.patch
> #0004-ext4-fix-punch_hole-extend-handler.patch
> #############################################################################
> IMG=/dev/sdc
> MNT=./mnt
> #MNT_EXTRA_OPS="-oloop"
> ## Create small image
> #dd if=/dev/zero of=$IMG bs=1M count=1024000
> mkfs.ext4 -F -b4096 $IMG 102400
> mkdir -p $MNT
> mount -text4 $IMG $MNT $MNT_EXTRA_OPS || exit
> ## Run stress
> ~/fsstress -p8 -f fsync=0 -f sync=0 -f fdatasync=0 -f setattr=0  -f unresvsp=2 -d $MNT/TEST -n99999999 &
> PID=$!
> ## dd writers will do write/truncate =>  ENOSPC condition
> for ((i=0;i < 10;i++))
> do
>     dd if=/dev/zero of=$MNT/FILE bs=1M
>     sleep 2
> done
> kill $!
> wait $!
> umount $MNT
> fsck.ext4 -f -n $IMG
> 
