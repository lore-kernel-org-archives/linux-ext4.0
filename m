From: Nick Semenkovich <semenko@alum.mit.edu>
Subject: Re: "Unknown code" error when enabling metadata_csum on ext4 raid1 device
Date: Wed, 1 Aug 2012 22:43:05 -0500
Message-ID: <CAFepXZjgihKhAOpF3KJ8dKfHGpip-Kaf8+xvwrpTOqWB8Zs9rQ@mail.gmail.com>
References: <CAFepXZhPc0Vw-m0h_U9SnS6=CutOsGbiApe=-PEbKb3dxWOEvw@mail.gmail.com>
 <20120801071935.GA12929@gmail.com> <5018D7D9.6080709@wpkg.org>
 <20120801074845.GA13030@gmail.com> <5018E00F.1000207@wpkg.org> <20120801081744.GA13335@gmail.com>
Reply-To: semenko@syndetics.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Tomasz Chmielewski <mangoo@wpkg.org>, semenko@syndetics.net,
	linux-ext4@vger.kernel.org, semenko@alum.mit.edu, tytso@mit.edu,
	djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45242 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab2HBDn0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Aug 2012 23:43:26 -0400
Received: by qcro28 with SMTP id o28so5056439qcr.19
        for <linux-ext4@vger.kernel.org>; Wed, 01 Aug 2012 20:43:25 -0700 (PDT)
In-Reply-To: <20120801081744.GA13335@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 1, 2012 at 3:17 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Wed, Aug 01, 2012 at 02:51:43PM +0700, Tomasz Chmielewski wrote:
>> On 08/01/2012 02:48 PM, Zheng Liu wrote:
>>
>> >>didn't try the patch yet, but I've noticed the following in dmesg since 3.5:
>> >>
>> >>[69004.637293] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
>> >>[69004.637330] EXT4-fs warning (device sda1): dx_probe:647: dx entry: limit != root limit
>> >>[69004.637335] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
>> >>[69004.637365] EXT4-fs warning (device sda1): dx_probe:647: dx entry: limit != root limit
>> >>[69004.637370] EXT4-fs warning (device sda1): dx_probe:732: Corrupt dir inode 524293, running e2fsck is recommended.
>> >>
>> >>
>> >>Could this be related?
>> >
>> >Are these messages printed before you enable metadata_csum feature?
>>
>> I didn't notice them before trying to enable metadata_csum feature.
>>
>> On the other hand, enabling metadata_csum feature was pretty much
>> the first thing I've made after booting to 3.5 kernel on this
>> system, so it could be it changed something.
>
> Yes, it will change something when you try to enable metadata_csum
> feature in tune2fs.  So you'd better to run e2fsck to check your
> filesystem IMHO.
>

Sorry for the slow reply --


I hadn't seen any "Corrupt dir inode" errors until now.

Before running the one-line patch above, I resynced the MD array and
ran a quick fsck (via "touch /forcefsck" & reboot).


Then,
$ sudo misc/tune2fs -O metadata_csum /dev/md1

[says something about running e2fsck -D]


Then I got a few dmesg errors like:

[128700.816091] JBD2: Spotted dirty metadata buffer (dev = md1,
blocknr = 5243385). There's a risk of filesystem corruption in case of
system crash.
[128700.816106] JBD2: Spotted dirty metadata buffer (dev = md1,
blocknr = 1057). There's a risk of filesystem corruption in case of
system crash.

then a lot of

[128711.000677] EXT4-fs warning (device md1): dx_probe:647: dx entry:
limit != root limit
[128711.000679] EXT4-fs warning (device md1): dx_probe:732: Corrupt
dir inode 7733251, running e2fsck is recommended.


On my next command (sudo -s), I got an immediate kernel panic:

[128713.776475] EXT4-fs warning (device md1): dx_probe:732: Corrupt
dir inode 7733251, running e2fsck is recommended.
[128761.137143] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[128761.137195] IP: [<ffffffff8121d448>] ext4_iget+0x498/0xa50
[128761.137231] PGD 106651067 PUD 11cf41067 PMD 0
[128761.137258] Oops: 0000 [#1] SMP
[128761.137279] CPU 0
[snip...]

Full panic @ http://web.mit.edu/semenko/Public/panic.txt

-- 
Nick Semenkovich
Laboratory of Dr. Jeffrey I. Gordon
Medical Scientist Training Program
School of Medicine
Washington University in St. Louis
http://web.mit.edu/semenko/
