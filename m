From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 2/3] jbd2: Add extra parameter in
 start_this_handle() to control allocation flags.
Date: Mon, 20 Jun 2011 13:57:20 -0400
Message-ID: <20110620175720.GD32133@thunk.org>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563657-4334-1-git-send-email-mkatiyar@gmail.com>
 <20110531112253.GD5614@quack.suse.cz>
 <20110531222720.GA3867@thunk.org>
 <20110602095424.GA5718@quack.suse.cz>
 <20110606032113.GC7180@thunk.org>
 <20110608141006.GG30037@thunk.org>
 <BANLkTikVuPx8F8DSdjFxZyR8ZA0ts3hQ_w@mail.gmail.com>
 <20110620143201.GD4810@quack.suse.cz>
 <BANLkTi=nZrq9ZfU3G=YS6ZmZMhhD5g+tCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58844 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1FTR5Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jun 2011 13:57:25 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=nZrq9ZfU3G=YS6ZmZMhhD5g+tCg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 20, 2011 at 07:40:53AM -0700, Manish Katiyar wrote:
> > =A0OK, after my discussion with Ted today, i_mutex really shouldn't=
 be an
> > issue so your patch should be fine. I just suggest you resend it to=
 Ted to
> > remind yourself :).
>=20
> Thanks a lot Jan, Will resend the series to Ted.

Thanks, but don't bother resending it unless you have any changes to
update.

I do keep track of patches using patchwork[1], so I haven't forgotten. =
 :-)

[1] http://patchwork.ozlabs.org/project/linux-ext4/list/

I'll be starting to go through patches for the next merge window this
week.

							- Ted


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
