From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v3] vfs: add releasepages hooks to block devices which can be used by file systems
Date: Sat,  3 Jan 2009 10:09:15 -0500
Message-ID: <1230995358-24013-1-git-send-email-tytso@mit.edu>
References: <20081226050138.GU28946@ZenIV.linux.org.uk>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37195 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758750AbZACPJX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Jan 2009 10:09:23 -0500
In-Reply-To: <20081226050138.GU28946@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Al,

Thanks for your comments; they were quite useful.  I've reworked
Okajima-san's patches to address your concerns.  What do you think?

	      	      	 	      		 - Ted


