From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Wed, 29 Dec 2010 18:14:04 +0100
Message-ID: <AANLkTindNuT0EKkMW1e8syPLEr_j3zRFS++otMQp42B9@mail.gmail.com>
References: <20101224095105.GG12763@thunk.org>
	<AANLkTinjtoF0gOdi6TV+RPjMkeqA8fcrkJBYRBd5WQ==@mail.gmail.com>
	<AANLkTi=g4zvxdQdnS7crg015sexk3NSJ3CaODi_c=6Fv@mail.gmail.com>
	<AANLkTinHa1wLB6hKi_xwiQNwMb1xZs-pa1sLB=ebtjiX@mail.gmail.com>
	<AANLkTinXd8Zf=13HSYTxsAUc02jbCgV=17UqXQyFxNUG@mail.gmail.com>
	<AANLkTi=ihgiJAsJ+hSeRjhcOTUhY5YC-xPDRPT0ws+oB@mail.gmail.com>
	<20101226221016.GF2595@thunk.org>
	<AANLkTikS8hJtqxRrc3CqQs591bSkynQT1hg=vR4QBo0J@mail.gmail.com>
	<4D18B106.4010308@ontolinux.com>
	<AANLkTimMSxGTEcTbsx8MUYVTLhYRxrdDFQsi6Toer_h9@mail.gmail.com>
	<4D18E94C.3080908@ontolinux.com>
	<AANLkTikW8K4VFLJuYngU64m2vAL1yhA3R=jRt7U6-RRp@mail.gmail.com>
	<20101229075928.6bdafb08@notabene.brown>
	<AANLkTikZ5wFf0KHiLFNxUO=0EGTqb5Ce-GDTVnGCCUaD@mail.gmail.com>
	<20101229093158.2bfed8ca@notabene.brown>
	<AANLkTinkHQ2tqAzqo77Bg_iyyYWUE72V85rTQqsEH4Nc@mail.gmail.com>
	<4D1B542B.9030400@ontolinux.com>
	<AANLkTimpsDAUt6KnE=qmcbRLdZdaSaqxvJFh0Ki3iV7B@mail.gmail.com>
	<4D1B621B.5000804@ontolinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	Nick Piggin <npiggin@gmail.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0L2ROF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Dec 2010 12:14:05 -0500
In-Reply-To: <4D1B621B.5000804@ontolinux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 29, 2010 at 5:30 PM, Christian Stroetmann
<stroetmann@ontolinux.com> wrote:
>> Additional steps compared to what? The temp file, fsync, rename case?
>
> read the paragraphs as a whole

Reading stuff again isn't going to change my question.

>>> And the advice to use a well-known DBMS is simply based on the knowledge
>>> that it has all the needed functionality already implemented in a highly
>>> performant way, and on the knowledge that such a solution is used oftenly
>>> for comparable use cases due to the cost vs. benefit ratio.
>>> To take a look at the Reiser4 FS could also help.
>>
>> I don't think storing all my conf files, executables, libraries etc in
>> a DBMS is a good idea...
>
> read the whole both threads started by you again

And then what?

Olaf
