From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: panic on boot at ext4_mb_poll_new_transaction
Date: Thu, 16 Oct 2008 09:36:20 -0500
Message-ID: <48F75164.20500@redhat.com>
References: <20081016070735.GA28486@csclub.uwaterloo.ca> <20081016143035.GA10825@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Michael Spang <mspang@csclub.uwaterloo.ca>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58497 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbYJPOgr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Oct 2008 10:36:47 -0400
In-Reply-To: <20081016143035.GA10825@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Oct 16, 2008 at 03:07:35AM -0400, Michael Spang wrote:
>> I switched my laptop over to ext4 yesterday. Then I used tune2fs to
>> enable the features from mke2fs.conf's defaults for ext4 (some failed).
>>
>> It worked fine initially but today I am getting a panic when the machine
>> boots: http://csclub.uwaterloo.ca/~mspang/panic.jpg .
>>
>> Let me know if there's anything I can do to rescue it. Otherwise I'll
>> just reinstall.
> 
> What version of the kernel are you using, and what patches (if any)
> have you installed?  Are you using a distribution kernel?

Looks similar to https://bugzilla.redhat.com/show_bug.cgi?id=467161,
which I was just alerted to, and I'm looking into it.

-Eric

> 							- Ted
