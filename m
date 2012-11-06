From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: why has "fix ext4_ext_remove_space tree traversal" not been
 applied?
Date: Tue, 6 Nov 2012 08:17:51 -0500
Message-ID: <20121106131751.GA3242@thunk.org>
References: <20632.64737.272834.202562@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59612 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab2KFNSA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2012 08:18:00 -0500
Content-Disposition: inline
In-Reply-To: <20632.64737.272834.202562@fisica.ufpr.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 06, 2012 at 10:04:49AM -0200, Carlos Carvalho wrote:
> In 3.6.6 some of the patches of the series "Bunch of DIO/AIO fixes V4"
> by Dmitry Monakhov have been applied but not all. In particular, patch
> 9, "fix ext4_ext_remove_space tree traversal" is not there. We're
> getting hit by the null pointer dereference in our main file servers.
> 
> What's the situation of this patch? Any reason it's not applied?

Patches which which change a large amount of code don't get the
cc:stable@vger.kernel.org label applied to them, primarily because of
the risk involved and the likelihood that those patches won't easily
get backported to the older stable kernels.

Keep in mind that the way things work is that patches that are tagged
for the stable kernel tree automatically get cherry-picked, and if the
cherry-pick fails, the patch is dropped.  For a complex patch series,
sometimes dropping a patch in the middle of the patch series can lead
to really bad results --- and while I do extensive regression testing
on the mainline kernel before I send a PULL request to Linus, I just
don't have the time or energy to do this with the (many) stable
kernels series.

Enterprise distro's have paid people who do this thankless job, and it
can be quite painful at times to support an old stable kernel,
especially when users are using it in production and they will scream
bloody murder if you introduce a regression.  So they generally solve
the problem by not sticking with a very old patch, and not giving
users access to the latest and greatest features --- such as
the punch hole feature.

The problem is that users want the latest and greatest features, right
away, but they also want something is absolutely stable and
bug-free(tm).  Unfortunately, sometimes both wants can not be
accomodated...

					- Ted
