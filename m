From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/4] ext4: minor fix in jbd2 stats kmalloc failure case
Date: Mon, 03 Dec 2007 16:23:49 -0800
Message-ID: <1196727829.4013.1.camel@localhost.localdomain>
References: <47549167.4000107@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41334 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXLDAXu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Dec 2007 19:23:50 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lB40NnG1030623
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 19:23:49 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB40Nnqn099886
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 19:23:49 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lB40Nnta013539
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 19:23:49 -0500
In-Reply-To: <47549167.4000107@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2007-12-03 at 17:29 -0600, Eric Sandeen wrote:
> (Mingming: these 4 patches can apply after 
> jbd-stats-through-procfs-with-external-journal-oops-fix.patch)
> 
Thanks Eric, looks all good to me. Updated the patch queue with the four
jbd2 stats fixes from you.

Mingming
