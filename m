From: Kailas Joshi <kailas.joshi@gmail.com>
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Wed, 17 Feb 2010 21:07:25 +0530
Message-ID: <38f6fb7d1002170737l1e9e3b72ub08e106283c26501@mail.gmail.com>
References: <20100209174145.GU4494@thunk.org>
	 <38f6fb7d1002102332v3482ef49xb2afd5931c5eb2ad@mail.gmail.com>
	 <20100211195624.GM739@thunk.org>
	 <38f6fb7d1002111922i4ae6131w6b5cce79344efc63@mail.gmail.com>
	 <20100212200726.GD5337@thunk.org>
	 <38f6fb7d1002130043s54e61e74jcc3297aeeac294b0@mail.gmail.com>
	 <20100215150021.GE3434@quack.suse.cz>
	 <38f6fb7d1002160210x6dc86fb5o82825e7677c07994@mail.gmail.com>
	 <20100216131039.GB3153@quack.suse.cz>
	 <20100216141854.GT5337@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Jiaying Zhang <jiayingz@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:57308 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0BQPh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Feb 2010 10:37:26 -0500
Received: by pzk17 with SMTP id 17so6415476pzk.4
        for <linux-ext4@vger.kernel.org>; Wed, 17 Feb 2010 07:37:25 -0800 (PST)
In-Reply-To: <20100216141854.GT5337@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 16 February 2010 19:48,  <tytso@mit.edu> wrote:
> On Tue, Feb 16, 2010 at 02:10:39PM +0100, Jan Kara wrote:
>> =A0 Actually, stalling on a transaction in LOCKED state does have a =
negative
>> impact on the filesystem performance. But it's hard to avoid it. The
>> transaction is in LOCKED state while we've decided it needs a commit=
 but
>> there are still tasks which have handle to it and are adding new met=
adata
>> buffers to it. So this transaction is effectively still running and =
we
>> cannot start a next transaction because then we'd have two running
>> transactions and the journalling logic isn't able to handle that.
>
> This is also why we try to avoid staying in LOCKED state for very
> long.... and why increasing the journal size can help performance
> (since if we get ourselves into trouble where are forced to do a
> journal checkpoint, we can end up stalling all file system updates fo=
r
> a non-trivial amount of time).
>
> So changes that increase the amount of time that we spend in LOCKED
> are going to be really bad, especially if you have one thread which i=
s
> frequently calling fsync() (for example, like Firefox, which can be
> *very* fsync() happy) and another thread which is doing lots of file
> creates and deletes. =A0Each fsync() will force a transaction commit,
> and if you have to stop all transaction updates while the delayed
> allocation blocks are getting resolved, life can really get bad.

Okay. It seems that there is no easy way to solve this. Probably, the
personality flag based solution is more appropriate.
Still, as we need this mode of operation for our further analysis, for
now we will go with the same design to implement alloc_on_commit and
see how can we optimize it and how much negative impact it has. Will
update you on this.

Thank you very much for the help.

Regards,
Kailas
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
