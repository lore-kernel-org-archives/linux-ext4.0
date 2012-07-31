From: Nick Semenkovich <semenko@alum.mit.edu>
Subject: "Unknown code" error when enabling metadata_csum on ext4 raid1 device
Date: Mon, 30 Jul 2012 21:53:15 -0500
Message-ID: <CAFepXZhPc0Vw-m0h_U9SnS6=CutOsGbiApe=-PEbKb3dxWOEvw@mail.gmail.com>
Reply-To: semenko@syndetics.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37253 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2GaCxg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jul 2012 22:53:36 -0400
Received: by qcro28 with SMTP id o28so3418129qcr.19
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jul 2012 19:53:36 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm trying to enable metadata_csum on an ext4 raid1 device, but end up
with a semi-cryptic error.

(This is probably the same thing Tomasz Chmielewski reported in
http://www.spinics.net/lists/linux-ext4/msg33139.html )

Is this issue being tracked someplace?

$ uname -ar
Linux dev 3.5.0-6-generic #6-Ubuntu SMP Mon Jul 23 19:52:14 UTC 2012
x86_64 x86_64 x86_64 GNU/Linux

$ git clone git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
$ ./configure
[snip]
$ make progs
[snip]
$ sudo misc/tune2fs -O metadata_csum /dev/md1
tune2fs 1.42.3 (14-May-2012)
rewrite_directory: Unknown code Ijv 64 while rewriting directories

The error code changes when I re-run tune2fs (to [a-zA-Z]*3 64).


I've tried this on the master, "next", & "pu" git branches, all with errors.


$ debugfs -R 'stats' /dev/md1 >
http://web.mit.edu/semenko/Public/debugfs-md1.txt


Best,
Nick

-- 
Nick Semenkovich
Laboratory of Dr. Jeffrey I. Gordon
Medical Scientist Training Program
School of Medicine
Washington University in St. Louis
http://web.mit.edu/semenko/
