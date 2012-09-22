From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v2] ext4: fix possible non-initialized variable
Date: Fri, 21 Sep 2012 20:52:02 -0400
Message-ID: <20120922005202.GD27207@thunk.org>
References: <505739F8.9050305@redhat.com>
 <50574226.3020908@redhat.com>
 <20120917153701.GA5510@thunk.org>
 <20120917182604.GA1959@andromeda.usersys.redhat.com>
 <20120918035931.GB32195@thunk.org>
 <20120918125155.GA30408@andromeda.usersys.redhat.com>
 <20120919201057.GA23237@andromeda.usersys.redhat.com>
 <20120919204100.GF28470@thunk.org>
 <505A8678.4060402@redhat.com>
 <20120921191449.GA18336@andromeda.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51986 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab2IVAwE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2012 20:52:04 -0400
Content-Disposition: inline
In-Reply-To: <20120921191449.GA18336@andromeda.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 21, 2012 at 04:14:49PM -0300, Carlos Maiolino wrote:
> Not a bad idea really.
> 
> I've found some functions properly handling the problem (i.e !bh and !err), but
> some of them not. I'm thinking in fix functions with missing hole handlers and
> after that think about a 'default directory hole handler' for this, instead of
> make each function work on a specific way.

I'd have to take a look at a patch, but I didn't think there would be
enough code to be worth factoring out into a separate function.  It's
just a conditional, a call to ext4_error(), and then setting up the
return code and releasing resources that need to be released on our
way out (which tends to be function-specific).

Am I missing something?

						- Ted
