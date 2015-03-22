From: Killian De Volder <killian.de.volder@scarlet.be>
Subject: Re: Recovery after mkfs.ext4 on a ext4
Date: Sun, 22 Mar 2015 09:19:17 +0100
Message-ID: <550E7B05.7020703@scarlet.be>
References: <539D555E.3050707@scarlet.be> <20140615132026.GC2180@thunk.org> <539E019C.6060600@scarlet.be> <20140615214403.GA1420@thunk.org> <53A7C4A1.4000603@scarlet.be> <20140623123758.GA14887@thunk.org> <53A857C0.3060401@scarlet.be> <20140623173151.GD14887@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:33592 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbbCVITV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Mar 2015 04:19:21 -0400
In-Reply-To: <20140623173151.GD14887@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 23-06-14 19:31, Theodore Ts'o wrote:
>
> ...
> We do actually keep a linked list of these inode numbers so we can try
> to report a directory name so you know which file has been trashed.
> This happens in pass #2, so the inodes which are invalid are stored in
> pass #1 and only removed in pass #2.  
>
> So if you are seeing gazillions of bad inodes, that could very easily
> be what's going on.  If so, I can imagine having some mode that we
> enter after a hundred inodes where we just ask permission to blow away
> all of the corrupted inodes in pass #1, without waiting until we can
> give you a proper pathname.
> ...
>
>
> 						 - Ted
>
Been thinking, maybe I should rewrite this code to used linked-arrays ?
Linked lists are painfully slow on swap. (and cpu too because of all the cache misses)
Or are we doing a lot of inserts ?

Think it might be worth it ? Would take me a week to learn the code in e2fsck though...
Biggest fear I have is making a mistake in the code that causes silent bugs.

Kind regards, Killian
