From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH -v2] percpu_counters: make fbc->count read atomic on	32
 bit architecture
Date: Mon, 25 Aug 2008 17:18:05 -0600
Message-ID: <20080825231805.GB3392@webber.adilger.int>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219663639.8515.47.camel@twins> <20080825140518.GA7391@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, cmm@us.ibm.com,
	tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:39231 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbYHYXSP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2008 19:18:15 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7PNIAiF014436
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:18:10 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K6600H01J8NYW00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 25 Aug 2008 16:18:10 -0700 (PDT)
In-reply-to: <20080825140518.GA7391@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 25, 2008  19:35 +0530, Aneesh Kumar wrote:
> BTW does it make sense to do
> the above unconditionally now ? ie to remove the #if ?. How much
> impact would it be to do read_seqbegin and read_seqretry on a 64bit
> machine too ?

If we don't need it, why do it?  There is no benefit and just overhead.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

