From: Alexander Peganz <a.peganz@gmail.com>
Subject: support request: how to fix corruption after offline-shrink?
Date: Mon, 22 Feb 2016 10:58:22 +0100
Message-ID: <CADtmLM9aZ5+ey78y=hddD6ZazP24juPWQOTh4hB-TjbskJNVPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33587 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbcBVJ6n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Feb 2016 04:58:43 -0500
Received: by mail-lf0-f52.google.com with SMTP id m1so90946352lfg.0
        for <linux-ext4@vger.kernel.org>; Mon, 22 Feb 2016 01:58:42 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!


Shrinking an ext4 filesystem with resize2fs 1.42.5 from Debian
Wheezy's e2fsprogs corrupted the filesystem. I have found out from
mailing list archives and blog and forum posts that offline resizing
with such old versions of resize2fs is prone to corrupt ext4
filesystems. So I probably have run into one of those bugs. If I
understand the older messages I found correctly the data is actually
still complete and undamaged, but some of the metadata was somewhat
scrambled during the resize. Now I am looking for the most reliable
way to safe the most data.


I have since updated e2fsprogs to Stretch's 1.42.13. Checking with
e2fsck -fn the fs gives me a few hundred error messages each of:
Inode X, end of extent exceeds allowed value
Logical start X does not match logical start Y at next level.
Inode X, i_blocks is Y, should be Z.
Plus a long list of Block bitmap differences.

tune2fs -l states the fs is clean with errors with the following
features: has_journal ext_attr resize_inode dir_index filetype extent
flex_bg sparse_super large_file huge_file uninit_bg dir_nlink
extra_isize

My first instinct was to e2fsck -fp the fs, but -p tells me it cannot
safely fix the fs. I dabbled a bit with debugfs (admittedly not really
knowing what exactly I'm doing) and the fs seems to be largely intact,
with little more than a hundred files of the 6TB (around 4 in use)
being affected - although I moved around 2TB worth of files to another
fs earlier before noticing the corruption, so a few dozen of those are
probably damaged.


What I'd like to know is how to proceed from here. If I run e2fsck -fy
and hope for the best - can this only make things better or do I risk
causing further damage?

I am currently waiting for a few additional disks, once they get here
I could try mounting the fs (I'm guessing mount can be convinced to
mount the fs without checking it first when the interval- and mount
count checks are disabled beforehand with tune2fs?) and just copying
files over to the new disks, but I guess that I would loose the chance
to repair any files that are currently damaged?


Any assistance that can be provided is greatly appreciated!


PS:
In case it helps here is the brief history of the fs as far as I remember it:
The fs was created unter Ubuntu 10.04LTS, so probably with a really
old version of mke2fs. It was online-grown with 10.04's resize2fs when
more disks were added to the RAID array. The array was later moved to
a Debian Wheezy server were it was in use for a few years before the
fateful offline shrink was performed.


PPS:
Not related at all to the problem but something that has always
confused me and I never found definite info on: if features that seem
to be supersets of other features (e.g. huge_file > large_file,
sparse_super2 > sparse_super) are both enabled on a fs I'm guessing
the more powerful one "wins"? Or are both flags required?
