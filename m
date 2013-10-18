From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: quota: fix disabling quota, add quota tests
Date: Fri, 18 Oct 2013 10:23:06 -0500
Message-ID: <5261525A.9060301@redhat.com>
References: <1358899248-22575-1-git-send-email-adilger@whamcloud.com> <20131014135528.GA4685@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@whamcloud.com>, linux-ext4@vger.kernel.org,
	Niu Yawei <niu@whamcloud.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab3JRPXJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Oct 2013 11:23:09 -0400
In-Reply-To: <20131014135528.GA4685@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/14/13 8:55 AM, Theodore Ts'o wrote:
> On Tue, Jan 22, 2013 at 05:00:48PM -0700, Andreas Dilger wrote:
>> From: Niu Yawei <niu@whamcloud.com>
>>
>> Update all superblock copies when disabling the quota feature.
>>
>> Added basic tests for the quota feature.
>>
>> Signed-off-by: Niu Yawei <niu@whamcloud.com>
>> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> 
> Applied, thanks.

This actually breaks things (or seems to, I haven't chased it all
down; quota stuff is busted, anyway):

# git clone git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
# cd e2fsprogs
# git checkout next
# ./configure
# make
...
make[2]: Entering directory `/tmp/e2fsprogs/e2fsck'
...
	CC prof_err.c
	CC logfile.c
	CC sigcatcher.c
make[2]: *** No rule to make target `../lib/libquota.a', needed by `e2fsck'.  Stop.
make[2]: Leaving directory `/tmp/e2fsprogs/e2fsck'
make[1]: *** [all-progs-recursive] Error 1
make[1]: Leaving directory `/tmp/e2fsprogs'
make: *** [all] Error 2


"make clean" doesn't remove lib/libquota.a (nor does git clean -f -d thanks
to .gitignore (?)) so old builds pretend to be ok.

Using QUOTA_CMT on lib requirements might work but it's hacky, it'd mean
the LIBQUOTA stuff has to be last on the line, and if we ever have more than
1 configurable lib, then what?

-Eric
