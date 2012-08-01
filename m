From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: "Unknown code" error when enabling metadata_csum on ext4 raid1
 device
Date: Wed, 01 Aug 2012 14:51:43 +0700
Message-ID: <5018E00F.1000207@wpkg.org>
References: <CAFepXZhPc0Vw-m0h_U9SnS6=CutOsGbiApe=-PEbKb3dxWOEvw@mail.gmail.com> <20120801071935.GA12929@gmail.com> <5018D7D9.6080709@wpkg.org> <20120801074845.GA13030@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: semenko@syndetics.net, linux-ext4@vger.kernel.org,
	semenko@alum.mit.edu, tytso@mit.edu, djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:58159 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab2HAHvv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Aug 2012 03:51:51 -0400
In-Reply-To: <20120801074845.GA13030@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/01/2012 02:48 PM, Zheng Liu wrote:

>> didn't try the patch yet, but I've noticed the following in dmesg since 3.5:
>>
>> [69004.637293] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
>> [69004.637330] EXT4-fs warning (device sda1): dx_probe:647: dx entry: limit != root limit
>> [69004.637335] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
>> [69004.637365] EXT4-fs warning (device sda1): dx_probe:647: dx entry: limit != root limit
>> [69004.637370] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
>>
>>
>> Could this be related?
>
> Are these messages printed before you enable metadata_csum feature?

I didn't notice them before trying to enable metadata_csum feature.

On the other hand, enabling metadata_csum feature was pretty much the 
first thing I've made after booting to 3.5 kernel on this system, so it 
could be it changed something.


Also, when I do:

	dumpe2fs -h /dev/sda1|grep metadata_csum

I don't see metadata_csum feature anywhere.


-- 
Tomasz Chmielewski
http://blog.wpkg.org

