From: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: ext2_block_alloc_info
Date: Tue, 23 Dec 2008 15:06:24 +0800
Message-ID: <804dabb00812222306g69760104ga5a0992c90538bd4@mail.gmail.com>
References: <2d08ef090812200743o47cd4abdwd9915653f6f4f3f7@mail.gmail.com>
	 <804dabb00812201725r304bed36ufc56ebc2393e2299@mail.gmail.com>
	 <170fa0d20812221856j4c660384nc2ac693ca8fd0ba4@mail.gmail.com>
	 <804dabb00812222029x76d34c24o798ade5dd0e31351@mail.gmail.com>
	 <37d33d830812222037s362060c3i8278a8a39083c50f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Mike Snitzer" <snitzer@gmail.com>,
	"Rohit Sharma" <imreckless@gmail.com>,
	Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Sandeep K Sinha" <sandeepksinha@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:15954 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYLWHGZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Dec 2008 02:06:25 -0500
Received: by yx-out-2324.google.com with SMTP id 8so822379yxm.1
        for <linux-ext4@vger.kernel.org>; Mon, 22 Dec 2008 23:06:24 -0800 (PST)
In-Reply-To: <37d33d830812222037s362060c3i8278a8a39083c50f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Very good work done.....may be 2 more document will be useful:

a.   TODO LIst:  listing your purpose/targets/directions/work
breakdown for the next few months.
b.   API List/scripts lists:  listing the work output - be
modules/scripts/or C API (userspace/kernelspace) completed, which
others may find useful.   It should coincide with your targets.

Shall browse deeper!!!

On Tue, Dec 23, 2008 at 12:37 PM, Sandeep K Sinha
<sandeepksinha@gmail.com> wrote:
> I have a tool ready with unfolds a file system completely thrugh
> ioctl. You will just have to patch the kernel.
> And that also, its for ext2.
> But its really verbose.
>
> You can have a look for the sources @ http://code.google.com/p/fscops/
> We will be uploading the tool there soon.
>
> Rohit if you have a working copy can you mail it to him.
>
> On Tue, Dec 23, 2008 at 9:59 AM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>> Sorry, resent due to SMTP error:
>>
>> anyone knows any way of enumerating all the low level information like
>> these for each file?
>>
>> Best I can get is "debugfs":
>>
>> So using "show_inode_infor xxxx":
>>
>> Inode: 1146884   Type: regular    Mode:  0767   Flags: 0x0
>> Generation: 4262211373
>> User:     0   Group:     0   Size: 4670783
>> File ACL: 0    Directory ACL: 0
>> Links: 1   Blockcount: 9152
>> Fragment:  Address: 0    Number: 0    Size: 0
>> ctime: 0x46db7fb6 -- Mon Sep  3 11:29:58 2007
>> atime: 0x47c66735 -- Thu Feb 28 15:48:05 2008
>> mtime: 0x43118298 -- Sun Aug 28 17:23:36 2005
>> BLOCKS:
>> (0-11):2317946-0, (IND):2317958, (12-1035):2317959-0, (DIND):2318983,
>> (IND):2318984, (1036-1140):2318985-0
>> TOTAL: 1144
>>
>> Here the "BLOCKS" correspond to the block numbering we are talking
>> about, right?   It always start at 0 per-file.   "IND" is the indirect
>> block.   But what is "DIND"?   "2317946" is the physical block number
>> right?   And what is the zero after the "2317946"?
>>
>> On Tue, Dec 23, 2008 at 10:56 AM, Mike Snitzer <snitzer@gmail.com> wrote:
>>>
>>> On Sat, Dec 20, 2008 at 8:25 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>>> > On Sat, Dec 20, 2008 at 11:43 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>>> >> A little confusion.
>>> >>
>>> >> Just refer this structure in linux/ext2_fs_sb.h
>>> >>
>>> >> struct ext2_block_alloc_info {
>>> >>  46        /* information about reservation window */
>>> >>  47        struct ext2_reserve_window_node rsv_window_node;
>>> >>  48        /*
>>> >>  49         * was i_next_alloc_block in ext2_inode_info
>>> >>  50         * is the logical (file-relative) number of the
>>> >>  51         * most-recently-allocated block in this file.
>>> >>  52         * We use this for detecting linearly ascending allocation requests.
>>> >>  53         */
>>> >>  54        __u32                   last_alloc_logical_block;
>>> >
>>> > if i interpret the meaning of "file-relative logical number"
>>> > correctly, and since one-file-one-inode concept, then it means that it
>>> > should mean inode-relative logical block number.
>>> >
>>> >>  55        /*
>>> >>  56         * Was i_next_alloc_goal in ext2_inode_info
>>> >>  57         * is the *physical* companion to i_next_alloc_block.
>>> >>  58         * it the the physical block number of the block which was
>>> >
>>> >> inode1 has logical blocks 0 1 2 , physical 22 23 24
>>> >> inode2 has logical blocks 0 1 2 , physical 34 35 50
>>> >>
>>> >
>>> > as per comment above, the sequence above looks likely, but then this
>>> > is my guess again.
>>>
>>> You are correct.  last_alloc_logical_block is used to detect if the
>>> write workload against a given inode is sequential (the current
>>> logical block is last_alloc_logical_block+1).
>>>
>>> Mike
>>
>>
>>
>> --
>> Regards,
>> Peter Teoh
>>
>> Ernest Hemingway - "Never mistake motion for action."
>>
>> --
>> To unsubscribe from this list: send an email with
>> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
>> Please read the FAQ at http://kernelnewbies.org/FAQ
>>
>>
>
>
>
> --
> Regards,
> Sandeep.
>
>
>
>
>
>
> "To learn is to change. Education is a process that changes the learner."
>



-- 
Regards,
Peter Teoh

Ernest Hemingway - "Never mistake motion for action."
