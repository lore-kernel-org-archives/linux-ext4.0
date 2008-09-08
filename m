From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: miss an unlock in ext4_check_descriptors()
Date: Mon, 8 Sep 2008 10:47:47 -0400
Message-ID: <20080908144747.GI8161@mit.edu>
References: <48C4D54E.60909@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42877 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbYIHOsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2008 10:48:53 -0400
Content-Disposition: inline
In-Reply-To: <48C4D54E.60909@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, I've applied it to the ext4 patch queue.

						- Ted
