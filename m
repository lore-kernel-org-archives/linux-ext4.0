From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 unknown problem
Date: Tue, 31 Jul 2012 11:45:32 -0500
Message-ID: <50180BAC.8070607@redhat.com>
References: <1343355595.179511343719122536.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	info <info@plaintext.sk>
To: luvar@plaintext.sk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab2GaS2t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 14:28:49 -0400
In-Reply-To: <1343355595.179511343719122536.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/31/12 2:18 AM, luvar@plaintext.sk wrote:
> Hi,
> dmesg is probably useles:
> 
> Probably some logs after mounting...:
> 
> # dmesg | grep EXT
> EXT3-fs (md2): mounted filesystem with ordered data mode
> EXT3-fs (md2): using internal journal
> EXT3-fs (dm-2): using internal journal
> EXT3-fs (dm-2): mounted filesystem with ordered data mode
> EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
> EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
> EXT4-fs (dm-12): mounted filesystem without journal. Opts: (null)
> EXT4-fs (dm-8): re-mounted. Opts: commit=0
> EXT4-fs (dm-3): re-mounted. Opts: commit=0
> EXT4-fs (dm-12): re-mounted. Opts: commit=0

^^^ um, what's that all about?

In theory, according to the docs, that's the same as the default, I guess.

and:

                } else if (token == Opt_commit) {
                        if (arg == 0)
                                arg = JBD2_DEFAULT_MAX_COMMIT_AGE;

ok, I guess it is.

> EXT4-fs (dm-28): mounted filesystem with ordered data mode. Opts: (null)
> EXT3-fs (dm-10): using internal journal
> EXT3-fs (dm-10): mounted filesystem with ordered data mode
> 
> On last few lines, there is some info about usb key used on thic pc:
> 
> # dmesg | tail -n 30
> sd 14:0:0:0: [sdg] Asking for cache data failed
> sd 14:0:0:0: [sdg] Assuming drive cache: write through
...

> Other lines from dmesg seems not relevant. Should I post them too?

Usually best to post all the data and let us sort it out, yes.

-Eric

> PS: Writing to disk from jbd2/dm-3-8 still active (iotop shows it still on top of I/O activity).
> 
> LuVar
> 
> ----- "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
>> On Mon, Jul 30, 2012 at 08:26:20PM +0100, LuVar wrote:
>>> Hi,
>>> I have seriouse issue here. I have copyied about 7GB files to one of
>> my ext4 partitions and from that point of time there is sustained
>> write to that partition from jbd2/dm-3-8 process. I have lunched "sudo
>> sync" command (about day ago :) and a few hours a after sync start, I
>> have tryied to use umount on that partition... Booth of them are still
>> running...
>>>
>>> I have no serious data there, but if I could be helpfull in
>> bugreport, give me some info what to do.
>>
>> Try running the dmesg command, and see if there's anything
>> interesting
>> there.  If you're not sure if it's interesting, send it to us and we
>> can take a quick look at it.
>>
>> Regards,
>>
>> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

