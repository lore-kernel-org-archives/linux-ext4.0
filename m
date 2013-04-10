From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix cpu_vs_disk conversions
Date: Wed, 10 Apr 2013 00:01:51 -0400
Message-ID: <20130410040151.GB4862@thunk.org>
References: <1364986711-3630-1-git-send-email-dmonakhov@openvz.org>
 <1364986711-3630-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33034 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3DJEB6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Apr 2013 00:01:58 -0400
Content-Disposition: inline
In-Reply-To: <1364986711-3630-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've broken up this patch into three patches for ease of review.

     	       	    	       	     	     - Ted
