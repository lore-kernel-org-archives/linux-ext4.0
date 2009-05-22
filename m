From: Matteo Croce <matteo@openwrt.org>
Subject: Re: EXT4-fs error in ext4_reserve_inode_write: Journal has aborted
Date: Fri, 22 May 2009 14:23:53 +0200
Message-ID: <40101cc30905220523y47c07f12yb6621095fbf0769c@mail.gmail.com>
References: <40101cc30905201635t6af2586bne1acbc77216628ee@mail.gmail.com>
	<4A14AC12.4000108@redhat.com> <40101cc30905220131t48d3de40y89beafb15d9e2201@mail.gmail.com>
	<20090522111039.GB11742@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:30301 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737AbZEVMYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 May 2009 08:24:14 -0400
Received: by ey-out-2122.google.com with SMTP id 9so464435eyd.37
        for <linux-ext4@vger.kernel.org>; Fri, 22 May 2009 05:24:14 -0700 (PDT)
In-Reply-To: <20090522111039.GB11742@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

SCSI error, status {DRDY}

sort of

On Fri, May 22, 2009 at 1:10 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, May 22, 2009 at 10:31:17AM +0200, Matteo Croce wrote:
>> the HD seems to reset soon.
>> can it be an hardware problem?
>
> I'm not sure what you mean by "the HD seems to reset soon"?
>
> If there was a "Journal has aborted" error, there must have been some
> some other ext4 or jbd2 reported problem earlier in the log that
> caused the journal to have aborted. =A0Could you search your log file
> for anything beforehand mentioning "ext4", "EXT4-fs", or "jbd2", or
> "journal"?
>
> Thanks,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 - Ted
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
