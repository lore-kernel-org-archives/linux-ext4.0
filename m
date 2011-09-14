From: Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [RFC PATCH 0/3] VFS: Fix s_umount thaw/write deadlock
Date: Wed, 14 Sep 2011 16:22:29 -0700
Message-ID: <CAD-Xujm2YY8TarQEJLC8c4VgZpssjDdts8=Pz2NLgt+kT5zDCA@mail.gmail.com>
References: <CAD-Xujmjai2evYC4a4CdNPtjh_9xhbELcZePtGSS54VPRGpznA@mail.gmail.com>
	<20110914130526.GA7903@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64841 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1INXWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2011 19:22:30 -0400
In-Reply-To: <20110914130526.GA7903@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2011 at 6:05 AM, Jan Kara <jack@suse.cz> wrote:
>> fs/reiserfs/procfs.c
>> =A0- dropped after get_super() call in /proc operation
>> =A0 =A0XXX don't know, need a reiser expert
> =A0Where exactly do we hold s_umount? Anyway, nothing in reiserfs/pro=
cfs.c
> does not seem to involve writes.

Sorry, this actually calls sget(), not get_super().  And I agree,
there aren't any writes.  Audit updated accordingly.

Thanks!

-VAL
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
