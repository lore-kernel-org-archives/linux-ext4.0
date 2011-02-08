From: bryan.coleman@dart.biz
Subject: Re: ext4 problems with external RAID array via SAS connection
Date: Tue, 8 Feb 2011 08:18:59 -0500
Message-ID: <OF1BE984CE.39437668-ON85257831.00491D12-85257831.0049261D@dart.biz>
References: <OFFAEBAC93.6731CA9F-ON85257830.0067BABF-85257830.0067C1CB@dart.biz> <20110207225436.GG3457@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
To: linux-ext4@vger.kernel.org, linux-ext4-owner@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mas-ns06.dartcontainer.com ([173.241.223.201]:3953 "EHLO
	MAS-NS06.dartcontainer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811Ab1BHNTC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Feb 2011 08:19:02 -0500
In-Reply-To: <20110207225436.GG3457@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When I ran fsck after the first bout of failure, it did report a lot of 
errors.  I do not have a copy of that fsck transcript; however, I have not 
yet run fsck since my second attempt.  Is there a method of capturing the 
transcript that is preferred?

Bryan



From:   Ted Ts'o <tytso@mit.edu>
To:     bryan.coleman@dart.biz
Cc:     linux-ext4@vger.kernel.org
Date:   02/07/2011 05:55 PM
Subject:        Re: ext4 problems with external RAID array via SAS 
connection
Sent by:        linux-ext4-owner@vger.kernel.org



On Mon, Feb 07, 2011 at 01:53:18PM -0500, bryan.coleman@dart.biz wrote:
> I am experiencing problems with an ext4 file system.
> 
> At first, the drive seemed to work fine.  I was primarily copying things 

> to the drive migrating data from another server.  After many GBs of 
data, 
> that seemingly successfully were done being transferred, I started 
seeing 
> ext4 errors in /var/log/messages.  I then unmounted the drive and ran 
fsck 
> on it (which took multiple hours to run).  I then ls'ed around and one 
of 
> the areas caused the system to again throw ext4 errors.

Did fsck report any errors?  Do you have a copy of your fsck
transcript?

The errors you've reported do make me suspicious that there's
something unstable with your hardware...

  - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


