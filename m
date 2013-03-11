From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Use kstrtoul() instead of deprecated
 simple_strtoul()
Date: Mon, 11 Mar 2013 11:38:01 -0400
Message-ID: <20130311153801.GB4646@thunk.org>
References: <1362730998-3263-1-git-send-email-lczerner@redhat.com>
 <1362730998-3263-2-git-send-email-lczerner@redhat.com>
 <20130311022635.GG10090@thunk.org>
 <alpine.LFD.2.00.1303110830260.24359@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52539 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab3CKPiF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 11:38:05 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1303110830260.24359@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 11, 2013 at 08:36:16AM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> I think that parse_strtoul() is still useful to have because we
> check the "max" value as well and return -EINVAL if it is exceeded.
> Removing it we would have to add the check to the callers
> where we're using is now, which seems unnecessary, especially since
> we might expect more users of the helper.

Well, at the moment only one of the two users of parse_strtoul() is
using the "max" value check feature.  I see one other potential user
of parse_strtoul (there's one use of simple_strtoul in get_sb_block()
which wasn't converted in your patch), but it wouldn't need the max
value check feature either.

So I don't have a super strong feeling about this, since this isn't
performance critical code, and it's probably not going to cost a large
amount of object code or stack space, but sometimes extra levels of
abstraction end up hurting more than they help.

Regards,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
