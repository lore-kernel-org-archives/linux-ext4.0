From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V4 00/11] 2fsprogs/mke2fs: add an option: -d
 root-directory
Date: Thu, 6 Mar 2014 18:59:14 -0800
Message-ID: <20140307025914.GB28451@birch.djwong.org>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
 <CF3D6C67.74AD8%dvhart@linux.intel.com>
 <5318426C.50105@windriver.com>
 <20140306163052.GA29061@thunk.org>
 <5319342D.3020109@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Darren Hart <dvhart@linux.intel.com>,
	linux-ext4@vger.kernel.org
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51592 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaCGC7U (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2014 21:59:20 -0500
Content-Disposition: inline
In-Reply-To: <5319342D.3020109@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2014 at 10:51:25AM +0800, Robert Yang wrote:
> 
> 
> On 03/07/2014 12:30 AM, Theodore Ts'o wrote:
> >I've merged these patches into the e2fsprogs next branch.  I had to
> >make a few minor merge fixups so these patches would integrate with
> >the also-recently introduced inline data changes.
> >
> >Please take a look at the next branch and make sure it looks sane to
> >you.
> >
> 
> Hi Ted,
> 
> Thanks, I've looked at the next branch, it looks well, the conflicts of
> debugfs.c had been fixed by you, and the related code had been moved into
> create_inode.c, I think that what shall I do now is:
> 
> 1) Waiting for Darrick's fix and do more testing
> 2) Add a testcase under the tests directory for the -d option, do you think
>    that we need such a testcase, please ?

Yes, please!  And please be sure to put a lot of weird files/devices/etc in the
directory. :)

--D

> 
> // Robert
> 
> >Thanks for your work and the long slog to get this merged!
> >
> >        	   	     	     	  - Ted
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
