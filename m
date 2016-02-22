From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: support request: how to fix corruption after offline-shrink?
Date: Mon, 22 Feb 2016 14:51:57 -0700
Message-ID: <935D79B1-4451-4677-A650-353615C61E3A@dilger.ca>
References: <CADtmLM9aZ5+ey78y=hddD6ZazP24juPWQOTh4hB-TjbskJNVPA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Alexander Peganz <a.peganz@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:34734 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbcBVVv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Feb 2016 16:51:57 -0500
Received: by mail-ig0-f181.google.com with SMTP id g6so97566085igt.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 Feb 2016 13:51:57 -0800 (PST)
In-Reply-To: <CADtmLM9aZ5+ey78y=hddD6ZazP24juPWQOTh4hB-TjbskJNVPA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 22, 2016, at 2:58 AM, Alexander Peganz <a.peganz@gmail.com> wrote:
> Shrinking an ext4 filesystem with resize2fs 1.42.5 from Debian
> Wheezy's e2fsprogs corrupted the filesystem. I have found out from
> mailing list archives and blog and forum posts that offline resizing
> with such old versions of resize2fs is prone to corrupt ext4
> filesystems. So I probably have run into one of those bugs. If I
> understand the older messages I found correctly the data is actually
> still complete and undamaged, but some of the metadata was somewhat
> scrambled during the resize. Now I am looking for the most reliable
> way to safe the most data.
> 
> 
> I have since updated e2fsprogs to Stretch's 1.42.13. Checking with
> e2fsck -fn the fs gives me a few hundred error messages each of:
> Inode X, end of extent exceeds allowed value
> Logical start X does not match logical start Y at next level.
> Inode X, i_blocks is Y, should be Z.
> Plus a long list of Block bitmap differences.
> 
> tune2fs -l states the fs is clean with errors with the following
> features: has_journal ext_attr resize_inode dir_index filetype extent
> flex_bg sparse_super large_file huge_file uninit_bg dir_nlink
> extra_isize
> 
> My first instinct was to e2fsck -fp the fs, but -p tells me it cannot
> safely fix the fs. I dabbled a bit with debugfs (admittedly not really
> knowing what exactly I'm doing) and the fs seems to be largely intact,
> with little more than a hundred files of the 6TB (around 4 in use)
> being affected - although I moved around 2TB worth of files to another
> fs earlier before noticing the corruption, so a few dozen of those are
> probably damaged.
> 
> 
> What I'd like to know is how to proceed from here. If I run e2fsck -fy
> and hope for the best - can this only make things better or do I risk
> causing further damage?
> 

> I am currently waiting for a few additional disks, once they get here
> I could try mounting the fs (I'm guessing mount can be convinced to
> mount the fs without checking it first when the interval- and mount
> count checks are disabled beforehand with tune2fs?) and just copying
> files over to the new disks, but I guess that I would loose the chance
> to repair any files that are currently damaged?

If you have the capacity to do so, it is recommended to make a full "dd"
backup of the original filesystem device, and then run "e2fsck -fy" on
the backup, so that you can always make _another_ copy from the original
should this go badly.  If the "e2fsck -fy" on the backup goes well, you
can run e2fsck on the primary copy, or just use the new copy and reformat
the original (after possibly keeping it around for some time for safety).


> Any assistance that can be provided is greatly appreciated!
> 
> 
> PS:
> In case it helps here is the brief history of the fs as far as I remember it:
> The fs was created unter Ubuntu 10.04LTS, so probably with a really
> old version of mke2fs. It was online-grown with 10.04's resize2fs when
> more disks were added to the RAID array. The array was later moved to
> a Debian Wheezy server were it was in use for a few years before the
> fateful offline shrink was performed.
> 
> 
> PPS:
> Not related at all to the problem but something that has always
> confused me and I never found definite info on: if features that seem
> to be supersets of other features (e.g. huge_file > large_file,
> sparse_super2 > sparse_super) are both enabled on a fs I'm guessing
> the more powerful one "wins"? Or are both flags required?

In some cases the new feature supersedes the older one, but often they
are complimentary.  For example "large_file" allows storing the high 32
bits of the file size (i.e. files > 2^32 bytes in size = 4GB), while
"huge_file" allows storing the high 16 bits of the block count (i.e.
files > 2^32 sectors in size = 2TB), so they both need to be enabled.

Cheers, Andreas





