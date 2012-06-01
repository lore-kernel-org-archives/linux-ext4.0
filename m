From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GIT PULL] ext4 updates for 3.5
Date: Fri, 1 Jun 2012 10:56:43 -0700
Message-ID: <CA+55aFxgZupkAotfjUuWcfwTzHDYg0Afezme62P17=EX2KN+UQ@mail.gmail.com>
References: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com>
 <CA+55aFwk8oYx8EKWdT=5cMTLK7RDz8GQdGmHk2KXwcCq+Bb8PA@mail.gmail.com>
 <CA+55aFwwfMTN=WGQGmFO7DYeBUOGA7V4_6XueQS4JAzeykwn3Q@mail.gmail.com> <20120601174336.GA15778@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Junio C Hamano <gitster@pobox.com>,
	Git Mailing List <git@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58287 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809Ab2FAR5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jun 2012 13:57:06 -0400
In-Reply-To: <20120601174336.GA15778@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 1, 2012 at 10:43 AM, Ted Ts'o <tytso@mit.edu> wrote:
>
> So I should do "git request-pull origin git://... ext4_for_linus" nex=
t
> time, right?

Right.

> Sorry about that. =A0I thought it had included the reference to tag
> automatically since the text of the tag showed in the request-pull
> text.

Apparently git request-pull is too damn smart for its own good, and
will find the tags even when they aren't mentioned, making you think
it made it to me. Bot it doesn't - so then I have to go search for
them by hand.

Added Junio and git to the cc: if git finds the tag and uses that for
the request-pull message text, then it should use the tagname for the
pull request line too. Or, alternatively, don't be smart at all, and
force users to name the tag explicitly. The current "both smart and
dumb" combination seems to be the worst of both world.

              Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
