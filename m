From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: jbd2 patches in stable queue
Date: Mon, 28 Apr 2008 13:25:00 -0700
Message-ID: <1209414300.13477.10.camel@localhost.localdomain>
References: <48162E6B.8010607@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:40327 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936946AbYD1UZE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2008 16:25:04 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3SKP3hM018172
	for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2008 16:25:03 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3SKP3MS189896
	for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2008 14:25:03 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3SKOxwP002847
	for <linux-ext4@vger.kernel.org>; Mon, 28 Apr 2008 14:25:00 -0600
In-Reply-To: <48162E6B.8010607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-04-28 at 15:07 -0500, Eric Sandeen wrote:
> Ted et al:
> 
> these 3 patches in the stable queue:
> 
> patches/jbd2-tidy-up-revoke-cache-initialization-and-destruction.patch
> patches/jbd2-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
> patches/jbd2-replace-potentially-false-assertion-with-if-block.patch
> 
> don't seem to have their jbd counterparts merged anywhere, -mm or Linus'
> tree.
> 
As far as I remember, they(at least the first 2) used to be in mm tree
then later when the author submit updated patches, Andrew got confused
with the relationship with previous patches so he took them all out. 

Mingming

