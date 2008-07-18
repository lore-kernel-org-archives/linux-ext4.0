From: Eric Sandeen <sandeen@redhat.com>
Subject: delalloc is crippling fs_mark performance
Date: Fri, 18 Jul 2008 11:11:30 -0500
Message-ID: <4880C0B2.9040706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYGRQLc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 12:11:32 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6IGBVTs025484
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 12:11:31 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IGBVhv011229
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 12:11:31 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IGBUMS023024
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 12:11:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

running fs_mark like this:

fs_mark -d /mnt/test -D 256 -n 100000 -t 4 -s 20480 -F -S 0

(256 subdirs, 100000 files/iteration, 4 threads, 20k files, no sync)

on a 1T fs, with and without delalloc (mount option), is pretty interesting:

http://people.redhat.com/esandeen/ext4/fs_mark.png

somehow delalloc is crushing performance here.  I'm planning to wait
'til the fs is full and see what the effect is on fsck, and look at the
directory layout for differences compared to w/o delalloc.

But something seems to have gone awry here ...

This is on 2.6.26 with the patch queue applied up to stable.

-Eric
