From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Make the extent validity check more paranoid
Date: Thu, 23 Apr 2009 07:52:28 -0500
Message-ID: <49F0648C.10407@redhat.com>
References: <1240450174-25868-1-git-send-email-tytso@mit.edu> <49EFCCAE.6050602@redhat.com> <20090423041914.GA2723@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37237 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZDWMwc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Apr 2009 08:52:32 -0400
In-Reply-To: <20090423041914.GA2723@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Apr 22, 2009 at 09:04:30PM -0500, Eric Sandeen wrote:
>> Theodore Ts'o wrote:
>>> Instead of just checking that the extent block number is greater or
>>> equal than s_first_data_block, make sure it it is not pointing into
>>> the block group descriptors, since that is clearly wrong.  This helps
>>> prevent filesystem from getting very badly corrupted in case an extent
>>> block is corrupted.
>>>
>>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> Good idea.  Maybe we can get our friends with the corrupted fs to run
>> with these validation patches... I can get this into rawhide at least.
> 
> Yeah, unfortunately this patch requires some other patches that went
> in during the 2.6.30 merge window, so some extra back-porting would be
> needed for our friends running a 2.6.29.1 Fedora kernel.

Right, but rawhide has .30-etc, so a test on that might be helpful.

-Eric
