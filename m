From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V4 1/2] ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT during
	resize
Date: Wed, 26 Nov 2008 00:57:34 +0530
Message-ID: <20081125192734.GA26883@skywalker>
References: <1227641145-26775-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:45907 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYKYT1r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 14:27:47 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAPJQus9015797
	for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 06:26:56 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAPJS5Wg1540230
	for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 06:28:05 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAPJRjib025664
	for <linux-ext4@vger.kernel.org>; Wed, 26 Nov 2008 06:27:45 +1100
Content-Disposition: inline
In-Reply-To: <1227641145-26775-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2008 at 12:55:44AM +0530, Aneesh Kumar K.V wrote:
> The new groups added during resize are flagged as
> need_init group. Make sure we properly initialize these
> groups. When we have block size < page size and we are adding
> new groups the page may still be marked uptodate even though
> we haven't initialized the group. While forcing the init
> of buddy cache we need to make sure other groups part of the
> same page of buddy cache is not using the cache.
> group_info->alloc_sem is added to ensure the same.
> 
> FILENAME: aneesh-3-use_EXT4_GROUP_INFO_NEED_INIT_BIT-during-resize
> 

The two patches only have comments updated after a really nice irc
discussion with Alex.

-aneesh
