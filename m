From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: File limit inside a single directory
Date: Fri, 13 Feb 2015 11:28:34 -0600
Message-ID: <54DE3442.90707@redhat.com>
References: <trinity-2286fbea-64f2-4a0a-b0a7-2d7fc4f6f180-1423768604697@3capp-webde-bs55> <54DD0091.1050104@redhat.com>, <B52A17D2-8AD8-4427-B1D3-2FE6DE21585B@dilger.ca> <trinity-232bc979-0b76-4776-a65c-b6697428d0a4-1423846162245@3capp-webde-bs16>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: suntrop@web.de, Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbbBMR2i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Feb 2015 12:28:38 -0500
In-Reply-To: <trinity-232bc979-0b76-4776-a65c-b6697428d0a4-1423846162245@3capp-webde-bs16>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/13/15 10:49 AM, suntrop@web.de wrote:
> Thanks guys. I was afraid of having a couple 100K (at most). The
> server support team told me not to have more than 10 to 20K. There
> seems to be a misconception (for me and people from the CMS) about
> the 32K subdirectory limit, but this ins't for files/folders within a
> single directory but rather nested directories like /1/2/3.../32000

You've confused things a bit here, FWIW.

The 32k (well, 32000 because, sure) limit on ext3 is max link count;
each subdirectory increases the link count on its parent, but only
its parent.  It's not about deep nesting, or about files in a dir.
It's only about subdirs in a parent dir.

# mkdir dir
# stat dir | grep Links
Device: fd06h/64774d    Inode: 2490391     Links: 2	// . and .. entries
# mkdir dir/subdir1 dir/subdir2 dir/subdir3
# stat dir | grep Links
Device: fd06h/64774d    Inode: 2490391     Links: 5
# mkdir dir/subdir1/subsubdir1 dir/subdir1/subsubdir2 dir/subdir1/subsubdir3
# stat dir | grep Links
Device: fd06h/64774d    Inode: 2490391     Links: 5

ext4 bumped that max to 64000, and just stops counting if that number
gets exceeded...

-Eric
