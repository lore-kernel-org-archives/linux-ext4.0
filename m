Return-Path: <SRS0=z94b=OO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mxo1.dft.dmz.twosigma.com ([208.77.212.183]:37873 "EHLO
        mxo1.dft.dmz.twosigma.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbeLEQ0V (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2018 11:26:21 -0500
From: Elana Hashman <Elana.Hashman@twosigma.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
CC: "'tytso@mit.edu'" <tytso@mit.edu>,
        "'linux-ext4@vger.kernel.org'" <linux-ext4@vger.kernel.org>,
        Thomas Walker <Thomas.Walker@twosigma.com>
Subject: RE: Phantom full ext4 root filesystems on 4.1 through 4.14 kernels
Date: Wed, 5 Dec 2018 16:26:19 +0000
Message-ID: <c7cfeaf451d7438781da95b01f21116e@exmbdft5.ad.twosigma.com>
References: <9abbdde6145a4887a8d32c65974f7832@exmbdft5.ad.twosigma.com>
 <20181108184722.GB27852@magnolia>
In-Reply-To: <20181108184722.GB27852@magnolia>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Okay, let's take a look at another affected host. I have not drained it, just cordoned it, so it's still in Kubernetes service and has running, active pods.

$ uname -a
Linux <hostname> 4.14.67-ts1 #1 SMP Wed Aug 29 13:28:25 UTC 2018 x86_64 GNU/Linux

$ df -h /
Filesystem                                              Size  Used Avail Use% Mounted on
/dev/disk/by-uuid/<some-uuid>   50G   46G  1.6G  97% /

$ df -hi /
Filesystem                                             Inodes IUsed IFree IUse% Mounted on
/dev/disk/by-uuid/<some-uuid>   3.2M  203K  3.0M    7% /

$ sudo du -hxs /
21G     /

$ sudo lsof -a +L1 /
lsof: WARNING: can't stat() fuse file system /srv/kubelet/pods/<some-path>
      Output information may be incomplete.
COMMAND  PID   USER   FD   TYPE DEVICE SIZE/OFF NLINK    NODE NAME
java    6392 user     11u   REG    8,3    55185     0 1441946 /tmp/classpath.ln0XhI (deleted)
java    6481 user     11u   REG    8,3   149313     0 1441945 /tmp/java.AwFIiw (deleted)
java    6481 user     12u   REG    8,3    55185     0 1441951 /tmp/classpath.qrQhkS (deleted)


There are many overlay mounts currently active:

$ mount | grep overlay | wc -l
40

Also some fuse mounts (as mentioned in the lsof warning on this particular machine):

$ mount | grep fuse | wc -l
21

And just to double-check, all these modules are running in-tree:

$ modinfo ext4 | grep intree
intree:         Y
$ modinfo overlay | grep intree
intree:         Y
$ modinfo fuse | grep intree
intree:         Y

- e

-----Original Message-----
From: Darrick J. Wong <darrick.wong@oracle.com> 
Sent: Thursday, November 8, 2018 1:47 PM
Subject: Re: Phantom full ext4 root filesystems on 4.1 through 4.14 kernels

This is very odd.  I wonder, how many of those overlayfses are still mounted on the system at this point?  Over in xfs land we've discovered that overlayfs subtly changes the lifetime behavior of incore inodes, maybe that's what's going on here?  (Pure speculation on my part...)
