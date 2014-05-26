From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] misc: Use unsigned long long for file block count in
 filefrag
Date: Mon, 26 May 2014 12:11:16 -0400
Message-ID: <20140526161116.GH22284@thunk.org>
References: <20140223162614.4FEF347E837@yourcmc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Vitaliy Filippov <vitalif@yourcmc.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33131 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbaEZQLU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2014 12:11:20 -0400
Content-Disposition: inline
In-Reply-To: <20140223162614.4FEF347E837@yourcmc.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 23, 2014 at 01:08:47PM +0400, Vitaliy Filippov wrote:
> This patch fixes incorrect reporting of file block count on 32-bit platforms.
> 
> Signed-off-by: Vitaliy Filippov <vitalif@yourcmc.ru>

Applied, thanks.  (Apologies for the delay.)

	 	  	     	     - Ted
