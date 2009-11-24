From: Justin Maggard <jmaggard10@gmail.com>
Subject: System hang with EXT4
Date: Mon, 23 Nov 2009 18:16:06 -0800
Message-ID: <150c16850911231816t514bb1dds4deb541b14a5bad6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f204.google.com ([209.85.216.204]:49833 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZKXCP7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2009 21:15:59 -0500
Received: by pxi42 with SMTP id 42so3770308pxi.5
        for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2009 18:16:06 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've recently run into an issue with ext4 and delayed allocation where
my system will silently hang just seconds into a dbench run.  I first
saw this using 2.6.30.9, but it still happens with 2.6.32-rc8.  I've
tried with an SMP x86_64 system, and a UP i386 system.  The SMP x86_64
system hangs every time for me within 15 seconds, but the UP i386
system never hangs on me.  If I remount with -o nodelalloc on the SMP
system, the hang goes away.  There are no messages printed out by the
kernel; it just locks hard.  Has anyone seen this before?  I'm just
running "dbench 500" to produce this behavior.

-Justin
