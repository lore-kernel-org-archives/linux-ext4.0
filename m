From: Tao Ma <tm@tao.ma>
Subject: Re: big allocation status
Date: Mon, 27 Jun 2011 18:25:11 +0800
Message-ID: <4E085A87.7050101@tao.ma>
References: <4DE83F83.6070302@tao.ma> <20110604033805.GD2614@thunk.org> <20110606230421.GF20818@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:36225 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754927Ab1F0KZT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 06:25:19 -0400
In-Reply-To: <20110606230421.GF20818@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
	We began our test this week. And we found an error in dmesg:

[10484.043482] EXT4-fs (sda10): delayed block allocation failed for
inode 2289279 at logical offset 0 with max blocks 2 with error -28
[10484.043484] EXT4-fs (sda10): This should not happen!! Data will be lost
[10484.043484]
[10484.043486] Total free blocks count 0
[10484.043487] Free/Dirty block details
[10484.043488] free_blocks=0
[10484.043489] dirty_blocks=1495584
[10484.043489] Block reservation details
[10484.043490] i_reserved_data_blocks=2
[10484.043491] i_reserved_meta_blocks=1

yes, df shows that the file system is used 100% now, so I am not sure
whether this is a bug or not.

btw, this is a postmark test.

Regards,
Tao


On 06/07/2011 07:04 AM, Ted Ts'o wrote:
> On Fri, Jun 03, 2011 at 11:38:05PM -0400, Ted Ts'o wrote:
>> On Fri, Jun 03, 2011 at 09:57:23AM +0800, Tao Ma wrote:
>>> Hi Ted,
>>>
>>> Do you have any new branch or patch set that can be used for testing
>>> about big allocation? The latest patch set in the mailist is what you
>>> have sent at the beginning of May. Do you have an updated one? We will
>>> try to test it soon and it would grateful if we are on the same page.
>>
>> There is a patch set available at:
>>
>> git://repo.or.cz/ext4-patch-queue.git
>>
>> The bigalloc patches are after the stable-boundary, and will apply
>> against 3.0-rc1.
> 
> I've updated the bigalloc patch set to fix a number of bugs that I and
> a colleague of mine at Google have found.
> 
> This patch set known have problems with i_blocks getting out of sync
> if delalloc is enabled (particularly with sparse files and truncates),
> and as mentioned before, doesn't work correctly with the punch ioctl.
> These are bugs that we plan to fix before anything gets pushed into
> upstream, of course.
> 
> 	      					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

