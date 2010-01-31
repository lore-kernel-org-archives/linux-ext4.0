From: Andreas Dilger <adilger@sun.com>
Subject: Re: need help with getting into a corrupted sub directory
Date: Sun, 31 Jan 2010 11:11:25 -0700
Message-ID: <573A48EF-7CE3-481D-935E-364506424D1F@sun.com>
References: <004d01caa172$8d846c10$6401a8c0@kyle>
 <27FC5E2E-2F85-478A-95F2-1B9ED9D07690@sun.com> <20100130174404.GC788@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: kyle <kylewong@southa.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:51717 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab0AaSLb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 31 Jan 2010 13:11:31 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0VIBS5u027554
	for <linux-ext4@vger.kernel.org>; Sun, 31 Jan 2010 10:11:30 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KX400900IFIBA00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Sun,
 31 Jan 2010 10:11:28 -0800 (PST)
In-reply-to: <20100130174404.GC788@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-30, at 10:44, tytso@mit.edu wrote:
> On Sat, Jan 30, 2010 at 12:24:09AM -0700, Andreas Dilger wrote:
>> On 2010-01-29, at 23:07, kyle wrote:
>>> I have a ext3 filesystem created inside a problematic seagate
>>> ST3500320AS drive. The drive will just shut itself down  
>>> automatically
>>> whenever it hits any read error.
>>
>> Strange, I had to do the same for a friend, and I think it was the
>> same drive.
>> You should put it into a USB enclosure - it speeds things up a lot.

I just checked the drive type that I had this problem on, it is  
ST3320620AS, as I kept it in case there needed to be more rescue work  
done.  Not exactly the same, but I don't know enough about Seagate  
model numbers to determine how related they are.

> An image copy of the disk will tend to recover more than accessing the
> disk via the file system.  I haven't run across the failure mode where
> accessing a certain magic block causes the disk to die and require a
> power cycle, but in that case what I'd probably do is enhance the
> dd_rescue program to take a list of block numbers which it should skip
> over....

Well, I thought the same thing initially, but like the poster I have a  
drive which dies (locks up internally? I don't know) as soon as  
certain files are accessed.  Since  I could get 95%+ of the files  
using the "rsync -av --exclude-from {bad_file_list}" method, and the  
files I couldn't recover were of marginal value, I did that, as it was  
expedient.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

