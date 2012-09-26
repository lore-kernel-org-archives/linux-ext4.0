From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ext4_bread usage audit
Date: Tue, 25 Sep 2012 23:42:40 -0400
Message-ID: <20120926034240.GE11468@thunk.org>
References: <1348512100-23323-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52389 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2IZDmn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2012 23:42:43 -0400
Content-Disposition: inline
In-Reply-To: <1348512100-23323-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 24, 2012 at 03:41:40PM -0300, Carlos Maiolino wrote:
> 
> Some ext4_bread callers do not needed any changes either because they already
> had its own hole detector paths or because these are deprecaded (like
> dx_show_entries)

BTW, dx_show entries isn't really deprecated; is debugging code which
is usually not compiled in, but it does get used from time to time by
developers who are debugging the directory hash tree code...

So having it show the holes by printing a note that there _was_ a
whole is probably a good thing from a debugging point of view...

      	 	    	       - Ted
