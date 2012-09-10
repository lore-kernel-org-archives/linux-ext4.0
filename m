From: Terry <td3201@gmail.com>
Subject: Re: ext4 won't mount - fsck required - 2nd fsck in less than a week
Date: Mon, 10 Sep 2012 08:56:53 -0500
Message-ID: <CAHSRzpC1SKr08yS0EvEAkS4JpoiAfZ0ab+PHkZwED02mrVbc-A@mail.gmail.com>
References: <CAHSRzpC4bnZs1G8BHcuQL6Bf9cKiVb15Ha0sybRdkpwUZbdMKQ@mail.gmail.com>
	<20120910024709.GA3439@thunk.org>
	<CAHSRzpDzz4TnQDjunkh3tVHwk5dQHbgEXYCaDE7FOr=U0EZwAw@mail.gmail.com>
	<CAHSRzpDATS+yMDyw6Wts2DMjyDpJx0rVB5M8QLpKxPFUwHWzXA@mail.gmail.com>
	<CAHSRzpDmw30Z4XqpjcY1DWAv_D701C163fiWJDoWyaLpHPhaMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36553 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab2IJN4z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Sep 2012 09:56:55 -0400
Received: by lbbgj3 with SMTP id gj3so1196600lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 10 Sep 2012 06:56:53 -0700 (PDT)
In-Reply-To: <CAHSRzpDmw30Z4XqpjcY1DWAv_D701C163fiWJDoWyaLpHPhaMg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 10, 2012 at 8:48 AM, Terry <td3201@gmail.com> wrote:
> On Sun, Sep 9, 2012 at 10:18 PM, Terry <td3201@gmail.com> wrote:
>> On Sun, Sep 9, 2012 at 9:53 PM, Terry <td3201@gmail.com> wrote:
>>> On Sun, Sep 9, 2012 at 9:47 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>>>> On Sun, Sep 09, 2012 at 09:34:10PM -0500, Terry wrote:
>>>>>
>>>>> As the subject says, we have a 15 TB fsck drive that won't mount with
>>>>> these errors:
>>>>>
>>>>> Sep 9 20:02:20 narf kernel: EXT4-fs (dm-9): ext4_check_descriptors:
>>>>> Inode bitmap for group 3200 not in group (block 4161027887)!
>>>>> Sep 9 20:02:20 narf kernel: EXT4-fs (dm-9): group descriptors corrupted!
>>>>
>>>> These indicate a very basic file system corruption where the block
>>>> group descriptors are corrupted.  E2fsck will complain immediately
>>>> upon seeing this sort of fs inconsistency, and the first thing it will
>>>> try to do is fix it.
>>>>
>>>>> We did a proactive fsck on Tuesday of last week because it was
>>>>> starting to give filesystem errors. It ran through and mounted fine.
>>>>>
>>>>> The filesystem lives on an equallogic SAN spread across 36 drives.
>>>>> Could this be something with the physical layer or is it not abnormal
>>>>> to have to run multiple rounds of fsck to fully fix an issue?
>>>>
>>>> This is most probably a hardware problem; normally e2fsck will fix
>>>> file system corruptions (and certainly problems such as corrupt block
>>>> group scriptors) in a single pass.  If e2fsck finished and the file
>>>> system mounted fine last week, and now you're getting this kind of
>>>> error, it basically screams some kind of physical layer problem, or
>>>> perhaps a bad hard drive, or perhaps the SAN disk is getting
>>>> incorrectly written to by some other system, etc.
>>>>
>>>>                                      - Ted
>>>
>>> Thanks for the reply.  It is part of a RHEL cluster but we did not
>>> have any situations where multiple systems mounted the filesystem.  It
>>> is a an old SAN so perhaps we have a physical issue. We'll see what it
>>> happens with this pass.
>>
>> While I am waiting for fsck to finish, another thought. This
>> filesystem contains a lot of small files. 35,867,642 files to be
>> exact.  Anything else I should check or know to ensure a smooth
>> operation for these types of filesystems?  I formatted them with
>> standard RHEL 6 options.
>
> FSCK completed fixing a lot of things.  The file system then mounted
> without any errors.  We are still getting these types of errors in
> /var/log/messages:
>
> Sep 10 08:40:49 narf kernel: EXT4-fs error (device dm-6):
> ext4_dx_find_entry: bad entry in directory #743966900: directory entry
> across blocks - block=2975876794offset=0(946176), inode=1414751737,
> rec_len=45724, name_len=206
>
> Thoughts?

Hold that thought.  This is another filesystem.  Let me fix that one
then come back to this problem if it still exists.
