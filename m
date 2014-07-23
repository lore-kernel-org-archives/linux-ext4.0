From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/5] ext4: RFC: Encryption
Date: Thu, 24 Jul 2014 00:25:06 +0200
Message-ID: <20140723222506.GA29033@amd.pavel.ucw.cz>
References: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, herbert@gondor.apana.org.au,
	hch@infradead.org, lczerner@redhat.com, tytso@mit.edu,
	tyhicks@canonical.com, serge.hallyn@canonical.com
To: Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34012 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640AbaGWWZJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2014 18:25:09 -0400
Content-Disposition: inline
In-Reply-To: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!
> This patchset proposes a method for encrypting in EXT4 data read and
> write paths. It's a proof-of-concept/prototype only right
> now. Outstanding issues:
> 
>  * While it seems to work well with complex tasks like a parallel
>    kernel build, fsx is pretty good at reliably breaking it in its
>    current form. I think it's trying to decrypt a page of all zeros
>    when doing a mmap'd write after an falloc. I want to get feedback
>    on the overall approach before I spend too much time bug-hunting.
> 
>  * It has not undergone a security audit/review. It isn't IND-CCA2
>    secure, and that's the goal. We need a way to store (at least)
>    page-granular metadata.

http://en.wikipedia.org/wiki/Ciphertext_indistinguishability#Indistinguishability_under_chosen_ciphertext_attack.2Fadaptive_chosen_ciphertext_attack_.28IND-CCA1.2C_IND-CCA2.29

So .. you are trying to say that if I offer Disney ability to decrypt
their chosen data, Disney may be able to prove I have their film
encrypted elsewhere on the disk?

Is it supposed to be IND-CPA secure? I.e. can Disney prove I have
their film on my disk if I don't help them? IND-CCA1?

Can I keep just a subtree (/home/pavel/.ssh) encrypted?

Hmm, I might actually want to try this.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
