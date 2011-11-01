From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] jbd2: Unify log messages in jbd2 code
Date: Tue, 1 Nov 2011 19:10:12 -0400
Message-ID: <20111101231012.GM32161@thunk.org>
References: <1320113150-27457-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41720 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab1KAXKM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 19:10:12 -0400
Content-Disposition: inline
In-Reply-To: <1320113150-27457-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 01, 2011 at 10:05:50AM +0800, Eryu Guan wrote:
> Some jbd2 code prints out kernel messages with "JBD2: " prefix, at the
> same time other jbd2 code prints with "JBD: " prefix. Unify the prefix
> to "JBD2: ".
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Thanks, applied.

					- Ted
