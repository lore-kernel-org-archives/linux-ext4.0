From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/2] ext3: Add batched discard support for ext3
Date: Fri, 26 Nov 2010 03:33:55 -0700
Message-ID: <A35088BD-308A-474C-98DA-BB9819783BEB@dilger.ca>
References: <1290603991-6151-1-git-send-email-jack@suse.cz> <1290603991-6151-2-git-send-email-jack@suse.cz> <alpine.LFD.2.00.1011251512020.2871@dhcp-lab-213.englab.brq.redhat.com> <AEFF42B2-01B0-4100-BB39-19D0C0EF99A2@dilger.ca> <alpine.LFD.2.00.1011260853460.2936@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:59493 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab0KZKd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Nov 2010 05:33:57 -0500
In-Reply-To: <alpine.LFD.2.00.1011260853460.2936@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-26, at 01:01, Lukas Czerner wrote:
> On Thu, 25 Nov 2010, Andreas Dilger wrote:
>> One question I have is why a change like this is being done in ext3 instead of only in ext4?  There are a lot of ext4 features that _could_ be included in ext3 (basically all of them), but the request from the rest of the kernel developers was to leave ext3 with minimal changes (for continued stability), and put all of the major changes into ext4.
> 
> You're right that ext3 should be "closed" for major (intrusive) changes,
> however this is not a major change at all. It interacts with ext3 code
> just very little and it is very well separated. Basically, it is dead
> code until FITRIM ioctl is done.

I don't want to pick on this patch, per se, but if someone is installing a new filesystem on an SSD with a new kernel, they could just as easily use ext4 for that instead of ext3, and they likely should use ext4 because of performance.  Either they are using ext3 because they don't want any changes (in which case they also don't want this one), or if it is a new filesystem on a new device they can as easily use ext4.

Since this code is only going to end up in new kernels, this isn't about what users are using for legacy systems where only ext3 is available.

Cheers, Andreas





