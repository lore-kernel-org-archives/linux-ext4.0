From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 3/5] ext4: add operations on delayed extent tree
Date: Thu, 8 Sep 2011 20:58:51 +0200
Message-ID: <20110908185851.GB2393@quack.suse.cz>
References: <1314694821-17213-1-git-send-email-xiaoqiangnk@gmail.com>
 <1314694821-17213-4-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com,
	adityakali@google.com, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495Ab1IJUdo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Sep 2011 16:33:44 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 82C5489471
	for <linux-ext4@vger.kernel.org>; Sat, 10 Sep 2011 22:33:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1314694821-17213-4-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 30-08-11 17:00:19, Yongqiang Yang wrote:
> This patch adds operations on a delayed extent tree.
> 
> Signed-off-by; Yongqiang Yang <xiaoqiangnk@gmail.com>
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
  I don't have time to do a full review of the series now but I definitely
think you should use RB tree to track extents. For big files written in
random manner we will just burn lots of CPU cycles needlessly...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
