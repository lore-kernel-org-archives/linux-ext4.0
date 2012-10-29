From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 13/19] debugfs: introduce one function
Date: Tue, 30 Oct 2012 06:58:11 +0800
Message-ID: <CAEH94LjOGb_==OA7TZDYxpdHjXS_5ekpcxkMJSCgHvpbdD4_1g@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-14-git-send-email-zwu.kernel@gmail.com>
	<20121029181135.GB3605@kroah.com>
	<CAEH94Li_XUxUUJDskO28OSvZPmZB3u_SpLFcVtD-04PivQSS8w@mail.gmail.com>
	<20121029223404.GA20486@kroah.com>
	<CAEH94Lj2baN-EzjTvxURc5ECyfjh9Z+w6NZbNUok3osOLF55ag@mail.gmail.com>
	<20121029225421.GA21772@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41446 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2J2W6N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2012 18:58:13 -0400
In-Reply-To: <20121029225421.GA21772@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 30, 2012 at 6:54 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Oct 30, 2012 at 06:45:19AM +0800, Zhi Yong Wu wrote:
>> On Tue, Oct 30, 2012 at 6:34 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Tue, Oct 30, 2012 at 06:25:50AM +0800, Zhi Yong Wu wrote:
>> >> On Tue, Oct 30, 2012 at 2:11 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> > On Mon, Oct 29, 2012 at 12:30:55PM +0800, zwu.kernel@gmail.com wrote:
>> >> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >> >>
>> >> >>   The debugfs function is used to get expected dentry.
>> >> >
>> >> > Huh?  Why do you need this?  Why haven't you added documentation for the
>> >> It is used to determine if one sysfs directory has been created. OK, i
>> >> will add some doc, thanks for your suggestion.
>> >
>> > You didn't answer the "why" part here.  How come you think you need
>> ah, Let me say its scenario at first. If we do two mount ops as below:
>> 1.) mount -o loop,hot_track image1 /data1
>> 2.) mount -o loop,hot_track image2 /data2
>>
>> The mount -o hot_track operation will automatically create one sysfs
>> directory /sys/kernel/debug/hot_track. To prevent this dir being
>> created again when 2.) is done, we need to know if it has existed at
>> first. In my patch, i at first get its dentry by this new function,
>> then determine if its d_inode field is NULL, if no, it means that this
>> sysfs dir has existed.
>> This is the reason that i want to add one new function.
>
> Why not do like the rest of the kernel does and just have a:
>         static dentry *hot_track_root;
> and use that as your root debugfs directory dentry:
ah, i'm one newbie, don't get familar with other kernel part, but this
is one good point, i will apply it, thanks.
>
>         if (!hot_track_root) {
>                 /* Create root directory */
>                 hot_track_root = debugfs_create(...);
>         }
>
> No need to look anything up :)
>
> thanks,
>
> greg k-h



-- 
Regards,

Zhi Yong Wu
