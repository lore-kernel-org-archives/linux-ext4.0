From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] e2image: Print a warning if running over a mounted
 filesystem
Date: Mon, 30 Sep 2013 17:35:36 -0300
Message-ID: <20130930203534.GA7552@orion.maiolino.org>
References: <1380308495-3956-1-git-send-email-cmaiolino@redhat.com>
 <20130930202439.GE5845@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab3I3Ufl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Sep 2013 16:35:41 -0400
Content-Disposition: inline
In-Reply-To: <20130930202439.GE5845@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Roger,

should send a manpage update today yet

Cheers, and thanks for the review eric and ted
On Mon, Sep 30, 2013 at 04:24:39PM -0400, Theodore Ts'o wrote:
> On Fri, Sep 27, 2013 at 04:01:35PM -0300, Carlos Maiolino wrote:
> > Several users use to run e2image over a mounted RW filesystem, providing
> > inconsistent, useless e2images for debugging purposes.
> > This patch adds a warning in such cases, notifying the user and also adds a
> > force option making e2image able to run in such cases.
> > Also print a warning when not using qcow or raw formats but allows image
> > creation to proceed, since, such images might be used for metadata backup
> > purposes.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> This looks good to me; go ahead and update the man page.  :-)
> 
>      	   	       	  	    	   - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
