From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
Date: Mon, 5 Dec 2011 11:25:38 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1112051117540.4911@dhcp-27-109.brq.redhat.com>
References: <20111201070052.GA29708@july> <4ED7FA81.9090802@redhat.com> <CAH9JG2WYsybK6aTo3+S58JM568S_YG7YqhP2jfrQ4pQ12GA5UQ@mail.gmail.com> <CAGpXXZL3CuZj2KmjiYrHNivqesBtVxzq=ZxGHkDPeYVD_tW_Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1778763954-1323080742=:4911"
Cc: Kyungmin Park <kmpark@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu, tm@tao.ma,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514Ab1LEKZt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 05:25:49 -0500
In-Reply-To: <CAGpXXZL3CuZj2KmjiYrHNivqesBtVxzq=ZxGHkDPeYVD_tW_Xw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1778763954-1323080742=:4911
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 1 Dec 2011, Greg Freemyer wrote:

> On Thu, Dec 1, 2011 at 7:01 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> > On 12/2/11, Eric Sandeen <sandeen@redhat.com> wrote:
> <snip>
> > Hi,
> >
> >> Hm, so if there were freed but un-trimmed blocks at this point, we will
> >> never trim them until we free _another_ block in the group, right?  That
> >> might be a reasonable tradeoff, but it is somewhat surprising behavior.
> >>
> >> i.e. say we do:
> >>
> >> mount /mnt
> >> rm -rf /mnt/very_big_file
> >> umount /mnt
> 
> does umount need to force a fitrim if it's available?

Please, do not. That will be weird, unexpected and also annoying,
because fitrim can take a bit longer depending on the hadrware. So I do
not thing doing fitrim at mount/umount time is a good idea.

> 
> >> mount /mnt
> >> fitrim /mnt
> 
> That way if umount is clean, then the new logic could kick for the
> next mount, but if there was not a clean umount, then in addition to
> replaying the journal, the next mount could leave the fitrim info not
> initialized.
> 
> I'm sure there are smarter ways to track it.  The biggest thing I'm
> suggesting is for there to at least be a single boolean "fitrim'ed
> state flag for the whole filesystem.  that could cleared on mount and
> set on a clean umount.

The flag makes some sense (if we really need some mechanism like that).
But rather than setting it on (mount/umount) time we should set it after
the fitrim and clear it after the unlink.

Thanks!
-Lukas

> 
> Greg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
--8323328-1778763954-1323080742=:4911--
