From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs segfaults during make check
Date: Mon, 08 Feb 2010 09:57:57 -0600
Message-ID: <4B703485.9070301@redhat.com>
References: <1265614286.3882.16.camel@metis> <20100208121619.GF4494@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Ext4 <linux-ext4@vger.kernel.org>, adilger@Sun.COM
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab0BHP6D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2010 10:58:03 -0500
In-Reply-To: <20100208121619.GF4494@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Mon, Feb 08, 2010 at 01:01:26PM +0530, Girish Shilamkar wrote:
>> Hello,
>>      I found a problem while creating e2fsprogs rpms. Few of the tests
>> fail with segfault during make check. The tests are d_loaddump, f_dup4,
>> f_imagic_fs and r_resize_inode. This failure is only seen on rhel5,
>> x86_64. 
>>       On further searching I found that this error can reproduced when
>> e2fsprogs is configured with shared elf libraries. For example,
>> configure --enable-elf-shlibs, make; make check 
>> And this problem is seen from 1.41.7 version onwards.
>>
>> Any ideas/comments ?
> 
> Well, I run "make check" all the time during the course of my
> development, so it must be something unique with RHEL5.

FWIW, it was make check segfaulting that led me to run valgrind
and find that array problem.

It's probably the flags that rpm builds with by default, doing
a better job at catching this sort of thing?

Girish Shilamkar wrote:

>> #3) Try downloading:
>> > 
>> >     http://master.kernel.org/~tytso/e2fsprogs_1.41.10-rc1.tar.gz
>> > 
>> > ... and see if you can see the problem there.
> The problem is not seen for this version. Any tentative dates for 1.41.10 release ?

I'm guessing the problem was fixed by the resize2fs array
indexing patch.

-Eric
