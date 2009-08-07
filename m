From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13930] New: non-contiguous files (64.9%) on a ext4 fs
Date: Fri, 7 Aug 2009 09:58:47 GMT
Message-ID: <bug-13930-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44856 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbZHGJ6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2009 05:58:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n779wlAd032014
	for <linux-ext4@vger.kernel.org>; Fri, 7 Aug 2009 09:58:47 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D13930

           Summary: non-contiguous files (64.9%) on a ext4 fs
           Product: File System
           Version: 2.5
    Kernel Version: Linux version 2.6.31-rc5 (logik@LogikPC) (gcc versi=
on
                    4.3.3 (Debian 4.3.3-15) ) #1 SMP PREEMPT Sat Aug 1
                    19:52:55 CEST 2009
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: zelogik+bugzilla@gmail.com
        Regression: No


Normally ext4 is a perfect non-contifuous FS ... so why when I make an:

sudo e2fsck -v -f -p /dev/sdc1

   15953 inodes used (0.03%)
   10361 non-contiguous files (64.9%)
       7 non-contiguous directories (0.0%)
         nombre d'i-noeuds avec des blocs ind/dind/tind=C2=A0: 0/0/0
         Histogramme des profondeurs d'extents=C2=A0: 14555/1388
234324740 blocks used (95.96%)
       0 bad blocks
       1 large file

   14728 regular files
    1216 directories
       0 character device files
       0 block device files
       0 fifos
       0 links
       0 symbolic links (0 fast symbolic links)
       0 sockets
--------
   15944 files



We have 64.9% of non-contiguous files on a ext4 fs,=20

=46iles have been transfered from a cifs mount (useful ?) and files siz=
e are
[2-10]|[600-800]MB


Some references:
Lacie 1To on usb with usb-Hitachi_HDS721010KLA330

Want more info ... just ask because I don't know what send now for help=
 you :)

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
