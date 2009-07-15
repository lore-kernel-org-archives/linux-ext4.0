From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] xfstests: very basic defragmentation testing for xfs &	ext4
Date: Wed, 15 Jul 2009 17:30:01 -0400
Message-ID: <20090715213001.GH14175@webber.adilger.int>
References: <4A5E3A37.5050306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: xfs mailing list <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44171 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZGOVaY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 17:30:24 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6FLU5tH028427
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 14:30:17 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KMU00E00EAHGW00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 15 Jul 2009 14:30:05 -0700 (PDT)
In-reply-to: <4A5E3A37.5050306@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 15, 2009  15:21 -0500, Eric Sandeen wrote:
> This test creates some files, runs defrag on them,
> and compares the before/after fragmentation as well
> as file md5sums and timestamps.
> 
> (md5sums may just be reading buffered data though,
> suggestions?)

(umount; mount)?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

