From: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: [Bugme-new] [Bug 12594] New: filesystem corruption while
	running bonnie
Date: Thu, 5 Feb 2009 20:59:31 +0100
Message-ID: <20090205195931.GT21127@vanheusden.com>
References: <bug-12594-10286@http.bugzilla.kernel.org/> <20090201124953.fbae0e76.akpm@linux-foundation.org> <20090204121042.GK21127@vanheusden.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4642 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZBEUAb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2009 15:00:31 -0500
Content-Disposition: inline
In-Reply-To: <20090204121042.GK21127@vanheusden.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
MultiTail is een flexibele tool voor het volgen van logfiles en
uitvoer van commando's. Filteren, van kleur voorzien, mergen,
'diff-view', etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
