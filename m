From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/5] e2fsck: print a notice when we've started
 suppressing a problem code
Date: Sun, 18 Mar 2012 20:25:04 -0400
Message-ID: <20120319002504.GC31682@thunk.org>
References: <1332100368-2683-1-git-send-email-tytso@mit.edu>
 <1332100368-2683-4-git-send-email-tytso@mit.edu>
 <1D4F4E78-7F63-406D-9D35-09F716E04C43@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59538 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab2CSAZE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2012 20:25:04 -0400
Content-Disposition: inline
In-Reply-To: <1D4F4E78-7F63-406D-9D35-09F716E04C43@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 18, 2012 at 05:17:20PM -0600, Andreas Dilger wrote:
> 
> Did a patch ever land to allow an interactive e2fsck run to set
> a sticky answer (y/n) for a particular problem?  I know it has
> been proposed several times.

It's been proposed but I don't think anyone has ever coded it.

     	  	       	       	     - Ted
