From: "Rohit Sharma" <imreckless@gmail.com>
Subject: Re: inode and blocks
Date: Tue, 30 Sep 2008 19:26:23 +0530
Message-ID: <2d08ef090809300656k5b430dd6t6c64fe1c1515af5a@mail.gmail.com>
References: <2d08ef090809280319m64555696nfe1a446e010f921f@mail.gmail.com>
	 <20080928210118.GD8711@mit.edu>
	 <2d08ef090809290733x2a58cfbl520be9810d772063@mail.gmail.com>
	 <ef1901a00809291024u32bfabfo2961f0c63b32d267@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Tso" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: Sunil <infinite.questions@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:40362 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYI3N4Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2008 09:56:24 -0400
Received: by gxk9 with SMTP id 9so11721885gxk.13
        for <linux-ext4@vger.kernel.org>; Tue, 30 Sep 2008 06:56:23 -0700 (PDT)
In-Reply-To: <ef1901a00809291024u32bfabfo2961f0c63b32d267@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 29, 2008 at 10:54 PM, Sunil <infinite.questions@gmail.com> wrote:
>
>
> On Mon, Sep 29, 2008 at 8:03 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>>
>> Not an assignment actually, but a project.
>> We are working on open hierarchical storage management, in which we
>> store files on disks according to different file placement policies.
>> For eg. if i say that all the important files, like all the employee
>> database should be in disk 1 and all the songs on disk 2, then we
>> place them accordingly in different disks.
>>
>>
>> On Mon, Sep 29, 2008 at 2:31 AM, Theodore Tso <tytso@mit.edu> wrote:
>> > On Sun, Sep 28, 2008 at 03:49:04PM +0530, Rohit Sharma wrote:
>> >> Suppose i have a file named abc.txt and i want to specify that
>> >> all the *.txt files must be allocated between block groups no. 100 -
>> >> 200 in ext2 fs.
>> >>
>> >> Is there a way to do this?
>> >>
>> >> can we modify function ext2_new_inode and find_group_orlov for this?
>> >
>> > You would have to modify kernel code to do this; the main question
>> > which comes to mind is *why* would you want to do something like this?
>> > It seems like an ideal problem set that a professor might give to a
>> > student, since it would force them to try to get from an inode to the
>> > pathname used to open the file.  So it seems to be one of these really
>> > pointless things that isn't particularly useful in real life, except
>> > for pedagogical purposes.
>> >
>> >                                                        - Ted
>> >
>>
>> --
>> To unsubscribe from this list: send an email with
>> "unsubscribe kernelnewbies" to ecartis@nl.linux.org
>> Please read the FAQ at http://kernelnewbies.org/FAQ
>>
>
> Hi Rohit,
>
> Just out of curiosity, how are you going to identify the type of file inside
Thanks Sunil for looking into the matter.

> kernel ? from an extension or file format ?
>

Yes i will find using extension. :)

> Thanks.
>
> --
> Sunil.
>
