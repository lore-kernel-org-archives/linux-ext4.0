From: Bluflonalgul <bluflonalgul@gmail.com>
Subject: Ext4 bigalloc and sparc ext3 16k blocksize
Date: Fri, 20 Jan 2012 12:20:28 +0100
Message-ID: <CALbEkhsi=Nqz=rfOApPsFi_Bk+cR5NE-VXcvVEZB3nC2MxebVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60246 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2ATLU3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jan 2012 06:20:29 -0500
Received: by wgbed3 with SMTP id ed3so221310wgb.1
        for <linux-ext4@vger.kernel.org>; Fri, 20 Jan 2012 03:20:28 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some (misleading?) article on kernelnewbies.org said the new Ext4
Bigalloc feature was about supporting block size up to 1MB.
I tried to use this feature to read an ext3 fs with 16k blocksize made
on a Linux Debian Sparc (NAS).
But I couldn't read such filesystem with the Linux 3.2 kernel on x86
PC... It fails to read fs structure (as it used to fail with previous
kernels).

Could someone point me to some documentation, or give me some clues:
I'd like to understand what's wrong and if I can hope to read such fs
with Linux on x86 (natively, without fusefs tricks or additional
tools).
Thanks.
B.
