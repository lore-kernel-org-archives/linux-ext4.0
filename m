From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [ext4:dev 40/60] fs/ext4/inode.c:1953
 __ext4_journalled_writepage() error: potential NULL dereference 'page_bufs'.
Date: Tue, 4 Dec 2012 16:56:02 +0300
Message-ID: <20121204135602.GE22569@mwanda>
References: <20121204111011.GD22569@mwanda>
 <1354627545-2792-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51567 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab2LDN4N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2012 08:56:13 -0500
Content-Disposition: inline
In-Reply-To: <1354627545-2792-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 04, 2012 at 09:25:45PM +0800, Tao Ma wrote:
> Hi Dan,
> 	Thanks for the report. Can you check whether this patch
> works for you?
> 

It looks good.

Like I mentioned before Smatch doesn't understand
ext4_has_inline_data() so it still complains later on in the
function.  But it's now obvious to a human reader that there won't
be a NULL dereference.

regards,
dan carpenter

