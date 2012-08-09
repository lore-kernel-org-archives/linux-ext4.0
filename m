From: "George Spelvin" <linux@horizon.com>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: 9 Aug 2012 01:00:58 -0400
Message-ID: <20120809050058.23273.qmail@science.horizon.com>
References: <20120808234239.4443.qmail@science.horizon.com>
To: linux-ext4@vger.kernel.org, linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:13951 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751810Ab2HIFBA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Aug 2012 01:01:00 -0400
In-Reply-To: <20120808234239.4443.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think indeed it was a RAM issue.  After some cache-flushing, e2fsck
on the file system with the checksum errors reported no errors, even
though there wasn't even a reboot in between.

(Then I discovered the "e2fsck -F" flag, which would have been
a lot simpler than what I did instead.  Oh, well.)

Looking in the BIOS, I found some suspicious timing parameters that
might be responsible, and reset them to stock.  I'll know for sure if
the problem stays away for a month, but in the mean time, thank you
everyone for your help and patience, and consider the matter
resolved unless I find more problems.

Sorry for the false alarm.
