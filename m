From: Andreas Dilger <adilger@sun.com>
Subject: Re: Mounting Ext3 with Ext4
Date: Thu, 21 May 2009 01:01:46 -0400
Message-ID: <20090521050146.GC8744@webber.adilger.int>
References: <baab8ccb0905201624j56767f59mff537ab8767ffc8d@mail.gmail.com>
 <4A14ABAC.7040901@redhat.com>
 <baab8ccb0905201828i7ad6536ele72157b3e2d223c1@mail.gmail.com>
 <baab8ccb0905202137v426c8568k8fc6f53fc095c351@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Matt LaPlante <cybrmatt@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33007 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZEUFBs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 May 2009 01:01:48 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n4L51njR004385
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2009 22:01:49 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KJZ00I009SXRZ00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 20 May 2009 22:01:49 -0700 (PDT)
In-reply-to: <baab8ccb0905202137v426c8568k8fc6f53fc095c351@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 21, 2009  00:37 -0400, Matt LaPlante wrote:
> It looks likes the magic touch was to add rootfstype=ext4 to the
> kernel command line.  Prior to this the ext4 only kernel wasn't
> finding the disk, but with it attached it now appears to boot
> successfully.  Maybe worth adding a note to the wiki?

This means that your initrd has "ext3" as the root filesystem type
in /etc/fstab or similar.  If the filesystem type is explicitly
given as "ext3" then the ext4 driver will not try to mount it.


I suppose it might be reasonable to have a config option that adds
the "ext3" and "ext2" filesystem types to the ext4 driver for cases
like this where CONFIG_EXT2 and CONFIG_EXT3 (and module equivalents)
are disabled.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

