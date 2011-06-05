From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Oops fs/ext4/inode.c:2188
Date: Sun, 5 Jun 2011 18:47:32 -0400
Message-ID: <20110605224731.GD1001@thunk.org>
References: <4DEBD1B4.3000307@odi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41111 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366Ab1FEWre (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jun 2011 18:47:34 -0400
Content-Disposition: inline
In-Reply-To: <4DEBD1B4.3000307@odi.ch>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Were there any messages in the syslog before this relating to ext4 or
jbd2?

> Jun  5 20:34:12 box kernel: JBD2: Detected IO errors while flushing file
> data on sdc1-8
> Jun  5 20:34:12 box kernel: Aborting journal on device sdc1-8.
> Jun  5 20:34:12 box kernel: JBD2: I/O error detected when updating
> journal superblock for sdc1-8.

For example, anything like these messages *before* the oops messages?

    	     	      	   	 	  	       - Ted
