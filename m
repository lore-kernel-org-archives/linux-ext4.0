From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] e2fsprogs: enable user namespace xattrs by default
Date: Wed, 16 Feb 2011 16:58:35 -0600
Message-ID: <4D5C569B.100@redhat.com>
References: <4D5C1380.2020602@redhat.com> <4D5C15C6.5000802@redhat.com> <C637E27A-6E13-4950-B4CC-0451FDB421B9@dilger.ca> <4D5C252B.2010102@redhat.com> <20110216214910.GB26780@thunk.org> <4D5C473D.5030009@redhat.com> <20110216225622.GF26780@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab1BPW6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 17:58:39 -0500
In-Reply-To: <20110216225622.GF26780@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/16/11 4:56 PM, Ted Ts'o wrote:
> On Wed, Feb 16, 2011 at 03:53:01PM -0600, Eric Sandeen wrote:
>> Whoops, I didn't realize that acls were in the same boat, of "config
>> on and then turn on with a mount option"
>>
>> Ok, sure, adding that makes sense to me too...
>>
>> Is sticking it in the _initialize() function ok with you?  It's a
>> little odd, but ...
> 
> I think it's probably better to put it in the misc/mke2fs.c; we set a
> number of superblock options there already.  But either place is fine...
> 
> 						- Ted

Ok, if we do it in mke2fs.c that's probably better.

Or - I wonder how hard it'd be to make this into a mke2fs.conf
option instead?  I always forget about that route.

get_string_from_profile(... "default_mount_opts" ....) ?

-Eric
