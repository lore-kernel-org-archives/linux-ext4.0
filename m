From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Compile error in pu branch of e2fsprogs.
Date: Thu, 20 Aug 2009 11:41:09 -0500
Message-ID: <4A8D7CA5.5010208@redhat.com>
References: <8693.1250784298@alphaville.usa.hp.com>  <4A8D763E.8040603@redhat.com> <9226.1250785933@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbZHTQlM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Aug 2009 12:41:12 -0400
In-Reply-To: <9226.1250785933@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Dokos wrote:
>> Nick Dokos wrote:
>     ...
>>> I moved it from there to lib/ext2fs/fiemap.h and that fixes it.
>> ...
>>
>> Would it be better to move the ioctl definition into one place, maybe
>> our local copy of fiemap.h?
>>
> 
> Is "our local copy of fiemap.h" lib/ext2fs/fiemap.h? If so, yes, that
> works (and I think it's better.)

yep that's what I meant.

-Eric

> Thanks,
> Nick

