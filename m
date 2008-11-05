From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH -v2 5/9] ext4: sparse annotate the group info
	semaphore
Date: Wed, 5 Nov 2008 20:29:48 +0530
Message-ID: <20081105145948.GB6244@skywalker>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081104174357.GN30291@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:53828 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYKEPD6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Nov 2008 10:03:58 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA5F2h24023594
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 02:02:43 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA5F07rP4198406
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 02:00:07 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA5F03xf016899
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 02:00:04 +1100
Content-Disposition: inline
In-Reply-To: <20081104174357.GN30291@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 04, 2008 at 12:43:57PM -0500, Theodore Tso wrote:
> I changed the description of this patch to be more grammatically
> correct:
> 
> ext4: Add sparse annotations for the group info semaphore
> 
> Hmm...  Why not merge this with patch #3, "ext4: Use
> EXT4_GROUP_INFO_NEED_INIT_BIT during resize" where alloc_semp is newly
> defined?
> 

Mostly because I found the error path annotation ugly. It is easier to
fold the patch later than split. I wanted to make sure it is the right
way to annotate.

-aneesh
