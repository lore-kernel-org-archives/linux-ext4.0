From: Coly Li <i@coly.li>
Subject: Re: [PATCH] ext4: critical info format fix in __ext4_grp_locked_error
Date: Tue, 22 Mar 2011 13:35:20 +0800
Message-ID: <4D883518.8070505@coly.li>
References: <1300442283-31421-1-git-send-email-hao.bigrat@gmail.com> <20110322004739.GJ4135@thunk.org> <4D8809C5.1000402@tao.ma>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, Robin Dong <hao.bigrat@gmail.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:49966 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753602Ab1CVFH1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Mar 2011 01:07:27 -0400
In-Reply-To: <4D8809C5.1000402@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B403=E6=9C=8822=E6=97=A5 10:30, Tao Ma Wrote:
> Hi Ted,
> On 03/22/2011 08:47 AM, Ted Ts'o wrote:
>> Applied to the ext4 patch queue.
>>
>> On Fri, Mar 18, 2011 at 05:58:03PM +0800, Robin Dong wrote:
>>> From: Robin Dong<sanbai@taobao.com>
>>>
>>> When we do performence-testing on ext4 filesystem, we observe a war=
ning like this:
>>>
>>> "[ 1684.113205] EXT4-fs error (device sda7): ext4_mb_generate_buddy=
:718: group 259825901 blocks in bitmap, 26057 in gd"
>>>
>>> indeed, it should be
>>>
>>> "group 2598, 25901 blocks in bitmap, 26057 in gd"
>>
[snip]
>>> This bug is found on upstream 2.6.36 kernel. We ran a 2.6.36 kernel
>>> on the online system with 8 Ext4 file systems. 2 of them are mounte=
d
>>> with delayed allocation feature. This warning is only observed on
>>> delayed allocation enabled Ext4 file systems.
>>>
>>> This issue is not easy to reproduce, on two servers with 2.6.36
>>> kenrel + ext4, after running 110+ days, the error starts to appear
>>> on kernel log. When check the error log, we found the info format
>>> should be fixed, that's how this patch comes.
>>
>> Can you send more information about what sort of workloads your
>> servers are under, and any other information about how to reproduce
>> it?
> OK, so let me try to describe the situation here.
> This is a web cache server and we use squid to cache some data. This =
bug
> was found we were testing 2.6.36 vanilla kernel. We don't know for su=
re
> how to reproduce it since it showed up when the test server ran for
> about 100 days. And the bad thing is that the volume was reformatted =
for
> another test. :( But we have several machines here, and we are
> continuing our test, so if there are any error happening again, we
> promise that we will prompt what we find immediately.
>
> btw, when testing 2.6.32 kernel, we find another error, a dir inode i=
s
> corrupted and some error in message like
>
> Mar 16 11:15:28 cache161 kernel: [484403.699588] EXT4-fs error (devic=
e
> sda5): ext4_lookup: deleted inode referenced: 21496065
>
> This volume is also mounted with delay allocation.
>

When we observed these 2 issues, the Ext4 file systems were mounted wit=
h delalloc option.

--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
