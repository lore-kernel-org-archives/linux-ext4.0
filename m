From: jvrao <jvrao@linux.vnet.ibm.com>
Subject: Re: lsetxattr/lgetxattr on ext4.
Date: Thu, 01 Apr 2010 15:34:33 -0700
Message-ID: <4BB51F79.5040008@linux.vnet.ibm.com>
References: <4BB3E375.5010604@linux.vnet.ibm.com> <1270158896.2342.6.camel@mingming-laptop> <4BB517A7.2060305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:55706 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0DAWei (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Apr 2010 18:34:38 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o31MTjhd014674
	for <linux-ext4@vger.kernel.org>; Thu, 1 Apr 2010 16:29:45 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o31MYYAA132222
	for <linux-ext4@vger.kernel.org>; Thu, 1 Apr 2010 16:34:34 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o31Mb9qq001938
	for <linux-ext4@vger.kernel.org>; Thu, 1 Apr 2010 16:37:09 -0600
In-Reply-To: <4BB517A7.2060305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Mingming Cao wrote:
>> On Wed, 2010-03-31 at 17:06 -0700, jvrao wrote:
>>> lsetxattr()/lgetxsttr() functions are not working on a ext4 symlink. 
>>> But works fine on a regular file.
>>>
>>> I tried the following program.. Not sure if I am missing something.
>>> Any help will be appreciated.
>>>
>>>
>>
>> I tried your test program on ext2/3/btrfs, it seems all broken. 
>> Not sure how this not being visible? Thought xattrs are heavily used by
>> default on some distros.
> 
> xfs as well FWIW.
> 
> however, I'm not sure setting user xattrs directly on symlinks is
> a common operation...

Looking at the  attr(5) says user xattrs are not allowed on symlinks and special files.
I guess it is working as designed. :)

- JV

> 
> -Eric
> 


