From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: defragmentation of boot related files
Date: Thu, 26 Aug 2010 17:50:59 +0900
Message-ID: <4C762AF3.8020303@sx.jp.nec.com>
References: <4C7505C3.1070509@rid-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: andreas@rid-net.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37110 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab0HZIwo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Aug 2010 04:52:44 -0400
In-Reply-To: <4C7505C3.1070509@rid-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,
Thanks for the comments.

2010/08/25 21:00, andreas@rid-net.de wrote:
> Is there a reason why the offset of the original file and the donor file 
> must be the same?

e4defrag creates a donor file whose size is the same of the original file by
fallocate. There is a possibility that the original file will be corrupted
after moving an extent if the offset of the original file and the donor file
are different. So they are checked in the kernel space, but it may be
unnecessary from the point of view of the ioctl.

> As i can see the patch for relevant file defragmentation in e4defrag 
> supports only directories. May it be possible to select any desired file?

That's interesting. I came up with the new interface of e4defrag -r.
What do you think the following implementation idea?

Usage: e4defrag -r directory...| device...
       e4defrag -r base_file move_file...     <--- new

1. Defrag base_file to reduce fragmentation of extents (call EXT4_IOC_MOVE_EXT)
2. Preallocate physical blocks near the data blocks of base_file
3. Move move_file's extents to the blocks that are allocated by (2).
4. Repeat (2) and (3) for all files specified as move_file

Regards,
Kazuya Mio
