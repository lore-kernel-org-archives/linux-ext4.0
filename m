From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Date: Fri, 17 Apr 2009 04:09:01 +1000
Message-ID: <200904170409.02222.nickpiggin@yahoo.com.au>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:43521 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755559AbZDPSJJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2009 14:09:09 -0400
In-Reply-To: <alpine.LFD.2.00.0904151333020.4042@localhost.localdomain>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 16 April 2009 06:35:23 Linus Torvalds wrote:
> 
> On Wed, 15 Apr 2009, Chris Mason wrote:
> > 
> > Here is another version of the data=guarded work for ext3.  The main
> > difference between this code and yesterday's is the guarded writepage
> > function now sends any newly allocated block through the old data=ordered code.
> 
> I'm inclined to apply the first two patches as infrastructure, since they 
> seem to make sense regardless of data=ordered. The ability to get a 
> callback when IO ends sounds like something that a number of cases might 
> find intriguing, and it's obviously how the actual IO has worked 
> internally anyway.
> 
> Comments?

I think also fscache really should be using proper read completed notifications
rather than hijacking the page lock waitqueue for this.
