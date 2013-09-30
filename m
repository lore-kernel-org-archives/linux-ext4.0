From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2image: Print a warning if running over a mounted
 filesystem
Date: Mon, 30 Sep 2013 16:24:39 -0400
Message-ID: <20130930202439.GE5845@thunk.org>
References: <1380308495-3956-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40350 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab3I3UYn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Sep 2013 16:24:43 -0400
Content-Disposition: inline
In-Reply-To: <1380308495-3956-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 27, 2013 at 04:01:35PM -0300, Carlos Maiolino wrote:
> Several users use to run e2image over a mounted RW filesystem, providing
> inconsistent, useless e2images for debugging purposes.
> This patch adds a warning in such cases, notifying the user and also adds a
> force option making e2image able to run in such cases.
> Also print a warning when not using qcow or raw formats but allows image
> creation to proceed, since, such images might be used for metadata backup
> purposes.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

This looks good to me; go ahead and update the man page.  :-)

     	   	       	  	    	   - Ted
