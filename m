From: Johannes Berg <johannes@sipsolutions.net>
Subject: ext4 wrote extents on ext2 fs?
Date: Fri, 09 Jan 2015 23:18:28 +0100
Message-ID: <1420841908.7511.1.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49210 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbbAIWSb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jan 2015 17:18:31 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Y9hsz-0003Ty-M4
	for linux-ext4@vger.kernel.org; Fri, 09 Jan 2015 23:18:29 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm running - on an oldish kernel 3.14.26 - an ext2 filesystem with the
ext4 module, on a 1GB USB pendrive. Today the system failed to come up
properly (it's a small router providing my internet connectivity) and
this is what e2fsck had to say about the filesystem:

# e2fsck /dev/sdb1 
e2fsck 1.42.12 (29-Aug-2014)
extroot contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Inode 15817 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 15818 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 15819 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 15820 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 15821 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 15822 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 15823 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes
Inode 15824 has EXTENTS_FL flag set on filesystem without extents support.
Clear<y>? yes

Deleted inode 31403 has zero dtime.  Fix<y>? yes
Pass 2: Checking directory structure
Entry 'screenrc' in /etc (15701) has deleted/unused inode 15820.  Clear<y>? yes
Entry 'usb-serial' in /etc/modules.d (15742) has deleted/unused inode 15817.  Clear<y>? yes
Entry '09-llc' in /etc/modules.d (15742) has deleted/unused inode 15818.  Clear<y>? yes
Entry '51-ltq-vdsl-vr9' in /etc/modules.d (15742) has deleted/unused inode 15821.  Clear<y>? yes
Entry '50-ltq-vdsl-vr9-mei' in /etc/modules.d (15742) has deleted/unused inode 15822.  Clear<y>? yes
Entry 'nf-conntrack' in /etc/modules.d (15742) has deleted/unused inode 15823.  Clear<y>? yes
Entry '10-ltq-ifxos' in /etc/modules.d (15742) has deleted/unused inode 15824.  Clear<y>? yes
Entry 'root' in /etc/crontabs (15874) has deleted/unused inode 15819.  Clear<y>? yes
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -734 -(2673--2688) -(3120--3167) -(3200--3207) -68107 -68144 -(165465--165470)
Fix<y>? yes
Free blocks count wrong for group #0 (28194, counted=28267).
Fix<y>? yes
Free blocks count wrong for group #2 (30626, counted=30628).
Fix<y>? yes
Free blocks count wrong for group #5 (31297, counted=31303).
Fix<y>? yes
Free blocks count wrong (238639, counted=238720).
Fix<y>? yes
Inode bitmap differences:  -(15817--15824) -31403
Fix<y>? yes
Free inodes count wrong for group #2 (7533, counted=7541).
Fix<y>? yes
Free inodes count wrong for group #4 (7779, counted=7780).
Fix<y>? yes
Free inodes count wrong (60825, counted=60834).
Fix<y>? yes
extroot: ***** FILE SYSTEM WAS MODIFIED *****
extroot: 1886/62720 files (5.8% non-contiguous), 12160/250880 blocks


As you can see, the inodes that somehow ended up with extents were
deleted in the process of this - perhaps this shouldn't actually have
been a problem for ext4 reading the filesystem? However, based on the
symptoms of the device failure I reckon that the contents of those files
was corrupted.

I'd normally write it off to unreliable USB storage and the unreliable
system in general, however, losing 8 continuous inodes with the exact
same symptom has me a bit reluctant to do so.

Unfortunately, even though I could have, I didn't capture the filesystem
in the corrupted state, nor did I even mount it with ext4 and verify
that the files really were empty/corrupted, however I'm sure that at
least the *ltq* ones weren't usable by the system as intended.

Perhaps this is just a consequence of check ordering though - maybe if
the inode flags get corrupted then the EXTENTS flag is just the first
one that will be tested in the e2fsck code?

Anyway - make of it what you will. I might convert the filesystem to
full ext4 just in case though :-)

johannes

