From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Wtrlt: Re: Re: Slow to add 1 million items
Date: Fri, 07 Feb 2014 08:24:33 +0100
Message-ID: <52F49841020000A100014463@gwsmtp1.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:41332 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaBGHaY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-ext4@vger.kernel.org:1:1>);
	Fri, 7 Feb 2014 02:30:24 -0500
Received: from rrzmta2.uni-regensburg.de (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 9570944E87
	for <linux-ext4@vger.kernel.org>; Fri,  7 Feb 2014 08:24:35 +0100 (CET)
Received: from gwsmtp1.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "gwsmtp.uni-regensburg.de", Issuer "Uni Regensburg CA - G01" (not verified))
	by rrzmta2.uni-regensburg.de (Postfix) with ESMTPS id 6DF1344E30
	for <linux-ext4@vger.kernel.org>; Fri,  7 Feb 2014 08:24:35 +0100 (CET)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

(I'm surprised that ext2/ext3/ext4 all use the same mailing list ;-)

Maybe some of you find there performance data interesting. Personally I found them surprising (expecting ext4 to outperform ext2 and ext3)...

>>> Andrew Eross <eross@locatrix.com> schrieb am 06.02.2014 um 16:59 in Nachricht
<CAL_tfFdS4suKqn7ZFSkFGQ1rE7qEhsyyGOs0RqV_Ow71J_Ri8Q@mail.gmail.com>:
> Hi guys,
> 
> Ulrich - thanks for the suggestions - btrfs in particular is certainly
> worth a shot.
> 
> Quanah - very cool to hear about the 12.04 kernel and ext2 suggestions.
> thanks!
> 
> I've just run some new tests on a similar machine with 12.04.4 LTS and a
> newly installed 3.11.0-15-generic x86_64 kernel.
> 
> Exact same testing method as before, 10K records, etc:
> 
> Running on an ext4 partition:
> 
> Base-line, no extra options: 5m14s
> With "writemap" enabled: 9m40s
> With "writemap+mapasync" enabled: 4m35s
> 
> Overall, about the same as 10.04 for me.
> 
> I created a new ext2 partition to give that a shot on the 12.04 box.
> 
> Base-line, no extra options: 1m31s
> With "writemap" enabled: 1m33s
> With "writemap+mapasync" enabled: 1m41s
> 
> Ahah! I'd say that's the killer answer.
> 
> Summary for future generations who may see this thread:
> 
> 1) Using ext2 for your db directory (on Ubuntu at least) is waay faster
> than ext4 (~2-3x as fast according to my tests). This is the secret as far
> as I'm concerned since you can use this while still using the most
> conservative DB options that don't risk your data.
> 2) Using "dbnosync+checkpoint" with mdb is the absolute fastest method, but
> at the cost of risking data loss
> 
> Cheers,
> Andrew
> 
> 
> On Thu, Feb 6, 2014 at 5:08 AM, Ulrich Windl <
> Ulrich.Windl@rz.uni-regensburg.de> wrote:
> 
>> >>> Andrew Eross <eross@locatrix.com> schrieb am 05.02.2014 um 16:30 in
>> Nachricht
>> <CAL_tfFf2qW5BcT=Xs4uFOSUO=wL0AN=9CyfS+D-XYPLitMZ_aw@mail.gmail.com>:
>> > Hi Quanah,
>> >
>> > Ubuntu 10.04 LTS
>> > Linux 2.6.32-43-generic-pae #97-Ubuntu SMP Wed Sep 5 16:59:17 UTC 2012
>> i686
>> > GNU/Linux
>> > The latest OpenLDAP 2.4.39
>> > All of those tests done with the mdb backend, of course, and the actual
>> > file system is ext4
>>
>> Did you try btrfs? I'd guess it could be faster for massive random writes.
>>
>> >
>> > It's a fairly stock 10.04 system, no special config/kernel changes.
>> >
>> > Cheers,
>> > Andrew
>> >
>> > On Wed, Feb 5, 2014 at 1:26 PM, Quanah Gibson-Mount <quanah@zimbra.com 
>> >wrote:
>> >
>> >> --On Tuesday, February 04, 2014 6:52 PM -0200 Andrew Eross <
>> >> eross@locatrix.com> wrote:
>> >>
>> >>
>> >>>
>> >>> Thanks, Dieter, Quanah.
>> >>>
>> >>>
>> >>> I've been doing some experimenting with those mdb options.
>> >>>
>> >>>
>> >>> I ran a few tests with inserting 10,000 records, wiping the DB in
>> >>> between, and changing just the one option at a time:
>> >>>
>> >>>
>> >>> Base-line, no extra options: 4m8sWith "writemap" enabled: 8m55s
>> >>>
>> >>> With "writemap+mapasync" enabled: 5m12s
>> >>> With "dbnosync+checkpoint 0kb/1min": 0m14s
>> >>>
>> >>
>> >> I know you answered some of this before, but please update with:
>> >>
>> >> What kernel?
>> >> What OpenLDAP version?
>> >> What Ubuntu release?
>> >> What filesystem for the LDAP DB?
>> >>
>> >> Thanks,
>> >>
>> >> Quanah
>> >>
>> >>
>> >> --
>> >>
>> >> Quanah Gibson-Mount
>> >> Architect - Server
>> >> Zimbra, Inc.
>> >> --------------------
>> >> Zimbra ::  the leader in open source messaging and collaboration
>> >>
>>
>>
>>
>>



