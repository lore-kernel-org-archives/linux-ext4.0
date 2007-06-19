From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: delayed allocatiou result in Oops
Date: Tue, 19 Jun 2007 22:17:27 +0530
Message-ID: <4678089F.3050804@linux.vnet.ibm.com>
References: <20070614072352.GA6517@localhost.sw.ru> <4672202C.4080304@clusterfs.com> <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com> <20070616081426.GB14349@localhost.sw.ru> <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com> <46778186.9030306@clusterfs.com> <1182270229.4113.8.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41905 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbXFSQrd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 12:47:33 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l5JH9Dqo228670
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 03:09:13 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5JGp2oL190588
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 02:51:02 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5JGlUWK013278
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 02:47:30 +1000
In-Reply-To: <1182270229.4113.8.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Mingming Cao wrote:
> O
> 
> BTW, can you point me your latest and greatest mballoc patch? I am
> trying to forward port and merge that patch to ext4 patch queue....
> 
> 

I am looking at the one found at.

ftp://ftp.clusterfs.com/pub/people/alex/2.6.19-rc6


-aneesh
