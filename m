From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: FLEX_BG Kernel support v2.
Date: Fri, 21 Sep 2007 15:59:53 -0500
Message-ID: <46F430C9.8030101@redhat.com>
References: <20070921140649.4352.30055.stgit@toolssf2>	<1190406567.13955.1.camel@dyn9047017100.beaverton.ibm.com> <20070921154935.0b16c5ca@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ext4 <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765842AbXIUVAD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2007 17:00:03 -0400
In-Reply-To: <20070921154935.0b16c5ca@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jose R. Santos wrote:
> On Fri, 21 Sep 2007 13:29:27 -0700
> Badari Pulavarty <pbadari@gmail.com> wrote:
> 
>> On Fri, 2007-09-21 at 09:06 -0500, Jose R. Santos wrote:
>>> From: Jose R. Santos <jrs@us.ibm.com>
>>>
>>> ext4: FLEX_BG Kernel support v2.
>>>
>>> @@ -702,13 +702,15 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
>>>  #define EXT4_FEATURE_INCOMPAT_META_BG		0x0010
>>>  #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
>>>  #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
>>> +#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
>> Any reason why 0x100 is skipped ?
>>
>> Thanks,
>> Badari
>>
> 
> Because 0x0100 is reserved for EXT4_FEATURE_INCOMPAT_MMP in e2fsprogs.

and we know that how?  :)  I'd at least put a comment into the kernel
code so it doesn't get taken, later.

-Eric
