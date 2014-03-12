From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: [PATCH] create_inode: fix gcc -Wall complaints
Date: Wed, 12 Mar 2014 14:33:33 +0800
Message-ID: <531FFFBD.1010503@windriver.com>
References: <1394595670-11193-1-git-send-email-tytso@mit.edu> <20140312034539.GC26898@thunk.org> <20140312034841.GC31864@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:62425 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaCLGdk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2014 02:33:40 -0400
In-Reply-To: <20140312034841.GC31864@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 03/12/2014 11:48 AM, Darrick J. Wong wrote:
> On Tue, Mar 11, 2014 at 11:45:39PM -0400, Theodore Ts'o wrote:
>> On Tue, Mar 11, 2014 at 11:41:10PM -0400, Theodore Ts'o wrote:
>>> We had several functions that were not returning zero on success.  Fix
>>> this.
>>>
>>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>
>> One additional gcc -Wall nit which I have not yet fixed:
>>
>> create_inode.c is using ext2fs_inline_data_init() which is currently a
>> private function defined in ext2fsP.h.
>>
>> We either need to make this a publically exported interface (in which
>> case we have to guarantee that it is stable), or we need to find
>> another way to make the right thing happen here.
>>
>> Darrick, Robert, do you have any thoughts or suggestions?
>
> I fixed that up in the cppcheck cleanups patch by moving those declarations to
> ext2fs.h.  Maybe I should have shoved the patch closer to the head.
>

He Darrick and Ted,


Thank you very much!

// Robert

> --D
>>
>> 	       	    	      	    	   - Ted
>>
>> P.S.  My bad for not doing a gcc -Wall run on the patches before
>> accepting them.  And in the future, I'd appreciate it if people who
>> are preparing patches do a "make gcc-wall" and make sure you're not
>> making things worse.  There are plenty of bugs that can be turned up
>> this way.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
