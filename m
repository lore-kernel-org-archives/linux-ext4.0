From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests: very basic defragmentation testing for xfs
 & ext4
Date: Wed, 15 Jul 2009 16:47:03 -0500
Message-ID: <4A5E4E57.7000802@sandeen.net>
References: <4A5E3A37.5050306@redhat.com> <20090715213001.GH14175@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs mailing list <xfs@oss.sgi.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45626 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbZGOVrJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jul 2009 17:47:09 -0400
In-Reply-To: <20090715213001.GH14175@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jul 15, 2009  15:21 -0500, Eric Sandeen wrote:
>> This test creates some files, runs defrag on them,
>> and compares the before/after fragmentation as well
>> as file md5sums and timestamps.
>>
>> (md5sums may just be reading buffered data though,
>> suggestions?)
> 
> (umount; mount)?

I suppose that'd work :)

-Eric

> Cheers, Andreas
