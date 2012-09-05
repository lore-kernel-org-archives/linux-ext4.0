From: Kevin Liao <kevinlia@gmail.com>
Subject: Re: [PATCH 2/2] resize2fs: fix overhead calculation for meta_bg file systems
Date: Wed, 5 Sep 2012 14:32:32 +0800
Message-ID: <CAF_MivFMtFvTN9Gwdjk+imenuUHOcO3vbeha6nt+eqovRK3VXw@mail.gmail.com>
References: <20120903164525.GD5066@thunk.org>
	<1346690758-21072-1-git-send-email-tytso@mit.edu>
	<1346690758-21072-2-git-send-email-tytso@mit.edu>
	<CAGBYx2a8J1ZvWDjgv3snTCE59nqurF_sGYJ0pxSy2anXjzfBRg@mail.gmail.com>
	<20120904021412.GG5066@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Anssi Hannula <anssi.hannula@iki.fi>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35140 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2IEGcd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Sep 2012 02:32:33 -0400
Received: by yenl14 with SMTP id l14so24200yen.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Sep 2012 23:32:32 -0700 (PDT)
In-Reply-To: <20120904021412.GG5066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/9/4 Theodore Ts'o <tytso@mit.edu>:
> On Tue, Sep 04, 2012 at 09:59:55AM +0800, Yongqiang Yang wrote:
>> Hi Kevin,
>>
>>   Ted has sent out the patches on online resizing for meta_bg and
>> 64bits, so you can have a try again. It seems that the bug in
>> e2fsprogs has been fixed.
>
> Make sure you use the latest version of the kernel patches that I just
> sent out.  There quite a number of bugs in the Yongqiang's original
> patch set which I tripped over while I was testing 64-bit resize ---
> and please note that there are definitely still rough edges
> (especially for in cases where the file system was created < 16TB, but
> with the 64-bit feature and resize_inode features enabled).  There may
> also be bugs for the straightforward case of resizing very large file
> systems.
>
> So while I very much appreciate users giving the code a try and
> sending us feedback, please do think twice before using this code on
> file systems with data that hasn't been backed up recently.  (Of
> course, being good System Administrators you are all keeping --- and
> verifying --- regular backups, right?  :-)
>
> Regards,
>
>                                                 - Ted

I had done some simple and quick test. The following is the result.

Kernel: 3.4.7 + 5 patches
e2fsprogs: 1.42.5 + 2 patches

The format command I used is:
mke2fs -t ext4 -m0 -b 4096 -F -O 64bit,meta_bg,^resize_inode /dev/md0 nnnn

Case 1: Simplly resize
1st step: resize from 14T to 18T => ok
2nd step: resize from 18T to 20T => ok (calculate_minimum_resize_size
issue gone)
3rd step: resize from 20T to 21T => ok

Case 2: case 1 + file read-write (just like Anssi did)
1st step: resize from 14T to 20T (5368709120 blocks) => ok
2nd step: resize from 20T to 5368709170 blocks => same kernel bug_on

Case 3: case 2 + Yongqiang's 2 patches
1st step: resize from 14T to 20T (5368709120 blocks) => ok
2nd step: resize from 20T to 5368709170 blocks => ok

Basically I think the resize funtionality should be ok. However I also
observe some performance drop. That is, the time needed for mke2fs,
mount and e2fsck are longer than before. Here is some detailed data:

For 12TB with 64bit,meta_bg,^resize_inode
mke2fs: 54.699s
mount: 12.108s
e2fsck: 1m52.027s

For 12TB without 64bit,meta_bg,^resize_inode
mke2fs: 39.763s
mount: 0.897s
e2fsck: 1m17.554s

For 20TB with 64bit,meta_bg,^resize_inode
mke2fs: 1m25.090s
mount: 19.992s
e2fsck: 2m55.048s

For 20TB without 64bit,meta_bg,^resize_inode
mke2fs: 1m3.660s
mount: 1.458s
e2fsck: 1m56.055s

Yongqiang had told me previously that it may be caused by using
meta_bg. I am still wondering is there anything we can do to improve
the peroformance? Thanks a lot.

Regards,
Kevin Liao
