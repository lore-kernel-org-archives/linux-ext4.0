From: Stefan Assmann <sassmann@kpanic.de>
Subject: Re: RIP [<ffffffff812c3b77>] ext4_release_file+0x37/0xc0 with 4.5-rc6
 when resuming from suspend
Date: Tue, 8 Mar 2016 09:33:43 +0100
Message-ID: <56DE8E67.2060909@kpanic.de>
References: <56DAB3EE.5020203@kpanic.de> <20160306191010.GM10297@thunk.org>
 <56DD3C65.8010304@kpanic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout-40-253.xlhost.de ([84.200.40.253]:38732 "EHLO
	app1a.xlhost.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753545AbcCHIdt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Mar 2016 03:33:49 -0500
In-Reply-To: <56DD3C65.8010304@kpanic.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07.03.2016 09:31, Stefan Assmann wrote:
> On 06.03.2016 20:10, Theodore Ts'o wrote:
>> On Sat, Mar 05, 2016 at 11:24:46AM +0100, Stefan Assmann wrote:
> It is 4.5-rc6 without any changes.
> 
>> I don't see anything in ext4_release_file() that would obviously be a
>> potential problem after a suspend/reasume.  One possibly is that some
>> other piece of code is corrupting memory.
>>
>>> [  882.459687] CPU: 7 PID: 5299 Comm: dhclient Tainted: G        W       4.5.0-0.rc6.git1.1.vanilla.knurd.1.fc23.x86_64 #1
>>
>> Is it always dhclient which is trying to exit?
> 
> Most of the time the screen just stays black, so it's hard to tell. But
> while trying to reproduce just now I hit a null pointer exception in
> anon_vma_interval_tree_remove(), which happened right after initializing
> the exact same USB hub. Your corruption theory is getting more likely.

It's not a USB problem. I disconnected the USB hub and the corruption
remained. However, the backtrace was preceded by
[   32.778070] snd_hda_codec_hdmi hdaudioC0D0: HDMI: pin nid 4 not registered

After making sure snd_hda_codec_hdmi did not get loaded during boot I've
not experienced the issue anymore. Of course I've only tried this a few
times so far, but it looks promising.
Anyway thanks for taking a look, I'll probably follow up on this with
the sound folks.

  Stefan
