From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Sat, 27 Oct 2012 16:23:07 -0500
Message-ID: <508C50BB.2040300@redhat.com>
References: <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <508AF3FA.4020506@redhat.com> <87wqydx957.fsf@spindle.srvr.nix> <20121026205618.GC8614@thunk.org> <87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org> <87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org> <873910xevu.fsf@spindle.srvr.nix> <20121027175534.GA7783@thunk.org> <87fw4zzra3.fsf@spindle.srvr.nix> <508C4FE5.1030102@redhat.com> <878varzk56.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab2J0VXN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Oct 2012 17:23:13 -0400
In-Reply-To: <878varzk56.fsf@spindle.srvr.nix>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/27/12 4:21 PM, Nix wrote:
> On 27 Oct 2012, Eric Sandeen verbalised:
>> That's what we needed.  Woulda been great a few days ago ;)
> 
> *wince* sorry!
> 

It's ok, I know sometimes this testing takes time.

It has exposed the fact that we are not doing a good job
regression testing all of the available configurations.

-Eric
