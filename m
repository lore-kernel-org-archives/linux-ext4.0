From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: lsetxattr/lgetxattr on ext4.
Date: Thu, 01 Apr 2010 17:01:11 -0500
Message-ID: <4BB517A7.2060305@redhat.com>
References: <4BB3E375.5010604@linux.vnet.ibm.com> <1270158896.2342.6.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: jvrao <jvrao@linux.vnet.ibm.com>, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758196Ab0DAWBQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Apr 2010 18:01:16 -0400
In-Reply-To: <1270158896.2342.6.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming Cao wrote:
> On Wed, 2010-03-31 at 17:06 -0700, jvrao wrote:
>> lsetxattr()/lgetxsttr() functions are not working on a ext4 symlink. 
>> But works fine on a regular file.
>>
>> I tried the following program.. Not sure if I am missing something.
>> Any help will be appreciated.
>>
>>
> 
> 
> I tried your test program on ext2/3/btrfs, it seems all broken. 
> Not sure how this not being visible? Thought xattrs are heavily used by
> default on some distros.

xfs as well FWIW.

however, I'm not sure setting user xattrs directly on symlinks is
a common operation...

-Eric

