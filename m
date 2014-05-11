From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 9/9] quota: remove warning message that we have fixed the
 nasty quota bugs
Date: Sun, 11 May 2014 00:42:53 -0400
Message-ID: <20140511044253.GB7181@thunk.org>
References: <1399782773-20029-1-git-send-email-tytso@mit.edu>
 <1399782773-20029-10-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adityakali@google.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60838 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaEKEmy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 00:42:54 -0400
Content-Disposition: inline
In-Reply-To: <1399782773-20029-10-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've fixed the summary line of this commit to read:

quota: remove mke2fs's and tune2fs's warning messages regarding quota

       	      	       	   	     	     	      - Ted
