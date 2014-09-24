From: "George Spelvin" <linux@horizon.com>
Subject: Re: [RFC] mke2fs -E hash_alg=siphash: any interest?
Date: 23 Sep 2014 20:37:55 -0400
Message-ID: <20140924003755.31421.qmail@ns.horizon.com>
References: <20140923232206.GI17784@thunk.org>
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:21156 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751239AbaIXAh5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 20:37:57 -0400
In-Reply-To: <20140923232206.GI17784@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Well, yes.  That's why I suggested doing something with a RAM disk.
> Perhaps creating a huge number of zero length files, then unmounting
> the the file system and remounting it, and then deleting the huge
> number of zero length files.
> 
> If that doesn't show an improvement, then it's unlikely any real world
> use case would likely show an improvement.... 

I've been using a file on a persistent file system, but that's
how I've been doing my validation testing.  I'll beat on it some more,
thanks!

> The other thing to consider is what you get if you manage to crack the
> crypto, which is that you might be able to force the worst case
> performance, and possibly cause a directory creation to fail with an
> ENOENT if the huge number of hash collisions cause the two-level htree
> to overfill.

Yes, it's just a DoS, but sometimes that's enough.  As the world comes
to depend more and more on computer servers providing services, denial
thereof becomes powerful.

> Neither is going to get you a huge amount, so it this decreases the
> incentive for someone to spend a lot of effort trying to attack the
> system.  I'm quite certain though that if there is some way such a
> failure could cause an Iranian nuclear centrifuge to fail
> catastrophically, our friends at Fort Meade would have absolutely no
> problems finding an attack.  After all, they did for MD5.  :-)

Just remember that *that* was, at its heart, a DoS attack.  It actually
damaged equipment, and was effective for far longer because it was
sufficiently surreptitious, but its entire goal was denying the "service"
of gas centrifugation.

halfmd4 is, honestly, probably good enough.  It's just that file systems
have a long lifetime, and I'd rather use something well tested.
That's what created this itch; I was picking the parameters for a new
large file system and didn't like the available options.
