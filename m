From: Junio C Hamano <gitster@pobox.com>
Subject: Re: [GIT PULL] ext4 bugfixes for 3.2-rc5
Date: Tue, 20 Dec 2011 21:28:15 -0800
Message-ID: <7vd3biijdc.fsf@alter.siamese.dyndns.org>
References: <E1RauNd-0008W1-02@tytso-glaptop.cam.corp.google.com>
 <CA+55aFw6n=WaDWRn7NqtBei1x0-w1PkH5x6r3iQSSPZvxYvDhQ@mail.gmail.com>
 <20111215190846.GA2709@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:56595 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab1LUF2S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Dec 2011 00:28:18 -0500
In-Reply-To: <20111215190846.GA2709@thunk.org> (Ted Ts'o's message of "Thu,
 15 Dec 2011 14:08:46 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o <tytso@mit.edu> writes:

> Cool!  Does it save enough that GPG signature information can be
> verified later?  I'm a little fuzzy on what is covered by the
> signature which gets verified when you run the command "git verify-tag
> tytso-for-linus-20111214".  Better yet, does the new version of git
> have a command that will automatically verify the digital signature
> found in a merge commit?
>
> And this isn't in 1.7.8 yet, right?  I'd have to build version of git
> based on the next branch to play with this new signatury goodness?

The 'master' branch as of this week has the topic merged.


