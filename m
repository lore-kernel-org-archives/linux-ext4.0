From: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Subject: Re: [PATCH, RFC] jbd2: don't write non-commit blocks synchronously
Date: Thu, 6 Mar 2014 19:45:32 +0100
Message-ID: <20140306184532.GA15459@xanadu.blop.info>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140306135642.GA22136@thunk.org>
 <20140306172801.GA12751@xanadu.blop.info>
 <20140306182729.GA30706@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from xanadu.blop.info ([178.79.145.134]:36289 "EHLO xanadu.blop.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbaCFSpn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 13:45:43 -0500
Content-Disposition: inline
In-Reply-To: <20140306182729.GA30706@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/03/14 at 13:27 -0500, Theodore Ts'o wrote:
> Hmm... OK, let me make sure I understand what is going on.  So you
> have a single file system which is mounted read/write,

Yes

> and you are
> doing a huge number of copies into the file system, which is keeping
> it busy.

On that minimal system, I'm just copying ~300 MB of data. I wouldn't
qualify it as huge.

> You are then running a huge number of "mount -o remount" on
> that same file system,

at the same time as the data copy, yes.

> which should effectively be no-op's, since the
> remount isn't actually change the read/only or read/write or any other
> mount options.  Is that right?

Yes

> Why were you doing the remount in in your actual production workload,
> anyway?

We are booting a large number (hundreds) of LXC containers in order to
setup an experimental environment. Those LXC containers simply use
subdirectories on the ext4 filesystem as root directory.
What we saw is that the boot of LXC containers "deadlocked".

We later discovered that:
- this was caused by Debian's /etc/init.d/checkroot.sh that calls
  mount -o remount,defaults,rw 
- it was not a deadlock, but rather something looking like severe lock
  contention. After a seemingly random amount of time (2 to to 15 mins),
  the boot of LXC containers finishes.
- it was possible to reproduce the problem outside of LXC, using the
  "write data and do lots of remounts at the same time" setup I
  described earlier.
-- 
| Lucas Nussbaum      Assistant professor @ Univ. de Lorraine |
| lucas.nussbaum@loria.fr                   LORIA / AlGorille |
| http://www.loria.fr/~lnussbau/            +33 3 54 95 86 19 |
