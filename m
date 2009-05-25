From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: zero out blocks of freed user data for operation a virtual
	machine environment
Date: Mon, 25 May 2009 16:01:51 +0200
Message-ID: <20090525140151.GE5534@cip.informatik.uni-erlangen.de>
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de> <20090524101551.57b706e9@infradead.org> <20090524173933.GD24753@cip.informatik.uni-erlangen.de> <20090525120320.GA25908@mit.edu> <20090525123430.GA5534@cip.informatik.uni-erlangen.de> <87ab51qq91.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>, tytso@thunk.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:63481 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbZEYOBu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2009 10:01:50 -0400
Content-Disposition: inline
In-Reply-To: <87ab51qq91.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Goswin,

> I could imagine a device mapper target that eats TRIM commands and
> writes out zeroes instead. That should be easy to maintain outside or
> inside the upstream kernel source.

again an interesting option and for sure easy to handle. However what
I'm really looking for is an option that gets upstream and will be
incorperated in major distributions so that this option is available on
every Linux distribution shipping in two years. However if this won't be
the case I'm going to consider writing a device mapper target.

        Thomas
