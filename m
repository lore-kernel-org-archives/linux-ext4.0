From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: e4defrag and immutable files
Date: Tue, 1 Jun 2010 16:14:02 -0400
Message-ID: <AANLkTil653uFeOct17hj10HbbjBabDPCW6hlAeTQxhxH@mail.gmail.com>
References: <4C002427.3010706@zytor.com>
	<4C05604D.2070401@oracle.com>
	<20100601194924.GF4426@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-ext4@vger.kernel.org,
	Joel Becker <Joel.Becker@oracle.com>,
	Mark Fasheh <mfasheh@suse.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56083 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab0FAUOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jun 2010 16:14:03 -0400
Received: by gye5 with SMTP id 5so1501633gye.19
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jun 2010 13:14:03 -0700 (PDT)
In-Reply-To: <20100601194924.GF4426@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 1, 2010 at 3:49 PM,  <tytso@mit.edu> wrote:
> On Tue, Jun 01, 2010 at 12:32:29PM -0700, Sunil Mushran wrote:
>>
>> We (ocfs2) are looking to add a new attribute to denote files that
>> have a fixed allocation on disk. But at the same time, allow writes
>> that do not change the allocation on disk. No truncating, extending,
>> filling holes, etc. We were thinking of calling it "Static" files.
>
> That's an interesting set of semantics, and it might make sense to
> conflate that with a local disk "don't move or defrag" the file
> option. =A0I'm not crazy with the name "static", since it could mean =
a
> number of other things in other contexts, but I admit I can't think o=
f
> a better name.

=46ROZEN?

PRE-ALLOCATED?

=46ALLOCATE_ONLY?

=46ROZEN_ALLOCATION?

STATIC_ALLOCATION?

I like the last 2 choices myself.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
