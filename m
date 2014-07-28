From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: fix wrong size computation in
 ext4_mb_normalize_request()
Date: Sun, 27 Jul 2014 22:26:57 -0400
Message-ID: <20140728022657.GH6725@thunk.org>
References: <alpine.LFD.2.00.1407110906340.2165@localhost.localdomain>
 <1405067660-728-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59734 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaG1C1D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 22:27:03 -0400
Content-Disposition: inline
In-Reply-To: <1405067660-728-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 11, 2014 at 04:34:20PM +0800, Xiaoguang Wang wrote:
> As the member fe_len defined in struct ext4_free_extent is expressed as
> number of clusters, the variable "size" computation is wrong, we need to
> first translate fe_len to block number, then to bytes.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>

Thanks, applied.

						- Ted
