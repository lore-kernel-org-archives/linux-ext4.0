From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: let ext4_page_mkwrite stop started handle in
 failure
Date: Wed, 26 Oct 2011 05:01:52 -0400
Message-ID: <20111026090152.GR31921@thunk.org>
References: <1316055390-14476-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53379 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab1JZJB5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Oct 2011 05:01:57 -0400
Content-Disposition: inline
In-Reply-To: <1316055390-14476-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 10:56:30AM +0800, Yongqiang Yang wrote:
> The started journal handle should be stopped in failure case.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

					- Ted
