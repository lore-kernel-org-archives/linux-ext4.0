From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix oops on corrupted ext4 mount
Date: Wed, 07 Nov 2007 15:44:51 -0600
Message-ID: <473231D3.6090400@redhat.com>
References: <47323040.60509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbXKGVox (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 16:44:53 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA7LiqG6017998
	for <linux-ext4@vger.kernel.org>; Wed, 7 Nov 2007 16:44:52 -0500
In-Reply-To: <47323040.60509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> When mounting an ext4 filesystem with corrupted s_first_data_block, things 
> can go very wrong and oops.
> 
> Because blocks_count in ext4_fill_super is a u64, and we must use do_div, 
> the calculation of db_count is done differently than on ext4.

Urgh... "than on ext3"

-Eric
