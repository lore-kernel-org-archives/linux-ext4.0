From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Tue, 18 Mar 2008 00:16:53 -0500
Message-ID: <47DF5045.1000108@redhat.com>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu> <47DEE2AE.1050105@redhat.com> <20080318022053.GL8368@mit.edu> <47DF35CC.7020604@redhat.com> <20080318042339.GO8368@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbYCRFRQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Mar 2008 01:17:16 -0400
In-Reply-To: <20080318042339.GO8368@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> The question then is what to do when the user specifies something
> non-sensical, where they put the filesystem type last.  

Well, I'd say do what they asked, treat the [filesystem type] stanza
just like any other, and anything in it which may override previous
stanzas, does.

> One approach
> would be to use a two-pass algorithm, where you first scan the list
> for any filesystem type or size types, and if so, you suppress
> prefixing the list with the fs_type and size_type.  I think that's
> what you are suggesting.

Not exactly...

> Then there was my approach, which was admittedly partially influenced
> by what was quicker and easier to code, which only checked the
> expected position.

Well, I think that what I'm suggesting (but it's late, and I'm tired, so
it's hard for me to tell for sure... ;) is that there is no special
anything.  You simply take the specified -T arguments in order, and use
that as the search/override order for any setting found in the stanzas
specified.  This would probably be simplest to code, actually, as well
as simplest to document, and even most powerful/flexible for the user.

But, I suppose I can live with

     -T [fs_type,][size_type,]user_type[,additional_type...]

which is reasonably clear, though... we just need to document that there
are 7 special stanza names in 2 categories, which the code will put
there *for* you if you don't put it them the right place, yourself.
It's just, IMHO, a more complicated and restricted specification for the
option.

-Eric
