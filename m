From: Andreas Dilger <adilger@sun.com>
Subject: Re: ioctl32 (was Re: filefrag abort)
Date: Wed, 22 Jul 2009 11:01:52 -0600
Message-ID: <20090722170152.GN4231@webber.adilger.int>
References: <4A64E650.6020603@cox.net> <20090721020312.GL2416@mit.edu>
 <4A665E3F.7000109@cox.net> <4A666413.5030301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Ron Johnson <ron.l.johnson@cox.net>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58078 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZGVRCT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jul 2009 13:02:19 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6MH2JvW023121
	for <linux-ext4@vger.kernel.org>; Wed, 22 Jul 2009 10:02:19 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN70090008R9900@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 22 Jul 2009 10:02:19 -0700 (PDT)
In-reply-to: <4A666413.5030301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 21, 2009  19:57 -0500, Eric Sandeen wrote:
> Ron Johnson wrote:
> > On 2009-07-20 21:03, Theodore Tso wrote:
> >> On Mon, Jul 20, 2009 at 04:49:04PM -0500, Ron Johnson wrote:
> >>> Hi,
> >>>
> >>> (Is this OT?  http://sourceforge.net/forum/forum.php?forum_id=7052  
> >>> doesn't show much activity...)
> >>>
> >>> Debian Sid, e2fsprogs 1.41.8-1
> >>> Home-rolled 64-bit 2.6.30 with 32-bit userland
> >> Should be fixed in e2fsprogs 1.41.8-2
> > 
> > ff seems to work now, but I still get this in dmesg:
> > 
> > [188883.274547] ioctl32(filefrag:7086): Unknown cmd fd(3) 
> > cmd(c020660b){t:'f';sz:32} arg(ffacb808) on /some/large/file
> 
> Huh, did we miss a compat ioctl for fiemap.... looks like so.  I'll look
> into that tomorrow, thanks.

Sigh, I wish there was some sort of automatic ioctl parser tool that
would report if the ioctl will need compat handling or not.  I thought
the fiemap structs didn't need any compat handling because they are
properly sized/aligned and w/o pointers...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

