From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: ext4_find_next_zero_bit needs an aligned address
	on some arch
Date: Wed, 20 Feb 2008 08:25:19 -0800
Message-ID: <1203524719.3605.4.camel@localhost.localdomain>
References: <1203518487-7214-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <47BC3E14.4050708@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56225 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934147AbYBTQZc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Feb 2008 11:25:32 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1KGPWx5013986
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 11:25:32 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1KGPUHi250476
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 11:25:31 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1KGPTDW017904
	for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2008 11:25:29 -0500
In-Reply-To: <47BC3E14.4050708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-02-20 at 08:49 -0600, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > ext4_find_next_zero_bit and ext4_find_next_bit needs a long aligned
> > address on x8_64. Add mb_find_next_zero_bit and mb_find_next_bit
> > and use them in the mballoc.
> > 
> > Fix: https://bugzilla.redhat.com/show_bug.cgi?id=433286
> > 
> > Eric Sandeen debugged the problem and suggested the fix.
> 
> Also, Ted & Mingming: we probably should get this into 2.6.25; at least
> w/ the way the Fedora kernel is configured, ext4 is pretty much DOA w/o
> this change.  I'm not sure why it started showing up now, but it is, in
> a big way. :)
> 

Acked, and added to ext4 patch queue. 

Thanks,
Mingming
