From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] use for_each_possible_cpu for reservation slots
Date: Mon, 12 Mar 2007 12:16:21 -0500
Message-ID: <45F58AE5.8090409@redhat.com>
References: <45E49A20.5080604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965416AbXCLRVj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2007 13:21:39 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l2CHLcM1031045
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2007 13:21:38 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l2CHLcnr025674
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2007 13:21:38 -0400
In-Reply-To: <45E49A20.5080604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> NR_CPUS is a config-time option that may be much more than your actual
> count of runtime possible CPUs... 
> 
> compile-tested.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Ted, I don't see this in the git tree yet.

Yea?  Nay?  Comments?

Thanks,
-Eric
