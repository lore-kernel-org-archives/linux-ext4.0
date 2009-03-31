From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH next] ext4: fix printk format warning in inode.c
Date: Tue, 31 Mar 2009 08:37:10 -0400
Message-ID: <20090331123710.GD13356@mit.edu>
References: <20090331115451.GA3475@orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47915 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbZCaMhO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 08:37:14 -0400
Content-Disposition: inline
In-Reply-To: <20090331115451.GA3475@orion>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 31, 2009 at 03:54:51PM +0400, Alexander Beregalov wrote:
> fs/ext4/inode.c:385: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'long int'
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Thanks, Thiemo has already sent a patch to fix this (as well as
another buglet).

	       	   	   	  	   - Ted
