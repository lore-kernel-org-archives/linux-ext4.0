From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Convert the usage of NR_CPUS to nr_cpu_ids.
Date: Wed, 23 Jul 2008 13:27:42 +0530
Message-ID: <20080723075742.GB15091@skywalker>
References: <1216732665-26924-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080722235804.GA20749@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:45898 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751222AbYGWNau (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2008 09:30:50 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6NDU0Wv008390
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 19:00:29 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6N7vjkt876664
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 13:27:46 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6N7vjH1011101
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 13:27:45 +0530
Content-Disposition: inline
In-Reply-To: <20080722235804.GA20749@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 22, 2008 at 05:58:04PM -0600, Andreas Dilger wrote:
> On Jul 22, 2008  18:47 +0530, Aneesh Kumar wrote:
> > NR_CPUS can be really large. We should be using nr_cpu_ids
> > instead.
> 
> Should this actually be num_possible_cpus() or num_online_cpus()?
> I've never seen nr_cpu_ids used before.
> 

introduced in 
git show 53b8a315b76a3f3c70a5644976c0095460eb13d8
    [PATCH] Convert highest_possible_processor_id to nr_cpu_ids

lots of eg: that does NR_CPU to nr_cpu_ids conversion

git  show 0c0b0aca66b3a58e12a216d992a0b534eff210e0
    net: remove NR_CPUS arrays in net/core/dev.c

-aneesh

