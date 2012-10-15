From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v3 12/13] vfs: add debugfs support
Date: Mon, 15 Oct 2012 16:15:58 +0800
Message-ID: <CAEH94LimWEzB1=eBQ8WAOXqvOY17o4AJQHCNYXTL0h4Vafsfdg@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<1349863655-29320-13-git-send-email-zwu.kernel@gmail.com>
	<20121015075530.GZ2739@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54605 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2JOIQA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2012 04:16:00 -0400
In-Reply-To: <20121015075530.GZ2739@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2012 at 3:55 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Oct 10, 2012 at 06:07:34PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Add a /sys/kernel/debug/hot_track/<device_name>/ directory for each
>> volume that contains two files. The first, `inode_data', contains the
>> heat information for inodes that have been brought into the hot data map
>> structures. The second, `range_data', contains similar information for
>> subfile ranges.
> ....
>> +     /* create debugfs range_data file */
>> +     debugfs_range_entry = debugfs_create_file("range_data",
>> +                             S_IFREG | S_IRUSR | S_IWUSR | S_IRUGO,
>> +                             debugfs_volume_entry,
>> +                             (void *) range_data,
>> +                             &hot_debugfs_range_fops);
>
> These should not be world readable. 0600 is probably the correct
> permissions for them as we do not want random users to be able to
> infer what files users are accessing from this information.
Good catch, its mode should be S_IFREG | S_IRUSR | S_IWUSR

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
