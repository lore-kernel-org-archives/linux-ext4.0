From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Unable to build e2fsprogs 1.42.11 on RHEL 5
Date: Sat, 26 Jul 2014 10:37:53 -0400
Message-ID: <20140726143753.GE6725@thunk.org>
References: <CFF6DF2A.B393D%andreas.dilger@intel.com>
 <20140725143338.GS1865@thunk.org>
 <CFF824ED.B3D18%andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58142 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaGZOhz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 10:37:55 -0400
Content-Disposition: inline
In-Reply-To: <CFF824ED.B3D18%andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 09:36:53PM +0000, Dilger, Andreas wrote:
> 
> Unfortunately, because some of our patches add new features and modify
> configure.in the autoconf steps run automatically during the build,
> even though the patches also modify configure to include the changes
> that autoconf generates therein.

Are you running configure with --enable-maintainer-mode?  If so,
remove that configure option, and then autoconf shouldn't be run
automatically.

Cheers,

       	       	    	     	       	      - Ted
