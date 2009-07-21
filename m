From: Andreas Dilger <adilger@sun.com>
Subject: Re: >16TB issues
Date: Tue, 21 Jul 2009 13:21:23 -0600
Message-ID: <20090721192123.GK4231@webber.adilger.int>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
 <20090703143729.GJ20343@webber.adilger.int>
 <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com>
 <20090721161018.GH4231@webber.adilger.int>
 <150c16850907211152y3136aadx6ce42a8535a6ed61@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58666 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbZGUTVy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 15:21:54 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6LJLoHI000259
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 12:21:50 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN500800CBP9G00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 21 Jul 2009 12:21:50 -0700 (PDT)
In-reply-to: <150c16850907211152y3136aadx6ce42a8535a6ed61@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 21, 2009  11:52 -0700, Justin Maggard wrote:
> No, no error messages from the kernel.  But your llverdev utility
> ended up showing problems on the device.  After asking around on the
> MD mailing list, that was apparently because of the page cache index
> limit (at the time I was using a 32-bit kernel).
> 
> Switching to a 64-bit kernel allowed me to pass the llverdev test and
> get much further with a very large filesystem, but I'm running into
> other issues now.  I wrote up a very simple script to write 2TB files
> onto the filesystem until the device fills up.  It was able to write
> ~16TB, but after that it ran into some problems.  My kernel log now
> has lots of messages like these:

There is a matching "llverfs" tool that does essentially this, with
data verification also.

> EXT4-fs error (device md2): ext4_mb_generate_buddy: EXT4-fs: group
> 163548: 32744 blocks in bitmap, 32768 in gd
> - and -
> EXT4-fs error (device md2): ext4_mb_mark_diskspace_used: Allocating
> block 4294967391 in system zone of 131072 group
> 
> I shouldn't need e2fsprogs to be compiled 64-bit as well, right?
> Currently I've got a 64-bit kernel with 32-bit userspace.

Yes, that is a potential problem.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

