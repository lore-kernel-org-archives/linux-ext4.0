From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] mke2fs: skip alignment questioning if -F specified
Date: Fri, 12 Mar 2010 10:40:15 -0500
Message-ID: <41734DB2-49FF-41B7-A37A-8670E6B80397@mit.edu>
References: <4B8C1B25.5050006@redhat.com> <20100312024831.GN1497@thunk.org> <31D4615D-CB8C-48D7-934D-2CDAF327CF44@sun.com> <4B9A5AFF.5020401@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:62090 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854Ab0CLPpU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Mar 2010 10:45:20 -0500
In-Reply-To: <4B9A5AFF.5020401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 12, 2010, at 10:17 AM, Eric Sandeen wrote:

> Andreas Dilger wrote:
>> On 2010-03-11, at 19:48, tytso@mit.edu wrote:
>>> On Mon, Mar 01, 2010 at 01:53:09PM -0600, Eric Sandeen wrote:
>>>> RH bug 569021 - mke2fs insists on user interaction even if stdin is
>>>> not a tty and -F is passed
>>>> 
>>>> This is just a warning, -F should easily override it.
>> 
>> Since this is just a warning, do we really need to have "-F" at all?  I
>> dislike requiring "-F" on common actions, because it means that it will
>> commonly be used, but may accidentally override some unintended problem.
>> 
>> We've lived without block device alignment until now, and it seems
>> somewhat unpleasant that mke2fs may start failing (if -F is not given)
>> for situations where it previously worked just fine.
> 
> Well, that's a good point, dropping the -F requirement is fine with me too,
> I guess.
> 
> Ted do you want to just toss in:
> 
> -		if (!force)
> -			proceed_question();


Yeah, I'll just make the change on my end.


-- Ted

