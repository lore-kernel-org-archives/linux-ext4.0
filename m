From: Roman Borisov <ext-roman.borisov@nokia.com>
Subject: Re: ext3: ext4: Using uninitialized value
Date: Thu, 14 Oct 2010 14:10:01 +0400
Message-ID: <4CB6D6F9.7080109@nokia.com>
References: <4CB5C4D6.3020201@nokia.com> <4CB5DAC3.3040605@redhat.com> <0E811115-22DB-4D20-AE03-428037E1429C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: ext Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx04.teleca.com ([212.92.145.6]:37358 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab0JNKGZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Oct 2010 06:06:25 -0400
In-Reply-To: <0E811115-22DB-4D20-AE03-428037E1429C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/13/2010 10:56 PM, ext Andreas Dilger wrote:
>> that was introduced with:
>> >
>> >  commit acfa1823d33859b0db77701726c9ca5ccc6e6f25
>> >  Author: Andreas Dilger<adilger@clusterfs.com>
>> >  Date:   Thu Jun 23 00:09:45 2005 -0700
>> >
>> >     [PATCH] Support for dx directories in ext3_get_parent (NFSD)
>> >
>> >  so maybe Andreas knows offhand;)   but I think:
> Your analysis is correct.  I agree it's a bit convoluted, but it avoids replicating a bunch of code.
>

Thanks a lot! it make sence.

But I just wondering why hash = hinfo->hash is located in separate scope 
where it looks like unitialized.
The same situation in namei.c/dx_probe():
	if (entry)
		ext3fs_dirhash(entry->name, entry->len, hinfo);
	hash = hinfo->hash;
I believe that the implementation doesn't allow to use hash value when 
!entry but why it wasn't designed like:
	if (entry)
	{
		ext3fs_dirhash(entry->name, entry->len, hinfo);
		hash = hinfo->hash;
	}
for example?

Roman
