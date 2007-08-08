From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: E2fsprogs git tree
Date: Wed, 08 Aug 2007 10:31:18 +0200
Message-ID: <46B97F56.7070208@bull.net>
References: <E1I7ukw-0001ht-T0@candygram.thunk.org> <46B89C92.5060302@bull.net> <20070807172814.GA21522@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45113 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbXHHIal (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Aug 2007 04:30:41 -0400
In-Reply-To: <20070807172814.GA21522@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso wrote:
> What version of git are you using?  Make sure you are using something
> which is at least git 1.5.x.

Thanks for your answer. I'm using an older version of git, 1.4.4.4.
I've never got any problem with it to download a linux kernel tree usin=
g=20
an http URL, but I will update it.

> The http walkers are *much* more inefficient.  I did try out git-clon=
e
> using the http URL's, and it works, but it's slow.  The other
> possibility is that you have some kind of nasty http transparent prox=
y
> which is corrupting the http protocol stream.  This is why the git
> transport is seriously the much, much, MUCH better alternative.  =20

Yes, we have an http proxy. No problem with it until now.
I will use the git protocol now as you advise me.
Thank you again,

    Val=E9rie
