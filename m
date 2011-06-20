From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH v2 2/3] jbd2: Add extra parameter in start_this_handle()
 to control allocation flags.
Date: Mon, 20 Jun 2011 07:40:53 -0700
Message-ID: <BANLkTi=nZrq9ZfU3G=YS6ZmZMhhD5g+tCg@mail.gmail.com>
References: <1306563416-4286-1-git-send-email-mkatiyar@gmail.com>
 <1306563657-4334-1-git-send-email-mkatiyar@gmail.com> <20110531112253.GD5614@quack.suse.cz>
 <20110531222720.GA3867@thunk.org> <20110602095424.GA5718@quack.suse.cz>
 <20110606032113.GC7180@thunk.org> <20110608141006.GG30037@thunk.org>
 <BANLkTikVuPx8F8DSdjFxZyR8ZA0ts3hQ_w@mail.gmail.com> <20110620143201.GD4810@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46794 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab1FTOlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jun 2011 10:41:13 -0400
Received: by qyk9 with SMTP id 9so1137577qyk.19
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jun 2011 07:41:13 -0700 (PDT)
In-Reply-To: <20110620143201.GD4810@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 20, 2011 at 7:32 AM, Jan Kara <jack@suse.cz> wrote:
> =A0Hi,
>
> On Thu 16-06-11 23:32:12, Manish Katiyar wrote:
>> On Wed, Jun 8, 2011 at 7:10 AM, Ted Ts'o <tytso@mit.edu> wrote:
>> > Ping?
>>
>> Is there anything required from my side on this patch ? From your
>> other post it seems that holding i_mutex isn't a problem. Please
>> advise.
> =A0OK, after my discussion with Ted today, i_mutex really shouldn't b=
e an
> issue so your patch should be fine. I just suggest you resend it to T=
ed to
> remind yourself :).

Thanks a lot Jan, Will resend the series to Ted.


--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
