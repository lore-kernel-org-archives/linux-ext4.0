From: "Maar, Roberto" <roberto.maar@ts.fujitsu.com>
Subject: Re: [SOLVED] (was "Re: Restoring filenames from partly damaged
 ext4-filesystem")
Date: Mon, 13 Feb 2012 11:00:21 +0100
Message-ID: <6D9A985A8374004AA880FD5D70B2D3C449AE04494A@ABGEX73E.FSC.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dgate20.ts.fujitsu.com ([80.70.172.51]:41081 "EHLO
	dgate20.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2BMKKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Feb 2012 05:10:03 -0500
Content-Language: de-DE
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list !

I am the developer of ext4magic

On Sat, Feb 11, 2012 at 11:47:14AM -0700, Andreas Dilger wrote:
>> Looks interesting and useful...  I wonder if it makes sense to include
>> this into e2fsprogs at some point, so that it is available when users
>> need it most...

Ted Ts'o wrote:
> We'll need to talk to the author about that.  At the very least it
> would be good to translate the ext4magic wiki into English, so that
> people who are doing web searches are more likely to find it.  :-)

I think inside of e2fsprogs is not the place for ext4magic. 
A good optional extension, probably, but a standard tool, never.
There are destroyed, deleted or lost structures and there is a lot of
heuristic function. Installation on a production server is a no go for
any administrator. 
Useable for some small forensic problems and a last chance to recover
some lost files. Nobody needs this regularly.
Everyone has a good backup, and no one destroy its files and file systems.
It is very rarely needed. The users prefer extundelete. This is buggy,
the development sleeps for 2 years, on the mailing list no answers,
but it is easy to use and there are many HOWTOs, and all love it  ;-)

One of the problems of ext4magic, of course, no English documentation.
But at the moment is the one man show, and my English is a disaster. 
The world would laugh at it. I need some help for translation. 
Proofread, for a native speaker with technical understanding a few minutes work,
for me ...
We'll see, I try

Regards,
Roberto Maar
 





