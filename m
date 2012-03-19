From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/9] ext4: Fix indentation
Date: Sun, 18 Mar 2012 21:30:57 -0700
Message-ID: <1332131457.23125.48.camel@joe2Laptop>
References: <cover.1331856299.git.joe@perches.com>
	 <3457473a97c505cf9e5c5a34781a82e4e867a2e6.1331856300.git.joe@perches.com>
	 <20120319041046.GH31682@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:56068 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754084Ab2CSEa7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Mar 2012 00:30:59 -0400
In-Reply-To: <20120319041046.GH31682@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2012-03-19 at 00:10 -0400, Ted Ts'o wrote:
> On Thu, Mar 15, 2012 at 05:07:31PM -0700, Joe Perches wrote:
> > Indent a line appropriate.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> I'll fix indentation and whitespaces if I need to actually go in and
> mess with that particular part of the code, but otherwise (since it
> doesn't apply cleanly standalone anyway), I'm not going to bother...

No worries, it was next to a pr_<level> change and I
just happened to notice it.


