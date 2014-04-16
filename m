From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] check: add support for an external test expunging file
Date: Tue, 15 Apr 2014 20:25:50 -0400
Message-ID: <20140416002550.GB12078@thunk.org>
References: <1397530320-20579-1-git-send-email-tytso@mit.edu>
 <20140416001530.GU15995@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54842 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaDPAZy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 20:25:54 -0400
Content-Disposition: inline
In-Reply-To: <20140416001530.GU15995@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 16, 2014 at 10:15:30AM +1000, Dave Chinner wrote:
> > If the argument to the -X option is a pathname (that is, includes a
> > '/' character), treat it as the latter case.  If it the argument to
> > the -X option is just a bare filename (that is, does not include '/'
> > character), treat it as the former.
> 
> Can you add a new option rather than overloading the existing one
> with new meanings and semantics?

If that's your preference, sure.  How does --expunge-list-file strike
you?  Or would you prefer something else?  I'm easy.  :-)

      	       	   	  	    	       - Ted
