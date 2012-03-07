From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] configure: sort AC_CHECK_FUNCS list
Date: Tue, 6 Mar 2012 20:20:39 -0500
Message-ID: <20120307012039.GC5717@thunk.org>
References: <1330925597-6938-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40360 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953Ab2CGQWm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2012 11:22:42 -0500
Content-Disposition: inline
In-Reply-To: <1330925597-6938-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 12:33:17AM -0500, Mike Frysinger wrote:
> By using m4_flatten, should be easier to maintain this list.
> 
> Regen configure and config.h.in after doing this.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks, applied.  I modified this commit to include using m4_flatten
for the list of headers fed to AC_CHECK_HEADERS.

    	     		       - Ted
