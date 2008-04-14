From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Add regression test for clearing an xattr block
Date: Mon, 14 Apr 2008 08:46:05 -0500
Message-ID: <4803601D.9090802@redhat.com>
References: <47FF8A50.2030800@redhat.com> <20080414032755.GF8058@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYDNNqI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Apr 2008 09:46:08 -0400
In-Reply-To: <20080414032755.GF8058@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Apr 11, 2008  10:57 -0500, Eric Sandeen wrote:
>> I got burned by the bug at:
>> http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=commitdiff;h=86bc90f4f11df090f86dc764a4ea2d6dd5c13ffe
>>
>> so figured maybe a testcase was in order... 
>> 20/20 hindsight I guess!
> 
> Is the "ea_checks" patch and respective test in the upstream e2fsprogs?
> We had added additional checks to e2fsck for xattr blocks/large inodes.

Ah, it is in git, I had missed that.  Looks like it does cover the case
I sent and much more, so... never mind.

Thanks,
-Eric

