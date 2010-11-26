From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext3: Add batched discard support for ext3
Date: Fri, 26 Nov 2010 09:01:26 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011260853460.2936@dhcp-lab-213.englab.brq.redhat.com>
References: <1290603991-6151-1-git-send-email-jack@suse.cz> <1290603991-6151-2-git-send-email-jack@suse.cz> <alpine.LFD.2.00.1011251512020.2871@dhcp-lab-213.englab.brq.redhat.com> <AEFF42B2-01B0-4100-BB39-19D0C0EF99A2@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab0KZIBd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Nov 2010 03:01:33 -0500
In-Reply-To: <AEFF42B2-01B0-4100-BB39-19D0C0EF99A2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 25 Nov 2010, Andreas Dilger wrote:

> On 2010-11-25, at 07:27, Lukas Czerner wrote:
> >> Walk through allocation groups and trim all free extents. It can be
> >> invoked through FITRIM ioctl on the file system. The main idea is to
> >> provide a way to trim the whole file system if needed, since some SSD's
> >> may suffer from performance loss after the whole device was filled (it
> >> does not mean that fs is full!).
> 
> One question I have is why a major change like this is being done in ext3 instead of only in ext4?  There are a lot of ext4 features that _could_ be included in ext3 (basically all of them), but the request from the rest of the kernel developers was to leave ext3 with minimal changes (for continued stability), and put all of the major changes into ext4.

You're right that ext3 should be "closed" for major (intrusive) changes,
however this is not a major change at all. It interacts with ext3 code
just very little and it is very well separated. Basically, it is dead
code until FITRIM ioctl is done.

Given that there are still a lot of people using ext3, and SSD's are
here right now, we should consider providing that feature to ext3 as
well. When you comprehend this features intrusiveness (well separated)
and it's usefulness into consideration, I think that the ratio is well
in favour of including this into ext3.

> 
> With the current ext4 code's performance and feature advantages, and widespread use in newer distros, I don't think there is a good reason to make major modifications to ext3.  It should remain as the stable legacy filesystem for some number of releases, and then possibly we should just remove one or both of ext2 and ext3 and use the ext4 code for both.
> 
> Given that Google is running ext4 in no-journal mode (i.e. ext2-like) on many thousands of machines, and getting _much_ better performance than the old ext2 code, it doesn't make sense to continue investing so much maintenance effort into ext2 and ext3.
> 
> Cheers, Andreas

Thanks!

-Lukas
