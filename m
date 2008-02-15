From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFC/PATCH] ext4: Request for journal write access early.
Date: Fri, 15 Feb 2008 15:30:01 -0500
Message-ID: <20080215203001.GA7664@mit.edu>
References: <1202985052-15694-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1202985052-15694-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55818 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757424AbYBPAHx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Feb 2008 19:07:53 -0500
Content-Disposition: inline
In-Reply-To: <1202985052-15694-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 14, 2008 at 04:00:52PM +0530, Aneesh Kumar K.V wrote:
> In ext4_ext_convert_to_initialized before we need to request for journal
> write access before we even modify the extent length.

This isn't a grammatically correct sentence, and it doesn't explain
what is going on.  I rewrote the patch description as follows:

   ext4: Get journal write access before modifying the extent tree

   When the user was writing into an unitialized extent,
   ext4_ext_convert_to_initialize() was not requesting journal write access
   before it started to modify the extent tree.   Fix this oversight.

   	     	     	       	   	  	  - Ted
