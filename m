From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
Date: Thu, 1 Dec 2011 19:50:58 -0500
Message-ID: <CAGpXXZL3CuZj2KmjiYrHNivqesBtVxzq=ZxGHkDPeYVD_tW_Xw@mail.gmail.com>
References: <20111201070052.GA29708@july> <4ED7FA81.9090802@redhat.com> <CAH9JG2WYsybK6aTo3+S58JM568S_YG7YqhP2jfrQ4pQ12GA5UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu, tm@tao.ma,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46049 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab1LBAv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Dec 2011 19:51:29 -0500
In-Reply-To: <CAH9JG2WYsybK6aTo3+S58JM568S_YG7YqhP2jfrQ4pQ12GA5UQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 1, 2011 at 7:01 PM, Kyungmin Park <kmpark@infradead.org> wr=
ote:
> On 12/2/11, Eric Sandeen <sandeen@redhat.com> wrote:
<snip>
> Hi,
>
>> Hm, so if there were freed but un-trimmed blocks at this point, we w=
ill
>> never trim them until we free _another_ block in the group, right? =A0=
That
>> might be a reasonable tradeoff, but it is somewhat surprising behavi=
or.
>>
>> i.e. say we do:
>>
>> mount /mnt
>> rm -rf /mnt/very_big_file
>> umount /mnt

does umount need to force a fitrim if it's available?

>> mount /mnt
>> fitrim /mnt

That way if umount is clean, then the new logic could kick for the
next mount, but if there was not a clean umount, then in addition to
replaying the journal, the next mount could leave the fitrim info not
initialized.

I'm sure there are smarter ways to track it.  The biggest thing I'm
suggesting is for there to at least be a single boolean "fitrim'ed
state flag for the whole filesystem.  that could cleared on mount and
set on a clean umount.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
