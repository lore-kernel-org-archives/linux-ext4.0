From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH 6/6] ext4: tighten restrictions on inode flags
Date: Wed, 11 Jun 2008 12:49:56 +0100
Message-ID: <e9e943910806110449sbf30bf6xd98840fcd343519d@mail.gmail.com>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-6-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-7-git-send-email-duaneg@dghda.com>
	 <20080611113104.GC9008@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, "Andreas Dilger" <adilger@sun.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:25083 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYFKLt7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 07:49:59 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3072175wfd.4
        for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 04:49:56 -0700 (PDT)
In-Reply-To: <20080611113104.GC9008@skywalker>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/6/11 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
>> +/* Mask out flags that are inappropriate for the given type of inode. */
>> +static inline __le32 ext4_mask_flags(__le16 mode, __le32 flags)
>> +{
>> +     if (S_ISDIR(mode))
>> +             return flags;
>> +     else if (S_ISREG(mode))
>> +             return flags & ~EXT4_REG_FLMASK;
>> +     else
>> +             return flags & ~EXT4_OTHER_FLMASK;
>> +}
>> +
>
> why are the arguments __le32 ? They should be in host order.
>
> static inline  __u32 ext4_mask_flags(umode_t mode, __u32 flags)

Whoops, I was matching the fields in ex4_inode, but I should have been
looking at ext4_inode_info. Shouldn't sparse have complained about
that?

Thanks,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
