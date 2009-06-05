From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] [PATCH] ext4: Add inode to the orphan list during
	block allocation failure
Date: Fri, 5 Jun 2009 02:22:34 -0400
Message-ID: <20090605062234.GA27217@mit.edu>
References: <20090331044544.GB5979@skywalker> <1238491766-13182-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090405031116.GG7553@mit.edu> <20090406100509.GB31189@duck.suse.cz> <20090605043117.GB4046@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40278 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZFEGWl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Jun 2009 02:22:41 -0400
Content-Disposition: inline
In-Reply-To: <20090605043117.GB4046@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've tried applying these two patches to the ext4 patch queue.  On a
metadata-heavy workload (specifically, fsx), it causes a 5%
degradation in the wall clock run-time of the fsx run-time.

Maybe there's no way around that, but it's rather unfortunate....

	       	   	      	       	  - Ted
