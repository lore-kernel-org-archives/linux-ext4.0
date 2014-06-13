From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
Date: Fri, 13 Jun 2014 14:57:19 -0500
Message-ID: <539B579F.5000403@redhat.com>
References: <1402625647-31439-1-git-send-email-jpa@google.com> <539A63C1.8010809@redhat.com> <20140613031538.GR4453@dastard> <20140613033029.GS4453@dastard> <CAKP4w2QvVUNp18jnX69eP0hjA-T6zn2sT3TQ-P6zpu-EhXZPAQ@mail.gmail.com> <20140613050703.GT4453@dastard> <20140613142054.GA23180@thunk.org> <20140613143157.GB23180@thunk.org> <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	Geremy Condra <gcondra@google.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: JP Abgrall <jpa@google.com>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaFMT5U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2014 15:57:20 -0400
In-Reply-To: <CAKP4w2S24_z1zK+Pn_Hd+Hoh8BfbpJcEw1Bk685ESWN9r6R8Dw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/13/14, 2:44 PM, JP Abgrall wrote:
> On Fri, Jun 13, 2014 at 7:31 AM, Theodore Ts'o <tytso@mit.edu> wrote:

<snip>

> 
>> If so, you might be better off either doing per-file encryption, or
>> per-file secure discard.
> 
> The per-file secure discard seems to be the way to go, as there are
> only a few places in Android where this needs to be turned on.
> The  current idletime-fstrim would  switch from FITRIM to SFITRIM to
> reduce the leftovers.

Apologies if this is a dumb thing to point out, but...
mmc is the only in-kernel driver (aside from xen) which can
even set the flags necessary to enable secure discard; and then
only if mmc_can_secure_erase_trim() is true, so it depends on
the card, I guess.

I don't know what device you're running on, but figured it might
be worth pointing out that not all hardware even supports this
capability.

-Eric
