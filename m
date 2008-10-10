From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: exit from preenhalt if IO errors were encountered
Date: Fri, 10 Oct 2008 17:39:01 -0500
Message-ID: <48EFD985.6090206@redhat.com>
References: <48EFD3B0.4060009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57185 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbYJJWjD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Oct 2008 18:39:03 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9AMd3Oi007011
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:39:03 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9AMd29a026790
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:39:03 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9AMd1Yu023871
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:39:02 -0400
In-Reply-To: <48EFD3B0.4060009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Resolves RH Bug 465679- e2fsck -p crashes with read-only DM device (e.g. logical volume)  
> 
> If a block device is unwritable, e2fsck -p gets into an infinite loop
> trying to preenhalt, close & flush the fs, which tries to flush the cache, 
> which gets a write error and calls preenhalt which tries to close & flush
> the fs ... ad infinitum.
> 
> Per Ted's suggestion just flag the ctx as "exiting" and short-circuit
> the infinite loop.
> 
> Tested by running e2fsck -p on a block device set read-only by BLKROSET.

Oh, thanks to Vlado Potisk for reporting this.

-Eric
