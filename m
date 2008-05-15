From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Group meta-data blocks together.
Date: Thu, 15 May 2008 21:36:26 +0530
Message-ID: <20080515160626.GB23507@skywalker>
References: <1210866839-7195-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1210866839-7195-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:49520 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYEOQGh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 May 2008 12:06:37 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4FG5jdP019382
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2008 02:05:45 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4FG6NG51531934
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2008 02:06:23 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4FG6YUt010218
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2008 02:06:34 +1000
Content-Disposition: inline
In-Reply-To: <1210866839-7195-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 15, 2008 at 09:23:59PM +0530, Aneesh Kumar K.V wrote:
> This adds a per inode meta-block prealloc space from which
> meta-data block requests are served. This help in making
> sure meta-data block are closer. This is needed to speedup
> unlink of the file. Any new prealloc space is allocated near
> the goal block specified. The goal block is the last block
> allocated for the file. So we don't keep the data-block and
> meta-data block far apart.
> 

The result can be found at

http://www.radian.org/~kvaneesh/ext4/meta-group/

This patch need to be further improved by grouping the meta-data
at FLEX_BG or block group level rather than per inode. I am sending
it so that others can take a look at the changes

-aneesh

