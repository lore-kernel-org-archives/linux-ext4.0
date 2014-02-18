From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/6] ext4: Update inode i_size after the preallocation
Date: Tue, 18 Feb 2014 09:13:17 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1402180911110.2216@localhost.localdomain>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com> <1392649703-10772-2-git-send-email-lczerner@redhat.com> <9288BED9-A44E-4ACC-9A3D-BC086AB4E121@dilger.ca> <20140217232100.GA26580@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbaBRINY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Feb 2014 03:13:24 -0500
In-Reply-To: <20140217232100.GA26580@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 17 Feb 2014, Theodore Ts'o wrote:

> Date: Mon, 17 Feb 2014 18:21:00 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Andreas Dilger <adilger@dilger.ca>
> Cc: Lukas Czerner <lczerner@redhat.com>,
>     Ext4 Developers List <linux-ext4@vger.kernel.org>,
>     linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
> Subject: Re: [PATCH 1/6] ext4: Update inode i_size after the preallocation
> 
> On Mon, Feb 17, 2014 at 04:12:14PM -0700, Andreas Dilger wrote:
> > 
> > I don't necessarily agree about this.  Calling fallocate() will not
> > change the user-visible data at all, so there is no reason to e.g.
> > do a new backup of the file or reprocess the contents, or any other
> > reason that an application cares about a changed mtime.
> 
> Well, if i_size has changed, then the visible results of reading from
> the file will change, so in that case I'd argue m_time should change.
> If the results of reading file doesn't change then we can keep m_time
> unchanged --- but since the inode is changing, c_time *should* always
> change any time we've made any changes to the extent tree.
> 
> 	      	  	    	     - Ted

So I guess the consensus is to update m_time only when the inode size
changes in fallocate case. I'll change that in the code.

Thanks!
-Lukas
