From: Mark Busheman <markbusheman@gmail.com>
Subject: Re: Does ext4 send FUA to flush disk cache
Date: Mon, 11 Apr 2011 11:23:23 -0700
Message-ID: <BANLkTi=F9c7dU9Rpt3jy5VcRtgvDB5a37Q@mail.gmail.com>
References: <BANLkTikmryaO5r012VwsNzhcaaVQ_4QfzA@mail.gmail.com>
	<DE099CBA-6478-4651-B3E5-F406D0C11C3D@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f194.google.com ([74.125.83.194]:52811 "EHLO
	mail-pv0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab1DKUpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Apr 2011 16:45:45 -0400
Received: by pvg11 with SMTP id 11so949901pvg.1
        for <linux-ext4@vger.kernel.org>; Mon, 11 Apr 2011 13:45:44 -0700 (PDT)
In-Reply-To: <DE099CBA-6478-4651-B3E5-F406D0C11C3D@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks Ted for replying.

>> FUA doesn't cause a cache flush.
Thanks for correcting. Yes FUA does not flush cache. When the FUA bit
is set in the write
command, the drive make sure that the data goes to platters and not to
be put into its
cache for latter writes.

>> Ext4 does send cache flush commands, or barriers, to make sure the d=
ata written to disk
>> is flushed all the way down to the disk platters on transaction comm=
its.
 I have few questions on this and need help:
a. To achieve the above, is any specific options that need to be used
while mounting?
b. Are the above mentioned things done only for data=3Djournal or for
other modes such as
data=3Dordered and writeback?
c. Are they done for metadata, journal and data writes?
d. Can I know what are the commands sent to the drives to do the cache
flush commands
or barriers? Would like to find if the drive support the commands?
e. Is the above true also for ext3 - I posted a similar question to
ext3 forum and have got no
response so far?

Cheers
Mark

On Sun, Apr 10, 2011 at 5:17 AM, Theodore Tso <tytso@mit.edu> wrote:
>
> On Apr 8, 2011, at 6:02 PM, Mark Busheman wrote:
>
>> I plan to use data=3Djournal option with ext4. Would like to know if
>> ext4 send FUA (Forced Unit Access)
>> to flush the disk cache?
>
> FUA doesn't cause a cache flush. =A0 Ext4 does send cache flush comma=
nds, or barriers, to make sure the data written to disk is flushed all =
the way down to the disk platters on transaction commits.
>
> -- Ted
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
