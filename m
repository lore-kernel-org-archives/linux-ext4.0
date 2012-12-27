From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2] ext4: lock i_mutex when truncating orphan inodes
Date: Thu, 27 Dec 2012 15:07:54 +0800
Message-ID: <20121227070754.GA7573@gmail.com>
References: <1356590595-23144-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f54.google.com ([209.85.210.54]:50905 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2L0GyX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Dec 2012 01:54:23 -0500
Content-Disposition: inline
In-Reply-To: <1356590595-23144-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 27, 2012 at 01:43:14AM -0500, Theodore Ts'o wrote:
> Commit c278531d39f3 added a warning when ext4_flush_unwritten_io() is
> called without i_mutex being taken.  It had previously not been taken
> during orphan cleanup since races weren't possible at that point in
> the mount process, but as a result of this commit, we will now see a
> kernel WARN_ON in this case.  Take the i_mutex in
> ext4_orphan_cleanup() to suppress this warning.
> 
> Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                        - Zheng
