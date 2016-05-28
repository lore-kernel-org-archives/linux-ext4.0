From: Bruce Dubbs <bruce.dubbs@gmail.com>
Subject: Re: e2fsprogs-1.43 make check failures
Date: Sat, 28 May 2016 18:54:12 -0500
Message-ID: <574A2FA4.3050106@gmail.com>
References: <511107d2-9b17-e5ab-c900-3ccfadb724f9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35659 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbcE1XyW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 May 2016 19:54:22 -0400
Received: by mail-wm0-f51.google.com with SMTP id a136so38128553wme.0
        for <linux-ext4@vger.kernel.org>; Sat, 28 May 2016 16:54:21 -0700 (PDT)
In-Reply-To: <511107d2-9b17-e5ab-c900-3ccfadb724f9@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Xose Vazquez Perez wrote:
> Bruce Dubbs wrote:
>
>> When building e2fsprogs we normally ask users to run 'make check'.  For
>> e2fsprogs-1.42.13 we had '153 tests succeeded, 0 tests failed', but for
>> version 1.43, we have '62 tests succeeded, 265 tests failed'.
>
> Documented in: http://e2fsprogs.sourceforge.net/e2fsprogs-release.html#1.43
>
> ----
> E2fsprogs 1.43 (May 17, 2016)
>
> KNOWN BUG: "make check" will have many spurious failures in the tests directory.
> The fix can be found at: https://git.kernel.org/cgit/fs/ext2/e2fsprogs.git/commit/?id=e7d848266a224cc1ed3c74c6746b5c779a5f55ce
> ----

Missed that entry.  Thank you.

   -- Bruce

