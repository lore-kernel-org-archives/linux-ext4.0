From: Robert Yang <liezhi.yang@windriver.com>
Subject: Re: e2fsprogs: mke2fs -d: copy the Extended Attributes
Date: Fri, 18 Apr 2014 01:33:21 +0800
Message-ID: <53501061.9040505@windriver.com>
References: <534F7F5A.3070805@windriver.com> <20140417162707.GK18591@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:42082 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDQRda (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 13:33:30 -0400
In-Reply-To: <20140417162707.GK18591@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 04/18/2014 12:27 AM, Theodore Ts'o wrote:
> On Thu, Apr 17, 2014 at 03:14:34PM +0800, Robert Yang wrote:
>>
>> The "mke2fs -d" doesn't copy the file's extended attributes into the
>> device currently, I'd like to make it work and submit a patch for it
>> if it is acceptable by e2fsprogs. Maybe we can add a "[-x xattr]"
>> option for "mke2fs -d" to make it copy the extended attributes.
>
> Any reason not to always copy the xattrs if they exist?
>
> If we want to add a new option for a feature like this which is fairly
> exotic, my preference would be to either use the -E mechanism and make
> it be an extended option, or to put it in /etc/mke2fs.conf.

Thanks for the reply, yes, add the new option "[-x xattr]" sounds
strange, I will try to use the -E mechanism and make it be an
extended option.

Have a good day, I have to go to sleep now.

// Robert

>
> Regards,
>
> 						- Ted
>
>
