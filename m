From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] ext4: don't clear orphan list on ro mount with errors
Date: Wed, 26 Sep 2012 23:32:27 -0500
Message-ID: <5063D6DB.2000305@redhat.com>
References: <503BC685.7090707@redhat.com> <503BCA24.7050100@redhat.com> <20120927033211.GE15707@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab2I0Ecb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 00:32:31 -0400
In-Reply-To: <20120927033211.GE15707@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/26/12 10:32 PM, Theodore Ts'o wrote:
> On Mon, Aug 27, 2012 at 02:27:32PM -0500, Eric Sandeen wrote:
>> When we have a filesystem with an orphan inode list *and* in error
>> state, things behave differently if:
>>
>> 1) e2fsck -p is done prior to mount: e2fsck fixes things and exits
>>    happily (barring other significant problems)
>>
>> vs.
>>
>> 2) mount is done first, then e2fsck -p: due to the orphan inode
>>    list removal, more errors are found and e2fsck exits with
>>    UNEXPECTED INCONSISTENCY.
>>
>> The 2nd case above, on the root filesystem, has the tendency to halt
>> the boot process, which is unfortunate.
>>
>> The situation can be improved by not clearing the orphan
>> inode list when the fs is mounted readonly.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> I've applied this commit since I agree with Jan's observation that if
> the file system is mounted read-only, we should try to minimize
> changes to it if it contains errors.  I have modified the commit
> description though:

Fair enough, thanks.

-Eric

> ext4: don't clear orphan list on ro mount with errors
> 
> From: Eric Sandeen <sandeen@redhat.com>
> 
> If the file system contains errors and it is being mounted read-only,
> don't clear the orphan list.  We should minimize changes to the file
> system if it is mounted read-only.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

