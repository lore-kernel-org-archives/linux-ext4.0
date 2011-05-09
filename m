From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] Null Pointer when make_indexed_dir returns -ENOSPC
Date: Sun, 8 May 2011 20:38:52 -0400
Message-ID: <20110509003852.GB4138@thunk.org>
References: <4DC5DBB3.9030207@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56885 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab1EIAi4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2011 20:38:56 -0400
Content-Disposition: inline
In-Reply-To: <4DC5DBB3.9030207@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 07, 2011 at 04:54:27PM -0700, Allison Henderson wrote:
> Fix for a null pointer bug found while running punch hole tests
> 
> Signed-off-by: Allison Henderson <achender@us.ibm.com>

Thanks, I've added this to the ext4 tree.

	     	   	       	    	  - Ted
