From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
Date: Fri, 25 Dec 2009 10:56:53 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0912251054200.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org> <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de> <20091225161453.GD32757@thunk.org>
 <20091225162238.GB19303@bitmover.com> <20091225163341.GE32757@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Larry McVoy <lm@bitmover.com>,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: tytso@mit.edu
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20091225163341.GE32757@thunk.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 25 Dec 2009 at 11:33, tytso@mit.edu wrote:
> caches, though; if you are going to measure read as well as writes,
> then you'll probably want to do something like "echo 3 >
> /proc/sys/vm/drop-caches".

Thanks for the hint, I could find sys/vm/drop-caches documented in 
Documentation/ but it's good to know there's a way to flush all these 
caces via this knob. Maybe I should add this to those "genric" tests to be 
more comparable to the other benchmarks.

Christian.
-- 
BOFH excuse #210:

We didn't pay the Internet bill and it's been cut off.
