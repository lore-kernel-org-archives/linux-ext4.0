From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH -V3 04/11] ext4: Add percpu dirty block accounting.
Date: Sat, 11 Oct 2008 15:10:07 -0600
Message-ID: <20081011211007.GB2009@webber.adilger.int>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <48EE6D43.7070404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org,
	Alex Zhuravlev <Alex.Zhuravlev@sun.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60886 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760262AbYJKVKW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 17:10:22 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m9BLAJNa009296
	for <linux-ext4@vger.kernel.org>; Sat, 11 Oct 2008 14:10:20 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K8L00J01ET09D00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 11 Oct 2008 14:10:19 -0700 (PDT)
In-reply-to: <48EE6D43.7070404@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 09, 2008  15:44 -0500, Eric Sandeen wrote:
> Somehow, though, we seem to be allocating only 2048 blocks at a time
> (haven't worked out why, yet - this also seems problematic) - but at any
> rate, losing (32767-2048) blocks in each loop from fallocate seems to be
> causing this space loss and eventual ENOSPC.

I believe the 2048-block (8MB) allocation limit is imposed by mballoc to
avoid scanning the whole filesystem looking for huge chunks of free disk.
That said, it would be nice if there IS lots of free space that this is
allocated optimistically if possible.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

