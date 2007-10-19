From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] return status from chattr
Date: Fri, 19 Oct 2007 13:55:07 -0500
Message-ID: <4718FD8B.5050803@redhat.com>
References: <46F2B47A.1070902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936361AbXJSSzL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Oct 2007 14:55:11 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id l9JIt984016777
	for <linux-ext4@vger.kernel.org>; Fri, 19 Oct 2007 14:55:09 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9JIt9pU009187
	for <linux-ext4@vger.kernel.org>; Fri, 19 Oct 2007 14:55:09 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l9JIt8Bi016327
	for <linux-ext4@vger.kernel.org>; Fri, 19 Oct 2007 14:55:08 -0400
In-Reply-To: <46F2B47A.1070902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> This is for RH bug #180596, Chattr command doesn't provide expected 
> exit code in case of failure.
> 
> (trying to clear out an e2fsprogs bug backlog, can you tell?)  :)

Any comments on this one?  Can we commit it if it looks ok?

btw:

Addresses-Red-Hat-Bugzilla: #180596

Thanks,
-Eric
