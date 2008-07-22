From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Convert the usage of NR_CPUS to nr_cpu_ids.
Date: Tue, 22 Jul 2008 17:58:04 -0600
Message-ID: <20080722235804.GA20749@webber.adilger.int>
References: <1216732665-26924-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:61220 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbYGVX6M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2008 19:58:12 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6MNwBS7006803
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 16:58:11 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4F00401MIG0500@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 22 Jul 2008 16:58:11 -0700 (PDT)
In-reply-to: <1216732665-26924-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 22, 2008  18:47 +0530, Aneesh Kumar wrote:
> NR_CPUS can be really large. We should be using nr_cpu_ids
> instead.

Should this actually be num_possible_cpus() or num_online_cpus()?
I've never seen nr_cpu_ids used before.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

