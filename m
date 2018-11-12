Return-Path: <SRS0=+plc=NX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from o1.31qt.s2shared.sendgrid.net ([167.89.106.69]:6620 "EHLO
        o1.31qt.s2shared.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731375AbeKLOjL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Nov 2018 09:39:11 -0500
To: linux-ext4@vger.kernel.org
Cc: kevin@potatofrom.space, bfields@fieldses.org
From: Kevin Liu <kevin@potatofrom.space>
Subject: ext4-nfsd interaction causes sporadic hang on rwsem_down_write_failed
Message-ID: <56454f6d-bbf8-fcd5-d389-50d5c3653ba6@potatofrom.space>
Date: Mon, 12 Nov 2018 04:38:34 +0000 (UTC)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
content-transfer-encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,=0D
=0D
I recently submitted an NFS bug=0D
(https://bugzilla.kernel.org/show_bug.cgi?id=3D201655) where nfsd randomly=
=0D
locks up on rwsem_down_write_failed:=0D
=0D
Nov 10 15:29:55 rem kernel: INFO: task nfsd:7464 blocked for more than=0D
120 seconds.=0D
Nov 10 15:29:55 rem kernel:       Tainted: P           O      4.19.1=0D
#1-NixOS=0D
Nov 10 15:29:55 rem kernel: "echo 0 >=0D
/proc/sys/kernel/hung_task_timeout_secs" disables this message.=0D
Nov 10 15:29:55 rem kernel: nfsd            D    0  7464      2 0x80000000=
=0D
Nov 10 15:29:55 rem kernel: Call Trace:=0D
Nov 10 15:29:55 rem kernel:  ? __schedule+0x1d3/0x6f0=0D
Nov 10 15:29:55 rem kernel:  schedule+0x28/0x80=0D
Nov 10 15:29:55 rem kernel:  rwsem_down_write_failed+0x15e/0x350=0D
Nov 10 15:29:55 rem kernel:  ? call_rwsem_down_write_failed+0x13/0x20=0D
Nov 10 15:29:55 rem kernel:  call_rwsem_down_write_failed+0x13/0x20=0D
Nov 10 15:29:55 rem kernel:  down_write+0x29/0x40=0D
Nov 10 15:29:55 rem kernel:  ext4_file_write_iter+0x91/0x3d0 [ext4]=0D
Nov 10 15:29:55 rem kernel:  ? nfsd_proc_write+0x160/0x160 [nfsd]=0D
Nov 10 15:29:55 rem kernel:  ? exportfs_decode_fh+0xf2/0x2b0=0D
...=0D
=0D
(more details in the bugzilla)=0D
=0D
And according to Bruce Fields:=0D
=0D
> I'm guessing it's the inode_lock at the start of ext4_file_write_iter tha=
t's blocking.  On a quick look I don't see any of the callers taking any lo=
cks.  So I'd expect that elsewhere there'd be a process holding that inode =
lock and blocking on something else.=0D
> =0D
> Based just on this might first guess would be a vfs or maybe ext4 bug rat=
her than an nfsd bug, but I'm not seeing how to reassign.  May be worth rep=
orting to the relevant mailing lists.=0D
=0D
So, starting with ext4, I was wondering if you had an idea of what the=0D
cause might be or where the fault truly lies.=0D
=0D
Kevin Liu
