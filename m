From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [1/1] fs-ext4: Deletion of an unnecessary check before the
 function call "iput"
Date: Tue, 25 Nov 2014 20:16:23 -0500
Message-ID: <20141126011623.GA20977@thunk.org>
References: <54679938.3020106@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, trivial@kernel.org,
	Coccinelle <cocci@systeme.lip6.fr>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51987 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaKZBQf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2014 20:16:35 -0500
Content-Disposition: inline
In-Reply-To: <54679938.3020106@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 15, 2014 at 07:19:36PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 15 Nov 2014 19:04:06 +0100
> 
> The iput() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Thanks, applied.

						- Ted
