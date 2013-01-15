From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Re: debuge2fs not displaying /dev folder
Date: Tue, 15 Jan 2013 23:35:19 +0530
Message-ID: <CAD6i1f+zRYovO3jw13fb4+cNVUxpOxxvWmxyPkz_GhUhvXyV2Q@mail.gmail.com>
References: <CAD6i1f+GzTqewnV=2OefPTGT8YFzNo6+zmoPvxuJXMb9r0ABng@mail.gmail.com>
 <CAD6i1f+p0-W2Pf-Pcf6phTNqrzn6h3OG+zXM3nc9hULdKq1zvw@mail.gmail.com> <CF3C02F1-C284-4E7F-9921-C6DB21A33EE5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:50803 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab3AOSFl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 13:05:41 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so217164eei.21
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2013 10:05:39 -0800 (PST)
In-Reply-To: <CF3C02F1-C284-4E7F-9921-C6DB21A33EE5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Tue, Jan 15, 2013 at 11:13 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>
>
> The first and most important question is whether "/dev" is a real
> filesystem, or if it is a virtual (e.g. "tmpfs" type) filesystem
> on your machine?

Its "devtmpfs"

> It would be useful to show "ls -li" information for some of the
> entries that appear via debugfs (e.g. "fd", "pts", and "shm" above),
> and also some of the entries that do not appear in debugfs.
>
> Cheers, Andreas

shows in debugfs :
6742 brw-rw---- 1 root disk 7, 0 Jan 15 21:45 loop0
6725 brw-rw---- 1 root disk 1, 0 Jan 15 21:45 ram0
1057 crw--w---- 1 root tty 4, 9 Jan 15 21:45 tty9

doesnt show in debugfs :
6753 crw------- 1 root root 251, 0 Jan 15 21:45 usbmon0
1866 crw-rw---- 1 root tty 7, 6 Jan 15 21:45 vcs6
1217 brw-rw---- 1 root disk 8, 0 Jan 15 21:45 sda

Regards.
