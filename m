From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
Date: Fri, 6 Jun 2014 09:09:38 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406060902490.2195@localhost.localdomain>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com> <1393855228-13592-3-git-send-email-mlombard@redhat.com> <20140306154407.GA28226@thunk.org> <20140306165416.GA2182@dhcp-27-189.brq.redhat.com> <alpine.LFD.2.00.1403061842240.2249@localhost.localdomain>
 <20140526165010.GN22284@thunk.org> <alpine.LFD.2.00.1406032040210.2095@localhost.localdomain> <20140603203639.GB25483@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1108376676-1402038582=:2195"
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbaFFHJq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Jun 2014 03:09:46 -0400
In-Reply-To: <20140603203639.GB25483@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1108376676-1402038582=:2195
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 3 Jun 2014, Theodore Ts'o wrote:

> Date: Tue, 3 Jun 2014 16:36:39 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Maurizio Lombardi <mlombard@redhat.com>, adilger.kernel@dilger.ca,
>     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
> 
> On Tue, Jun 03, 2014 at 08:43:40PM +0200, Lukáš Czerner wrote:
> > 
> > I think that leaving the alignment of the start offset for the small
> > files/allocation is not good idea. We might end up with suboptimal
> > file layout for smaller files. While this is not a big deal for
> > bigger files, with smaller ones it might cause some troubles.
> 
> I thought we were only aligning the start offset for files > 2MB?
> 
> > Also I started looking into normalize_request and hopefully I'll
> > have a patch soon. Ted, do you have any suggestion for a test to
> > make sure that I do not make things worse ? You mentioned something
> > simple on LSF, but I do not remember what it was.
> 
> The two mechanisms which we have currently are:
> 
> 1) e2freefrag to measure free space fragmentation

Yes, that's what I am using along with e4defrag and debugfs -R
"dump_extents" to figure out what changed.

> 
> 2) e2fsck -fE fragcheck /dev/sdXX

I was not aware of that, thanks. However I was more interested in
workload to test on. Right now I have a simple script which is
doing:

        # Test fallocate time
        echo "[+] Fallocate test"
        time fallocate -l70G ${MNT}/file
        do_freefrag
        do_defrag ${MNT}/file
        do_debugfs /file
        rm -f ${MNT}/file
        sync

        # Copy linux source
        echo "[+] Copy linux source"
        cp -r $linux_source ${MNT}/linux1 &
        cp -r $linux_source ${MNT}/linux2 &
        time wait
        do_freefrag

        # Tar linux source
        echo "[+] Tar linux source"
        tar -cf ${MNT}/linux1_1.tar ${MNT}/linux1 &
        tar -cf ${MNT}/linux1_2.tar ${MNT}/linux1 &
        time wait
        do_freefrag
        do_defrag ${MNT}/linux1_1.tar
        do_debugfs /linux1_1.tar
        do_defrag ${MNT}/linux1_2.tar
        do_debugfs /linux1_2.tar

        # Untar linux source
        echo "[+] Untar linux source"
        mkdir ${MNT}/tt1
        mkdir ${MNT}/tt2
        tar -xf ${MNT}/linux1_1.tar -C ${MNT}/tt1 &
        tar -xf ${MNT}/linux1_2.tar -C ${MNT}/tt2 &
        time wait
        do_freefrag

        # Singe dd
        echo "[+] Single dd"
        time dd if=/dev/zero of=${MNT}/file bs=512 count=4194304
        do_freefrag
        do_defrag ${MNT}/file
        do_debugfs /file

        # Multiple dd test
        echo "[+] Multiple dd"
        # 2G
        dd if=/dev/zero of=${MNT}/file0 bs=4096 count=524288 &
        # 2G
        dd if=/dev/urandom of=${MNT}/file1 bs=512 count=4194304 &
        # 2G
        dd if=/dev/zero of=${MNT}/file2 bs=1M count=2048 &
        # 4M
        dd if=/dev/zero of=${MNT}/file3 bs=4096 count=1024 &
        # 16M
        dd if=/dev/zero of=${MNT}/file4 bs=4096 count=4096 &
        time wait
        do_freefrag
        do_defrag ${MNT}/file0
        do_debugfs /file0
        do_defrag ${MNT}/file1
        do_debugfs /file1
        do_defrag ${MNT}/file2
        do_debugfs /file2
        do_defrag ${MNT}/file3
        do_debugfs /file3
        do_defrag ${MNT}/file4
        do_debugfs /file4

        # Run fsstress
        echo "[+] Run fsstress"
        time $fsstress -s 123456 -p24 -n 999 -d $MNT
        do_freefrag
        do_defrag ${MNT}

And then do the same thing on the loop device and investigate the
underlying image file.

Thanks!
-Lukas
--8323328-1108376676-1402038582=:2195--
