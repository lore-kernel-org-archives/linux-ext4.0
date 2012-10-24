From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Wed, 24 Oct 2012 21:34:45 +0100
Message-ID: <87hapjtxqy.fsf@spindle.srvr.nix>
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
	<50884FF6.7030107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:60405 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab2JXUe6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2012 16:34:58 -0400
In-Reply-To: <50884FF6.7030107@redhat.com> (Eric Sandeen's message of "Wed, 24
	Oct 2012 15:30:46 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 24 Oct 2012, Eric Sandeen uttered the following:

> On 10/24/2012 02:49 PM, Nix wrote:
>> On 24 Oct 2012, Theodore Ts'o spake thusly:
>>> Toralf, Nix, if you could try applying this patch (at the end of this
>>> message), and let me know how and when the WARN_ON triggers, and if it
>>> does, please send the empty_bug_workaround plus the WARN_ON(1) report.
>>> I know about the case where a file system is mounted and then
>>> immediately unmounted, but we don't think that's the problematic case.
>>> If you see any other cases where WARN_ON is triggering, it would be
>>> really good to know....
>> 
>> Confirmed, it triggers. Traceback below.
>
> <giant snip>
>
> The warn on triggers, but I can't tell - did the corruption still occur
> with Ted's patch?

Yes. I fscked the filesystems in 3.6.1 after rebooting: /var had a
journal replay, and the usual varieties of corruption (free space bitmap
problems and multiply-claimed blocks). (The other filesystems for which
the warning triggered had neither a journal replay nor corruption.
At least one of them, /home, likely had a few writes but not enough to
cause a journal wrap.)

I note that the warning may well *not* have triggered for /var: if the
reason it had a journal replay was simply that it was still in use by
something that hadn't died, the umount -l will have avoided doing a full
umount for that filesystem alone.

Also, the corrupted filesystem was mounted in 3.6.3 exactly once.
Multiple umounts are not necessary, but an unclean umount apparently is.

-- 
NULL && (void)
