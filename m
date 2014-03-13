From: jon ernst <jonernst07@gmail.com>
Subject: Re: [PATCH v3 10/30] libext2fs: define new dirent_swab interfaces for inline data
Date: Thu, 13 Mar 2014 12:32:34 -0400
Message-ID: <392DED5B-9D1A-4989-A891-D844705DCA2D@gmail.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com> <1386323897-2354-11-git-send-email-wenqing.lz@taobao.com> <20140303154950.GB9620@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:60295 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaCMQcj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2014 12:32:39 -0400
Received: by mail-qc0-f176.google.com with SMTP id m20so1416909qcx.21
        for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2014 09:32:39 -0700 (PDT)
In-Reply-To: <20140303154950.GB9620@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags)
{
+       return ext2fs_dirent_swab_in(fs, buf, fs->blocksize, flags);
+}

I guess it misses "2" for function name.
Should be:

errcode_t ext2fs_dirent_swab_in(ext2_filsys fs, char *buf, int flags)
{
+       return ext2fs_dirent_swab_in2(fs, buf, fs->blocksize, flags);
+}

Thanks,
Jon

> On Mon, Mar 3, 2014 at 10:49 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Fri, Dec 06, 2013 at 05:57:57PM +0800, Zheng Liu wrote:
>> From: Zheng Liu <wenqing.lz@taobao.com>
>> 
>> Later we will use ext2fs_dirent_swab_in/out to handle big-endian problem
>> for inline data.  Now interfaces assume that it handles a block, but it
>> is not true after adding inline data.  So this commit defines a new
>> interface for inline data.
>> 
>> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> Thanks, applied.
> 
>                                        - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

