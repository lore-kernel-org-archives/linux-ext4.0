From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Remove VLAIS usage from JBD2 code
Date: Thu, 8 Nov 2012 10:53:07 -0500
Message-ID: <20121108155307.GB766@thunk.org>
References: <1351622404-18214-1-git-send-email-behanw@converseincode.com>
 <1351622404-18214-2-git-send-email-behanw@converseincode.com>
 <20121030191307.GC19576@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Behan Webster <behanw@converseincode.com>,
	linux-ext4@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60082 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146Ab2KHWLC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:11:02 -0500
Content-Disposition: inline
In-Reply-To: <20121030191307.GC19576@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey Darrick,

I was looking at this code a bit more closely while applying the
revised version of this patch --- and this in particular raised a red
flag for me:

     *(u32 *)desc.ctx = crc;
     	   ...
     return *(u32 *)desc.ctx;

Does this raise any byte swapping issues?  Looking at how the crc32
code in crypto/ works, I'm almost certain this is broken on big-endian
systems, and we need to add le32_to_cup() and cpu_to_le32() calls here.

Am I missing something?

	     	     	    		  - Ted
