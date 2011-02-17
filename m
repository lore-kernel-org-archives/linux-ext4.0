From: Amir Goldstein <amir73il@gmail.com>
Subject: merging of adjacent extents in the extent tree
Date: Thu, 17 Feb 2011 13:57:26 +0200
Message-ID: <AANLkTik65LJpjB0ByQcvdNFuFRdUc6ODwzRtczdxS8B=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 snapshots <ext4_dreamz_project@googlegroups.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40222 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab1BQL51 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Feb 2011 06:57:27 -0500
Received: by qwa26 with SMTP id 26so2291351qwa.19
        for <linux-ext4@vger.kernel.org>; Thu, 17 Feb 2011 03:57:26 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I noticed the following item on Ext4 TODO list:
* Improve merging of adjacent extents in the extent tree
  (i.e., both to the left and to the right)
** Investigate better code factorization in all of the places that
   manipulate the extent tree (ext4_get_blocks, fallocate, direct I/O,
   uninit-to-init conversion code)

I wanted to bring to your attention (and everybody else's),
the experimental work that Yongqiang has been doing in his
ext4-defrag branch:
https://github.com/YANGYongqiang/ext4-snapshots/blob/ext4-defrag/fs/dext4/extents.c#L3547

His work is related to my post on opportunistic de-fragmentation:
http://marc.info/?l=linux-ext4&m=128927606801750&w=2

Another related work on his queue, which involves manipulation of extent
tree, is the move-on-write implementation for extent mapped files.

Anyway, if you have any tips for Yongqiang, regarding better code
factorization or other opportunities in which extent merging can
take place, please share your insight with us.

Also, if there already is a parallel effort on the subject,
please let us know, so we can collaborate efforts.

Thanks,
Amir.
