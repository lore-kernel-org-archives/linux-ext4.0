From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: ext4_avoid_panic_in_case_of_corrupted_bitmap.patch
Date: Sun, 10 Feb 2008 19:21:32 -0500
Message-ID: <20080211002132.GH21729@mit.edu>
References: <cc723f590802090735w67cc7b0bjf2efcceae1e85f06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Aneesh Kumar <aneesh.kumar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38315 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbYBKAVg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2008 19:21:36 -0500
Content-Disposition: inline
In-Reply-To: <cc723f590802090735w67cc7b0bjf2efcceae1e85f06@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 09, 2008 at 07:35:03AM -0800, Aneesh Kumar wrote:
> I guess we pushed an old version of this patch. I had set in -ver2.
> with better comments.
> 
> http://article.gmane.org/gmane.comp.file-systems.ext4/4956
> 

Sorry, I saw your note, but I missed it when I was doing prepping the
branch to for the git pull request.

We can prepare a comments-only patch which we can merge either before
-rc2 if Linus is willing, or worst case keep it in the ext4 patch
queue until the next merge window.

Again, sorry for missing the updated patch!

						- Ted
