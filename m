From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12594] filesystem corruption while running bonnie
Date: Thu,  5 Feb 2009 12:00:14 -0800 (PST)
Message-ID: <20090205200014.2EFA1108048@picon.linux-foundation.org>
References: <bug-12594-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbZBEUAq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2009 15:00:46 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n15K0EZe007769
	for <linux-ext4@vger.kernel.org>; Thu, 5 Feb 2009 12:00:15 -0800
In-Reply-To: <bug-12594-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12594





------- Comment #4 from folkert@vanheusden.com  2009-02-05 12:00 -------
> > htree went bad.  It's strange that exercising tmpfs would do this.
> > 
> > I always get worried when I see device-mapper in the picture.  It has a
> > history..  Perhaps you can describe your device-mapper setup?
> 
> (Sorry for the delayed response, had the flu)
> 
> The system is an LVM setup with /home, /, /tmp, /var, /usr and swap in
> seperate LVM slices.

Some more details:
odr:/home/folkert# vgdisplay 
  --- Volume group ---
  VG Name               VGODR
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  7
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                6
  Open LV               6
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               37.03 GB
  PE Size               4.00 MB
  Total PE              9479
  Alloc PE / Size       9479 / 37.03 GB
  Free  PE / Size       0 / 0   
  VG UUID               dlQony-04VM-KDwW-2Qul-c3gG-qr6L-faKDMH


odr:/home/folkert# lvdisplay 
  --- Logical volume ---
  LV Name                /dev/VGODR/root
  VG Name                VGODR
  LV UUID                dpFEsy-myWC-YBhp-bw1t-lakV-rKwe-Pu2lDL
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                276.00 MB
  Current LE             69
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:0

  --- Logical volume ---
  LV Name                /dev/VGODR/usr
  VG Name                VGODR
  LV UUID                xJdCNc-k3iv-czxs-rUdd-tIi1-0Vab-Xk13U3
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                4.77 GB
  Current LE             1221
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:1

  --- Logical volume ---
  LV Name                /dev/VGODR/var
  VG Name                VGODR
  LV UUID                lbqzC7-NDIC-t9rT-Eqo2-1iQS-EadB-tnHkPq
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                2.86 GB
  Current LE             733
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:2

  --- Logical volume ---
  LV Name                /dev/VGODR/swap_1
  VG Name                VGODR
  LV UUID                olCdBr-asFX-3K32-zXQ8-6ee0-ou0M-PYbnro
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                1.38 GB
  Current LE             354
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:3

  --- Logical volume ---
  LV Name                /dev/VGODR/tmp
  VG Name                VGODR
  LV UUID                nsFpW0-eUtE-F8nL-a4rN-80vQ-6mo2-EVbtph
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                392.00 MB
  Current LE             98
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:4

  --- Logical volume ---
  LV Name                /dev/VGODR/home
  VG Name                VGODR
  LV UUID                0l3HlK-rrsR-WWLZ-ZMip-bmHE-tRD2-sp7DAk
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                27.36 GB
  Current LE             7004
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:5



Folkert van Heusden


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
