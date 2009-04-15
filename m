From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Date: Wed, 15 Apr 2009 13:35:23 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878AbZDOUiU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2009 16:38:20 -0400
In-Reply-To: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Wed, 15 Apr 2009, Chris Mason wrote:
> 
> Here is another version of the data=guarded work for ext3.  The main
> difference between this code and yesterday's is the guarded writepage
> function now sends any newly allocated block through the old data=ordered code.

I'm inclined to apply the first two patches as infrastructure, since they 
seem to make sense regardless of data=ordered. The ability to get a 
callback when IO ends sounds like something that a number of cases might 
find intriguing, and it's obviously how the actual IO has worked 
internally anyway.

Comments?

			Linus
