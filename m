From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Sat, 27 Oct 2012 19:47:00 +0100
Message-ID: <87fw4zzra3.fsf@spindle.srvr.nix>
References: <874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508AF3FA.4020506@redhat.com>
	<87wqydx957.fsf@spindle.srvr.nix> <20121026205618.GC8614@thunk.org>
	<87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org>
	<87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org>
	<873910xevu.fsf@spindle.srvr.nix> <20121027175534.GA7783@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:41635 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808Ab2J0SrJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Oct 2012 14:47:09 -0400
In-Reply-To: <20121027175534.GA7783@thunk.org> (Theodore Ts'o's message of
	"Sat, 27 Oct 2012 13:55:34 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 27 Oct 2012, Theodore Ts'o said:

> On Sat, Oct 27, 2012 at 01:45:25PM +0100, Nix wrote:
>> Ah! it's turned on by journal_async_commit. OK, that alone argues
>> against use of journal_async_commit, tested or not, and I'd not have
>> turned it on if I'd noticed that.
>> 
>> (So, the combinations I'll be trying for effect on this bug are:
>> 
>>  journal_async_commit (as now)
>>  journal_checksum
>>  none
>
> Can you also check and see whether the presence or absence of
> "nobarrier" makes a difference?

Done. (Also checked the effect of your patches posted earlier this week:
no effect, I'm afraid, certainly not under the fails-even-on-3.6.1 test
I was carrying out, umount -l'ing /var as the very last thing I did
before /sbin/reboot -f.)

nobarrier makes a difference that I, at least, did not expect:

[no options]                    No corruption

nobarrier                       No corruption

          journal_checksum      Corruption
                                Corrupted transaction, journal aborted
                                
nobarrier,journal_checksum      Corruption
                                Corrupted transaction, journal aborted

          journal_async_commit  Corruption
                                Corrupted transaction, journal aborted

nobarrier,journal_async_commit  Corruption
                                No corrupted transaction or aborted journal

I didn't expect the last case at all, and it adequately explains why you
are mostly seeing corrupted journal messages in your tests but I was
not. It also explains why when I saw this for the first time I was able
to mount the resulting corrupted filesystem read-write and corrupt it
further before I noticed that anything was wrong.

It is also clear that journal_checksum and all that relies on it is
worse than useless right now, as Eric reported while I was testing this.
It should probably be marked CONFIG_BROKEN in future 3.[346].* stable
kernels, if CONFIG_BROKEN existed anymore, which it doesn't.

It's a shame journal_async_commit depends on a broken feature: it might
be notionally unsafe but on some of my systems (without nobarrier or
flashy caching controllers) it was associated with a noticeable speedup
of metadata-heavy workloads -- though that was way back in 2009...
however, "safety first" definitely applies in this case.

-- 
NULL && (void)
