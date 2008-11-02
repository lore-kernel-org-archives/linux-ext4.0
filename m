From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: The default assignee for the ext4 component goes nowhere
Date: Sun, 2 Nov 2008 13:48:03 -0800
Message-ID: <20081102134803.28c12d8b.akpm@linux-foundation.org>
References: <E1Kwkhw-0007O5-Mr@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-admin@linux-foundation.org, linux-ext4@vger.kernel.org,
	Sami Liedes <sliedes@cc.hut.fi>,
	=?ISO-8859-1?Q?Fran=E7ois?= Valenduc
	<francois.valenduc@tvcablenet.be>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030AbYKBVsl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Nov 2008 16:48:41 -0500
In-Reply-To: <E1Kwkhw-0007O5-Mr@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 02 Nov 2008 16:42:04 -0500 "Theodore Ts'o" <tytso@mit.edu> wrote:

> Hi,
> 
> The default assignee for bugs filed against the ext4 component is
> fs_ext4@kernel-bugs.osdl.org, which is a black hole.  (It's an invalid
> e-mail address.)   Sami, Fran__ois, my apologies for no one paying
> attention to your bug reports --- we didn't see them.  :-/
> 
> Could we please set the default asignee for bugs filed against the ext4
> component to be set to linux-ext4@vger.kernel.org, please?  Otherwise,
> people who file ext4 bugs may find that they end up going into a black
> hole, unless they remember to also file a pointer to the ext4 mailing
> list.
> 
> Currently bugs filed against ext3 are going to akpm@osdl.org --- Andrew,
> do you mind if ext3 bugs also get sent to linux-ext4@vger.kernel.org, so
> more people can get a heads-up about ext3 bugs that are reported by
> people going through the bugzilla interface?
> 

Go wild.

I think the normal way of doing this is to create an account at bugzilla
called linux-ext4@vger.kernel.org then you can log in using that account
and add it to various assignees using the "users to watch" feature.
