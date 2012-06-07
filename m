From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [dm-devel] EXT4-fs error (device dm-42):
 ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in
 gd
Date: Thu, 7 Jun 2012 18:54:46 -0400
Message-ID: <20120607225446.GK19839@thunk.org>
References: <471046920.20120604234941@eikelenboom.it>
 <20120605000356.GM29466@outflux.net>
 <1018371644.20120605224154@eikelenboom.it>
 <20120605210806.GB7182@thunk.org>
 <1883708187.20120606090126@eikelenboom.it>
 <CAGXu5jK-4dO59-x3eTU10OntcPwsVptjpUzQdbbHOvy9_VBQ2A@mail.gmail.com>
 <1482118647.20120606164012@eikelenboom.it>
 <20120607042756.GA30776@thunk.org>
 <20120607222729.GI6938@tux1.beaverton.ibm.com>
 <CAGXu5jKmBkfvuSR7q47-Ac57dVZynz_JkYXiA_-aXaGQiR_C4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: djwong@us.ibm.com, Sander Eikelenboom <linux@eikelenboom.it>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48408 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834Ab2FGWyy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jun 2012 18:54:54 -0400
Content-Disposition: inline
In-Reply-To: <CAGXu5jKmBkfvuSR7q47-Ac57dVZynz_JkYXiA_-aXaGQiR_C4g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 07, 2012 at 03:40:40PM -0700, Kees Cook wrote:
> 
> FWIW, I was building the filesystem that triggered this as ext4:
> 
>   mkfs.ext4 -T default -m 0 -O ^huge_file,^flex_bg -E
> discard,lazy_itable_init /dev/mapper/...

Ouy of curiosity, was there a reason you chose those particular file
system parameters?  It's a surprising set, because if you're starting
with a fresh file system, enabling flex_bg produces a more optimal
file system layout.

The reason why I wrote the commit description way I did was because it
seemed to be the most likely way that someone would trip across this
bug.  We didn't notice this for as long as we did since most of the
users of ext4 (especially those who use community distributions) have
been using freshly mkfs'ed ext4 file systems.

						- Ted
