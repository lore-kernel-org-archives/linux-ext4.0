From: Andi Kleen <andi@firstfloor.org>
Subject: Re: No space left on device after many files creation
Date: Thu, 15 Apr 2010 17:14:52 +0200
Message-ID: <87ljco928j.fsf@basil.nowhere.org>
References: <4BC38EB9.8080501@gmail.com> <4BC39098.4030704@redhat.com>
	<4BC39762.9080406@gmail.com> <4BC39805.7090807@redhat.com>
	<20100412224429.GN1849@thunk.org> <4BC410AB.1030607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: cy6erGn0m <cy6ergn0m@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41632 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab0DOPOx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Apr 2010 11:14:53 -0400
In-Reply-To: <4BC410AB.1030607@gmail.com> (cy6ergn0m@gmail.com's message of "Tue, 13 Apr 2010 10:35:23 +0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

cy6erGn0m <cy6ergn0m@gmail.com> writes:
> I use filysystem as Set data structure to make fast checks from scripts.
> Of course I can make long long file and test it with grep but it's will
> have linear performance degradation (List), at the same time file system
> has efficient tree binary structures (smth. like TreeSet). So, using
> filesystem is the simplest way to do this efficient. Also I always have
> timestamps for every entry. In this usecase all files are always empty.

If the files are always empty you could just create hard links: 
ln file number instead of touch.
Then you'll only need a single inode for your complete set
and also avoid a lot of seeking.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
