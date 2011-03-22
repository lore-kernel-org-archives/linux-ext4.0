From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: critical info format fix in __ext4_grp_locked_error
Date: Tue, 22 Mar 2011 10:30:29 +0800
Message-ID: <4D8809C5.1000402@tao.ma>
References: <1300442283-31421-1-git-send-email-hao.bigrat@gmail.com> <20110322004739.GJ4135@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Robin Dong <hao.bigrat@gmail.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:40326 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756289Ab1CVCac (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Mar 2011 22:30:32 -0400
In-Reply-To: <20110322004739.GJ4135@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
On 03/22/2011 08:47 AM, Ted Ts'o wrote:
> Applied to the ext4 patch queue.
> 
> On Fri, Mar 18, 2011 at 05:58:03PM +0800, Robin Dong wrote:
>> From: Robin Dong <sanbai@taobao.com>
>>
>> When we do performence-testing on ext4 filesystem, we observe a warning like this:
>>
>> "[ 1684.113205] EXT4-fs error (device sda7): ext4_mb_generate_buddy:718: group 259825901 blocks in bitmap, 26057 in gd"
>>
>> indeed, it should be
>>
>> "group 2598, 25901 blocks in bitmap, 26057 in gd"
> 
> Note that the next two paragraphs don't really belong in a commit
> description.  It's best if you put this kind of stuff after the
> signed-off-by lines, with a "---" separating the commit description, like this:
> 
> Signed off by: Ty Coon <tycoon@gmail.com>
> ---
> Stuff that explains the context of the patch
> 
> diff --git ....
> 
>> This bug is found on upstream 2.6.36 kernel. We ran a 2.6.36 kernel
>> on the online system with 8 Ext4 file systems. 2 of them are mounted
>> with delayed allocation feature. This warning is only observed on
>> delayed allocation enabled Ext4 file systems.
>>
>> This issue is not easy to reproduce, on two servers with 2.6.36
>> kenrel + ext4, after running 110+ days, the error starts to appear
>> on kernel log. When check the error log, we found the info format
>> should be fixed, that's how this patch comes.
> 
> Can you send more information about what sort of workloads your
> servers are under, and any other information about how to reproduce
> it?
OK, so let me try to describe the situation here.
This is a web cache server and we use squid to cache some data. This bug
was found we were testing 2.6.36 vanilla kernel. We don't know for sure
how to reproduce it since it showed up when the test server ran for
about 100 days. And the bad thing is that the volume was reformatted for
another test. :( But we have several machines here, and we are
continuing our test, so if there are any error happening again, we
promise that we will prompt what we find immediately.

btw, when testing 2.6.32 kernel, we find another error, a dir inode is
corrupted and some error in message like

Mar 16 11:15:28 cache161 kernel: [484403.699588] EXT4-fs error (device
sda5): ext4_lookup: deleted inode referenced: 21496065

This volume is also mounted with delay allocation.

Do you know bug related to this? We haven't checked if the upstream has
the similar bug or not.

Thanks.

Regards,
Tao
