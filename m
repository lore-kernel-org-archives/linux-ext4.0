From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH -v2] ext4: add max_dir_size_kb mount option
Date: Sat, 11 Aug 2012 15:10:29 -0600
Message-ID: <DEABF70E-1574-4940-8C55-AC4901CCD442@whamcloud.com>
References: <20120810215811.GA1137@thunk.org> <1344649235-9289-1-git-send-email-tytso@mit.edu> <C9EF93CD-99DF-483E-BE66-713616B12D8C@whamcloud.com> <20120811192648.GA9363@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45596 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2HKVKf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Aug 2012 17:10:35 -0400
Received: by pbbrr13 with SMTP id rr13so4847671pbb.19
        for <linux-ext4@vger.kernel.org>; Sat, 11 Aug 2012 14:10:35 -0700 (PDT)
In-Reply-To: <20120811192648.GA9363@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-08-11, at 1:26 PM, Theodore Ts'o wrote:
> On Fri, Aug 10, 2012 at 09:22:39PM -0600, Andreas Dilger wrote:
>> 
>> In our patch, it returns EFBIG, since it isn't really a case of
>> being out of space for blocks or inodes.
> 
> I agree, EFBIG seems to be a better errno.
> 
> How did you configure the directory size limit, BTW?  Did you use a
> mount option, if so, what did you name it?

It was configured via /sys/fs/ext4/{dev}/max_dir_size, but the units
were bytes instead of kbytes.  Not many sites use this value, so if
it needs to be renamed .../max_dir_size_kb it wouldn't be fatal - we
could modify our patch to allow both, and print a deprecation message
if the old one is used.  It will likely still be a few years before
distros are running 3.6 (or whatever kernel this patch is included in).
At least we wouldn't have to carry that patch in perpetuity.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




