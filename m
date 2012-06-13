From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Avoid unnecessary calls to ext4_mb_load_buddy
 while reading mb_groups proc file
Date: Wed, 13 Jun 2012 19:52:41 -0400
Message-ID: <20120613235241.GA22646@thunk.org>
References: <AANLkTimPwhK1NggZAkCzB8Q29Ogf5SswH1kBbH8WAjX7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49694 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab2FNApd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2012 20:45:33 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimPwhK1NggZAkCzB8Q29Ogf5SswH1kBbH8WAjX7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 14, 2011 at 02:05:15PM -0800, Aditya Kali wrote:
> Currently ext4_mb_load_buddy is called for every group, irrespective
> of whether the group info is already in memory, while reading
> /proc/fs/ext4/<partition>/mb_groups proc file. For the purpose of
> mb_groups proc file, it is unnecessary to load the file group info
> from disk if it was loaded in past. These calls to ext4_mb_load_buddy
> make reading the mb_groups proc file expensive.
> Also, the locks around ext4_get_group_info are not required.
> This patch modifies the code to call ext4_mb_load_buddy only if the
> group info had never been loaded into memory in past. It also removes
> the mb group locking around ext4_get_group_info call.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

I realized that this had dropped through the cracks.  Sorry!

I've queued this for the next merge window.

     	    	     	      	    - Ted
